// lib/example/printer_screen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg.dart'; // barrel export do package
import 'preview_page.dart'; // preview na mesma pasta example
import 'package:thermal_printer_pkg/thermal_printer_pkg_method_channel.dart'; // method channel helper (ZXing)

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key, required this.device});

  final PrinterDevice device;

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  final GlobalKey _boletoKey = GlobalKey();
  late final PrinterService _printerService;
  late final NativeBluetoothAdapter _nativeAdapter;
  final _methodChannel = MethodChannelThermalPrinterPkg();

  final ScrollController _logScrollController = ScrollController();
  final List<_LogEntry> _logs = [];

  bool _isConnected = false;
  bool _isBusy = false;

  /// PNG do barcode gerado via ZXing — injetado no BoletoWidget antes da captura.
  Uint8List? _barcodePng;

  /// Largura da bobina em dots. Ajuste conforme a impressora conectada.
  /// 384 = 58mm | 576 = 80mm
  static const int _paperWidthDots = 384;

  // Dados do boleto — única fonte de verdade nesta tela.
  static final BoletoData _boletoData = BoletoData(
    beneficiario: 'ABACUS SOLUTIONS TECH LTDA',
    pagador: 'USUÁRIO TESTE INTERFACE',
    valor: 1250.50,
    vencimento: DateTime(2025, 6, 30),
    linhaDigitavel: '23793.38128 60033.062508 63000.063317 9 95020000125050',
    codigoBarras: '23799950200001250503381260033062508630000633',
    nossoNumero: '9 95020000125050',
    instrucoes: [
      'Não receber após o vencimento.',
      'Multa de 2% após vencimento.',
    ],
  );

  @override
  void initState() {
    super.initState();
    _nativeAdapter = NativeBluetoothAdapter()..paperWidthDots = _paperWidthDots;
    _printerService = PrinterService(adapter: _nativeAdapter);
    _log('Dispositivo: ${widget.device.name} (${widget.device.id})', level: _LogLevel.info);
  }

  @override
  void dispose() {
    if (_isConnected) _printerService.disconnect().catchError((_) {});
    _logScrollController.dispose();
    super.dispose();
  }

  // ── Logging ───────────────────────────────────────────────────────────────

  void _log(String message, {_LogLevel level = _LogLevel.debug}) {
    if (!mounted) return;
    final now = TimeOfDay.now();
    final ts = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    setState(() => _logs.add(_LogEntry(ts, message, level)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Ações de conexão / impressão ─────────────────────────────────────────

  Future<void> _connect() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    _log('Tentando conectar...', level: _LogLevel.info);
    try {
      await _printerService.connect(widget.device);
      setState(() => _isConnected = true);
      _log('✓ Conectado com sucesso!', level: _LogLevel.success);
    } on PrinterNotConnectedException catch (e) {
      _log('✗ ${e.message}', level: _LogLevel.error);
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      _log('✗ Erro ao conectar: $e', level: _LogLevel.error);
      _showSnackBar('Erro ao conectar: $e', isError: true);
    } finally {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _disconnect() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    _log('Desconectando...', level: _LogLevel.info);
    try {
      await _printerService.disconnect();
      setState(() => _isConnected = false);
      _log('✓ Desconectado.', level: _LogLevel.success);
    } catch (e) {
      _log('✗ Erro ao desconectar: $e', level: _LogLevel.error);
    } finally {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _printSimpleText() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    _log('Enviando texto via SDK nativo...', level: _LogLevel.info);
    try {
      final result = await _printerService.printText(
        'TESTE SDK NATIVO\n'
        '========================\n'
        'MethodChannel: OK\n'
        'printerlibs.jar: OK\n'
        '========================\n\n\n',
      );
      if (result.success) {
        _log('✓ Texto impresso com sucesso!', level: _LogLevel.success);
        _showSnackBar('Texto impresso com sucesso!');
      } else {
        _log('✗ Falha: ${result.message}', level: _LogLevel.error);
        _showSnackBar(result.message ?? 'Falha na impressão.', isError: true);
      }
    } on PrinterNotConnectedException catch (e) {
      _log('✗ ${e.message}', level: _LogLevel.error);
      _showSnackBar(e.message, isError: true);
      setState(() => _isConnected = false);
    } catch (e) {
      _log('✗ Erro inesperado: $e', level: _LogLevel.error);
      _showSnackBar('Erro ao imprimir: $e', isError: true);
    } finally {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _printBoleto() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    _log('Gerando barcode ITF via ZXing...', level: _LogLevel.info);

    final stopwatch = Stopwatch()..start();

    final padding = _paperWidthDots == 576 ? 10 : 6;
    final contentWidthPx = _paperWidthDots - 2 * padding;

    try {
      // ── 1) Gera barcode ITF via ZXing nativo ──────────────────────────────
      final cleanBarcode = _boletoData.codigoBarras.replaceAll(RegExp(r'\D'), '');
      final barcodePng = await _methodChannel.generateItfBarcode(
        data: cleanBarcode,
        widthPx: contentWidthPx,
        heightPx: _paperWidthDots == 576 ? 80 : 60,
        margin: 10,
      );
      _log('✓ Barcode gerado (${barcodePng.length} bytes)', level: _LogLevel.debug);

      // ── 2) Injeta no widget offscreen e aguarda rebuild/paint ─────────────
      setState(() => _barcodePng = barcodePng);

      // Aguarda frames para garantir paint do RepaintBoundary offscreen
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;

      _log('Widget reconstruído com barcode. Capturando raster e imprimindo...', level: _LogLevel.debug);

      // ── 3) Captura + imprime via PrinterService (implementação do projeto)
      //    Espera-se que printBoleto faça capture (usando key), conversão e envio.
      final result = await _printerService.printBoleto(_boletoData, _boletoKey);

      stopwatch.stop();
      if (result.success) {
        _log('✓ Boleto impresso em ${stopwatch.elapsed.inMilliseconds}ms', level: _LogLevel.success);
        _showSnackBar('Boleto impresso com sucesso!');
      } else {
        _log('✗ Falha (${stopwatch.elapsed.inMilliseconds}ms): ${result.message}', level: _LogLevel.error);
        _showSnackBar(result.message ?? 'Falha na impressão.', isError: true);
      }
    } on PrinterNotConnectedException catch (e) {
      stopwatch.stop();
      _log('✗ ${e.message}', level: _LogLevel.error);
      _showSnackBar(e.message, isError: true);
      setState(() => _isConnected = false);
    } catch (e) {
      stopwatch.stop();
      _log('✗ Erro inesperado: $e', level: _LogLevel.error);
      _showSnackBar('Erro ao imprimir boleto: $e', isError: true);
    } finally {
      // Limpa o barcode do estado após tentativa de impressão
      setState(() {
        _isBusy = false;
        _barcodePng = null;
      });
    }
  }

  Future<void> _feedAndCut() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    _log('Enviando Feed + Corte...', level: _LogLevel.info);
    try {
      await _printerService.feedAndCut();
      _log('✓ Feed e corte executados.', level: _LogLevel.success);
      _showSnackBar('Papel avançado e cortado!');
    } on PrinterNotConnectedException catch (e) {
      _log('✗ ${e.message}', level: _LogLevel.error);
      _showSnackBar(e.message, isError: true);
      setState(() => _isConnected = false);
    } catch (e) {
      _log('✗ Erro no corte: $e', level: _LogLevel.error);
      _showSnackBar('Erro ao cortar: $e', isError: true);
    } finally {
      setState(() => _isBusy = false);
    }
  }

  // Abre a tela de preview passando o mesmo BoletoData e o barcode (se gerado)
  void _openPreview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BoletoPreviewPage(
          data: _boletoData,
          barcodeImageBytes: _barcodePng,
          initialPaperWidthDots: _paperWidthDots,
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name.isNotEmpty ? widget.device.name : 'Impressora'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Widget do boleto offscreen — reconstruído com barcode antes da captura.
          // Isso permite capturar sem depender da PreviewPage visível.
          Positioned(
            left: -4000,
            top: 0,
            child: Material(
              color: Colors.white,
              child: SizedBox(
                width: _paperWidthDots.toDouble(),
                child: RepaintBoundary(
                  key: _boletoKey,
                  child: ColoredBox(
                    color: Colors.white,
                    child: BoletoWidget(
                      data: _boletoData,
                      paperWidthDots: _paperWidthDots,
                      barcodeImageBytes: _barcodePng,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isBusy ? const LinearProgressIndicator(key: ValueKey('busy')) : const SizedBox(height: 4, key: ValueKey('idle')),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusCard(isConnected: _isConnected, deviceId: widget.device.id, deviceName: widget.device.name),
                      const SizedBox(height: 16),
                      _ActionCard(
                        title: 'CONEXÃO',
                        children: [
                          _ActionButton(
                            label: _isConnected ? 'Desconectar' : 'Conectar',
                            icon: _isConnected ? Icons.bluetooth_disabled : Icons.bluetooth_connected,
                            color: _isConnected ? Colors.red : Colors.blue,
                            onPressed: _isBusy ? null : (_isConnected ? _disconnect : _connect),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        title: 'TESTES DE IMPRESSÃO',
                        children: [
                          _ActionButton(
                            label: 'Imprimir Texto Simples',
                            icon: Icons.text_fields,
                            color: Colors.teal,
                            onPressed: (_isBusy || !_isConnected) ? null : _printSimpleText,
                          ),
                          const SizedBox(height: 8),
                          _ActionButton(
                            label: 'Preview do Boleto',
                            icon: Icons.visibility,
                            color: Colors.indigo,
                            onPressed: _isBusy ? null : _openPreview,
                          ),
                          const SizedBox(height: 8),
                          _ActionButton(
                            label: 'Imprimir Boleto Teste',
                            icon: Icons.receipt_long,
                            color: Colors.orange,
                            onPressed: (_isBusy || !_isConnected) ? null : _printBoleto,
                          ),
                          const SizedBox(height: 8),
                          _ActionButton(
                            label: 'Avançar Papel e Cortar',
                            icon: Icons.content_cut,
                            color: Colors.purple,
                            onPressed: (_isBusy || !_isConnected) ? null : _feedAndCut,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _LogPanel(logs: _logs, scrollController: _logScrollController, onClear: () => setState(() => _logs.clear())),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets (incorporados para arquivo self-contained) ───────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.isConnected,
    required this.deviceId,
    required this.deviceName,
  });

  final bool isConnected;
  final String deviceId;
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? Colors.green : Colors.grey;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: isConnected ? [BoxShadow(color: Colors.green.withOpacity(0.6), blurRadius: 8)] : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected ? 'Conectado' : 'Desconectado',
                    style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
                  ),
                  Text(
                    deviceId,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
            Icon(
              isConnected ? Icons.print : Icons.print_disabled,
              color: color,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: onPressed == null ? Colors.grey.shade800 : color,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

// ── Log Panel & helpers ───────────────────────────────────────────────────

enum _LogLevel { debug, info, success, error }

class _LogEntry {
  const _LogEntry(this.timestamp, this.message, this.level);
  final String timestamp;
  final String message;
  final _LogLevel level;
}

class _LogPanel extends StatelessWidget {
  const _LogPanel({
    required this.logs,
    required this.scrollController,
    required this.onClear,
  });

  final List<_LogEntry> logs;
  final ScrollController scrollController;
  final VoidCallback onClear;

  Color _colorFor(_LogLevel level) => switch (level) {
        _LogLevel.debug => Colors.grey.shade400,
        _LogLevel.info => Colors.lightBlue.shade300,
        _LogLevel.success => Colors.greenAccent.shade400,
        _LogLevel.error => Colors.redAccent.shade200,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: const Color(0xFF0D0D0D), border: Border(top: BorderSide(color: Colors.grey.shade800))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                const Text('LOGS', style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1.5)),
                const Spacer(),
                GestureDetector(
                  onTap: onClear,
                  child: const Text('LIMPAR', style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1.2)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1A1A1A)),
          Expanded(
            child: logs.isEmpty
                ? const Center(child: Text('Nenhum log ainda.', style: TextStyle(color: Colors.grey, fontSize: 12)))
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: logs.length,
                    itemBuilder: (_, i) {
                      final e = logs[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                            children: [
                              TextSpan(text: '[${e.timestamp}] ', style: const TextStyle(color: Colors.grey)),
                              TextSpan(text: e.message, style: TextStyle(color: _colorFor(e.level))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}