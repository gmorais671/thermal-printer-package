import 'package:flutter/material.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg.dart';

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key, required this.device});

  final PrinterDevice device;

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  final GlobalKey _boletoKey = GlobalKey();
  late final PrinterService _printerService;
  final ScrollController _logScrollController = ScrollController();
  final List<_LogEntry> _logs = [];

  bool _isConnected = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _printerService = PrinterService(adapter: NativeBluetoothAdapter());
    _log(
      'Dispositivo: ${widget.device.name} (${widget.device.id})',
      level: _LogLevel.info,
    );
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
    final ts =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
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

  // ── Ações ─────────────────────────────────────────────────────────────────

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
    _log('Montando payload do boleto...', level: _LogLevel.info);

    // ✅ Assinatura real do BoletoData
    final boleto = BoletoData(
      beneficiario: 'ABACUS SOLUTIONS TECH LTDA',
      pagador: 'USUÁRIO TESTE INTERFACE',
      valor: 1250.50,
      vencimento: DateTime(2025, 6, 30),
      linhaDigitavel: '23793.38128 60033.062508 63000.063317 9 95020000125050',
      codigoBarras: '23799950200001250503381260033062508630000633',  // 44 dígitos,
      nossoNumero: '9 95020000125050',
      instrucoes: [
        'Não receber após o vencimento.',
        'Multa de 2% após vencimento.',
      ],
    );

    _log('Payload montado. Enviando via BLE (chunks de 120 bytes)...',
        level: _LogLevel.info);

    // ── Cronômetro de performance ────────────────────────────────
    final stopwatch = Stopwatch()..start();

    try {
      final result = await _printerService.printBoleto(boleto, _boletoKey);
      stopwatch.stop();
      if (result.success) {
        _log(
          '✓ Boleto impresso em ${stopwatch.elapsed.inMilliseconds}ms',
          level: _LogLevel.success,
        );
        _showSnackBar('Boleto impresso com sucesso!');
      } else {
        stopwatch.stop();
        _log('✗ Falha (${stopwatch.elapsed.inMilliseconds}ms): ${result.message}',
            level: _LogLevel.error);
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
      setState(() => _isBusy = false);
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

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.device.name.isNotEmpty ? widget.device.name : 'Impressora'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            left: -2000,
            top: 0,
            child: RepaintBoundary(
              key: _boletoKey,
              child: BoletoWidget(
                data: BoletoData(
                beneficiario: 'ABACUS SOLUTIONS TECH LTDA',
                pagador: 'USUÁRIO TESTE INTERFACE',
                valor: 1250.50,
                vencimento: DateTime(2025, 6, 30),
                linhaDigitavel: '23793.38128 60033.062508 63000.063317 9 95020000125050',
                codigoBarras: '23799950200001250503381260033062508630000633',  // 44 dígitos,
                nossoNumero: '9 95020000125050',
                instrucoes: [
                  'Não receber após o vencimento.',
                  'Multa de 2% após vencimento.',
                ],
              ),
                width: 384,
              ),
            ),
          ),
          Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isBusy
                    ? const LinearProgressIndicator(key: ValueKey('busy'))
                    : const SizedBox(height: 4, key: ValueKey('idle')),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusCard(
                        isConnected: _isConnected,
                        deviceId: widget.device.id,
                        deviceName: widget.device.name,
                      ),
                      const SizedBox(height: 16),
                      _ActionCard(
                        title: 'CONEXÃO',
                        children: [
                          _ActionButton(
                            label: _isConnected ? 'Desconectar' : 'Conectar',
                            icon: _isConnected
                                ? Icons.bluetooth_disabled
                                : Icons.bluetooth_connected,
                            color: _isConnected ? Colors.red : Colors.blue,
                            onPressed: _isBusy
                                ? null
                                : (_isConnected ? _disconnect : _connect),
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
                            onPressed: (_isBusy || !_isConnected)
                                ? null
                                : _printSimpleText,
                          ),
                          const SizedBox(height: 8),
                          _ActionButton(
                            label: 'Imprimir Boleto Teste',
                            icon: Icons.receipt_long,
                            color: Colors.orange,
                            onPressed:
                                (_isBusy || !_isConnected) ? null : _printBoleto,
                          ),
                          const SizedBox(height: 8),
                          _ActionButton(
                            label: 'Avançar Papel e Cortar',
                            icon: Icons.content_cut,
                            color: Colors.purple,
                            onPressed:
                                (_isBusy || !_isConnected) ? null : _feedAndCut,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _LogPanel(
                logs: _logs,
                scrollController: _logScrollController,
                onClear: () => setState(() => _logs.clear()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

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
                boxShadow: isConnected
                    ? [
                        BoxShadow(
                            color: Colors.green.withOpacity(0.6),
                            blurRadius: 8)
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected ? 'Conectado' : 'Desconectado',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 16),
                  ),
                  Text(
                    deviceId,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontFamily: 'monospace'),
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
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey, letterSpacing: 1.2)),
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
          backgroundColor:
              onPressed == null ? Colors.grey.shade800 : color,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

// ── Log Panel ─────────────────────────────────────────────────────────────────

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
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        border: Border(top: BorderSide(color: Colors.grey.shade800)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                const Text('LOGS',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1.5)),
                const Spacer(),
                GestureDetector(
                  onTap: onClear,
                  child: const Text('LIMPAR',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          letterSpacing: 1.2)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1A1A1A)),
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text('Nenhum log ainda.',
                        style:
                            TextStyle(color: Colors.grey, fontSize: 12)),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    itemCount: logs.length,
                    itemBuilder: (_, i) {
                      final e = logs[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontFamily: 'monospace', fontSize: 11),
                            children: [
                              TextSpan(
                                text: '[${e.timestamp}] ',
                                style:
                                    const TextStyle(color: Colors.grey),
                              ),
                              TextSpan(
                                text: e.message,
                                style:
                                    TextStyle(color: _colorFor(e.level)),
                              ),
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