// lib/example/preview_page.dart
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg.dart'; // ajuste se seu barrel tiver outro nome

class BoletoPreviewPage extends StatefulWidget {
  const BoletoPreviewPage({
    super.key,
    this.data,
    this.barcodeImageBytes,
    this.initialPaperWidthDots = 576,
  });

  final BoletoData? data;
  final Uint8List? barcodeImageBytes;
  final int initialPaperWidthDots;

  @override
  State<BoletoPreviewPage> createState() => _BoletoPreviewPageState();
}

class _BoletoPreviewPageState extends State<BoletoPreviewPage> {
  final GlobalKey _repaintKey = GlobalKey();
  late int _paperWidthDots;
  Uint8List? _capturedPng;
  Uint8List? _injectedBarcode;

  // Zoom/transform controller
  late final TransformationController _transformationController;
  double _lastFitScale = 1.0;
  bool _isRealSize = false;

  // debug / overlay
  bool _showGuides = false;
  double _childHeight = 0.0;
  double _viewportHeight = 0.0;
  double _overflowPx = 0.0;

  @override
  void initState() {
    super.initState();
    _paperWidthDots = widget.initialPaperWidthDots;
    _injectedBarcode = widget.barcodeImageBytes;
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  BoletoData get _effectiveData {
    return widget.data ??
        BoletoData(
          codigoBarras: '00190500954014481606906809350314337370000000100',
          nomeBanco: 'BANCO DO BRASIL S/A',
          numeroDigitoBanco: '001-9',
          linhaDigitavel: '00190.00009 01200.204509 00010.592178 3 146700000023430',
          localPgto: 'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO',
          beneficiario: 'ABACUS SOLUTIONS TECH LTDA',
          nomeEnderecoBeneficiario: 'RUA JOSE COELHO PRATES JR. 915 - UNILESTE - PIRACICABA/SP',
          docData: DateTime(2026, 5, 25),
          vencimento: DateTime(2026, 6, 4),
          docNumero: '6102165901',
          docEspecie: 'DP',
          aceite: false,
          processamentoData: DateTime(2026, 5, 25),
          usoDoBanco: '',
          carteira: '17',
          especie: 'R\$',
          quantidade: 1,
          valor: 234.30,
          docValor: 234.30,
          instrucoes: [
            'EFETUAR PAGAMENTO SOMENTE ATRAVÉS DESTE.',
            'PROTESTAR NO 10º DIA CORRIDO DO VENCIMENTO.',
            'COBRAR COMISSAO PERMANENCIA DE R\$ 0,44 POR DIA DE ATRASO'
          ],
          agenciaCodigoBeneficiario: '6516-1/1035096',
          nossoNumero: '12002045000010592',
          descontoAbatimento: 0.0,
          outrasDeducoes: 0.0,
          jurosMulta: 0.0,
          outrosAcrescimos: 0.0,
          valorCobrado: 234.30,
          pagador: 'SUPER TATUENSE LTDA - RUA DOM PEDRO II, 117 - AMERICANA/SP',
          pagadorAvalista: 'TORREFAÇÕES NOVACOLINENSES LTDA',
          codigoBaixa: '',
        );
  }

  Future<void> _capturePng({double pixelRatio = 2.0}) async {
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      setState(() => _capturedPng = byteData.buffer.asUint8List());
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Preview PNG (raster)'),
          content: SingleChildScrollView(child: Image.memory(_capturedPng!)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
          ],
        ),
      );
    } catch (e, st) {
      debugPrint('Erro capturar PNG: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao capturar imagem: $e')));
      }
    }
  }

  void _setFitScale(double fitScale) {
    _lastFitScale = fitScale;
    _transformationController.value = Matrix4.identity()..scale(fitScale);
  }

  void _resetZoom() {
    if (_isRealSize) {
      _transformationController.value = Matrix4.identity();
    } else {
      _transformationController.value = Matrix4.identity()..scale(_lastFitScale);
    }
  }

  void _toggleRealSize() {
    setState(() {
      _isRealSize = !_isRealSize;
      if (_isRealSize) {
        _transformationController.value = Matrix4.identity(); // 1:1 (no scale)
      } else {
        _transformationController.value = Matrix4.identity()..scale(_lastFitScale);
      }
    });
  }

  // Measure child size and viewport, compute overflow
  void _measureSizes(double viewportHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _repaintKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;
      final childSize = renderBox.size;
      setState(() {
        _childHeight = childSize.height;
        _viewportHeight = viewportHeight;
        _overflowPx = (_childHeight - _viewportHeight).clamp(0.0, double.infinity);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _effectiveData;
    final paperWidthPx = _paperWidthDots.toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview do Boleto'),
        actions: [
          IconButton(
            tooltip: 'Fit to width',
            onPressed: () {
              // compute fitScale in the available width later in LayoutBuilder
              // trigger a rebuild - _setFitScale is called inside LayoutBuilder below
              setState(() => _isRealSize = false);
            },
            icon: const Icon(Icons.fit_screen),
          ),
          IconButton(
            tooltip: 'Tamanho real (1 dot = 1 px)',
            onPressed: _toggleRealSize,
            icon: Icon(_isRealSize ? Icons.toggle_on : Icons.toggle_off),
          ),
          IconButton(
            tooltip: 'Reset zoom',
            onPressed: _resetZoom,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Capturar PNG',
            onPressed: () => _capturePng(pixelRatio: 2.0),
            icon: const Icon(Icons.photo_camera),
          ),
          IconButton(
            tooltip: 'Toggle Guides/Debug',
            onPressed: () => setState(() => _showGuides = !_showGuides),
            icon: const Icon(Icons.bug_report),
          )
        ],
      ),
      body: Column(
        children: [
          // controls row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Text('Bobina:'),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _paperWidthDots,
                  items: const [
                    DropdownMenuItem(value: 384, child: Text('58 mm (384 dots)')),
                    DropdownMenuItem(value: 576, child: Text('80 mm (576 dots)')),
                  ],
                  onChanged: (v) => setState(() => _paperWidthDots = v ?? 576),
                ),
                const Spacer(),
                if (_overflowPx > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(6)),
                    child: Text('BOTTOM OVERFLOWED BY ${_overflowPx.toStringAsFixed(0)} px',
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _injectedBarcode = null),
                  icon: const Icon(Icons.delete),
                  label: const Text('Remover Barcode'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _injectedBarcode = widget.barcodeImageBytes),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reinjetar Barcode'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // preview area
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final availableWidth = constraints.maxWidth - 24; // padding margin
              final fitScaleRaw = availableWidth / paperWidthPx;
              final fitScale = fitScaleRaw.isFinite ? fitScaleRaw.clamp(0.3, 1.0) : 1.0;

              // If not in real size and controller is identity, initialize to fitScale
              if (!_isRealSize && (_transformationController.value == Matrix4.identity())) {
                // set after frame to avoid mutating during build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _setFitScale(fitScale);
                });
              }

              // measure viewport height for overflow calculation (leave a bit for controls)
              final previewViewportHeight = constraints.maxHeight;
              WidgetsBinding.instance.addPostFrameCallback((_) => _measureSizes(previewViewportHeight));

              final boletoWidget = SizedBox(
                width: paperWidthPx,
                child: Material(
                  color: Colors.white,
                  child: BoletoWidget(
                    data: data,
                    paperWidthDots: _paperWidthDots,
                    barcodeImageBytes: _injectedBarcode,
                  ),
                ),
              );

              // InteractiveViewer expects the child to have a bounded size.
              final interactive = InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.2,
                maxScale: 4.0,
                panEnabled: true,
                scaleEnabled: true,
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: boletoWidget,
                ),
              );

              Widget content;
              if (_isRealSize) {
                // real size: no initial scaling; allow scrolling if larger than screen
                content = SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: interactive,
                  ),
                );
              } else {
                // fit to width with interactive zoom/pan
                content = Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: availableWidth),
                    child: interactive,
                  ),
                );
              }

              return Stack(
                children: [
                  Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.all(12),
                    child: ClipRect(child: content),
                  ),
                  if (_showGuides) _buildGuidesOverlay(paperWidthPx, constraints),
                  // bottom overflow indicator (small overlay)
                  if (_overflowPx > 0 && _showGuides)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        color: Colors.redAccent.withOpacity(0.9),
                        child: Text('BOTTOM OVERFLOWED BY ${_overflowPx.toStringAsFixed(0)} px',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _resetZoom,
        label: const Text('Reset Zoom'),
        icon: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Widget _buildGuidesOverlay(double paperWidthPx, BoxConstraints constraints) {
    // Draw center line and margins overlay; also show size info
    final availableWidth = constraints.maxWidth - 24;
    final scale = _isRealSize ? 1.0 : _lastFitScale;
    final renderedWidth = paperWidthPx * scale;
    return Positioned.fill(
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomPaint(
            painter: _GuidesPainter(
              showRulers: true,
              paperWidthPx: paperWidthPx,
              renderedWidth: renderedWidth,
              viewportHeight: constraints.maxHeight,
              childHeight: _childHeight,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.0),
                  ),
                  child: Text(
                    'W: ${paperWidthPx.toStringAsFixed(0)}px · Rendered W: ${renderedWidth.toStringAsFixed(0)}px\n'
                    'H: ${_childHeight.toStringAsFixed(0)}px · Viewport H: ${_viewportHeight.toStringAsFixed(0)}px',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GuidesPainter extends CustomPainter {
  _GuidesPainter({
    required this.showRulers,
    required this.paperWidthPx,
    required this.renderedWidth,
    required this.viewportHeight,
    required this.childHeight,
  });

  final bool showRulers;
  final double paperWidthPx;
  final double renderedWidth;
  final double viewportHeight;
  final double childHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..color = Colors.orange.withOpacity(0.9)..strokeWidth = 1.0;

    // center vertical line
    final centerX = size.width / 2;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), paint);

    // left/right guides marking the rendered area
    final centerLeft = (size.width - renderedWidth) / 2;
    final centerRight = centerLeft + renderedWidth;
    final guidePaint = Paint()..color = Colors.blue.withOpacity(0.7)..style = PaintingStyle.stroke..strokeWidth = 1.0;
    canvas.drawRect(Rect.fromLTWH(centerLeft, 0, renderedWidth, size.height), guidePaint);

    // horizontal line showing childHeight (if known)
    final childBottom = childHeight > 0 ? childHeight : size.height;
    final hp = Paint()..color = Colors.red.withOpacity(0.6)..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, childBottom), Offset(size.width, childBottom), hp);

    // viewport bottom
    final vpPaint = Paint()..color = Colors.green.withOpacity(0.6)..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, viewportHeight), Offset(size.width, viewportHeight), vpPaint);

    if (showRulers) {
      // small ticks across top for ruler (approx every 50px)
      final tickPaint = Paint()..color = Colors.black26..strokeWidth = 1.0;
      for (double x = 0; x < size.width; x += 50) {
        canvas.drawLine(Offset(x, 0), Offset(x, 8), tickPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GuidesPainter old) =>
      old.renderedWidth != renderedWidth || old.childHeight != childHeight || old.viewportHeight != viewportHeight;
}