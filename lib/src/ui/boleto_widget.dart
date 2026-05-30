import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';

/// Widget do boleto em modo LANDSCAPE.
/// [paperWidthDots] define a altura do canvas (= largura da bobina em dots).
/// 58mm → 384, 80mm → 576.
/// O barcode é injetado via [barcodeImageBytes] (PNG gerado pelo ZXing nativo).
class BoletoWidget extends StatelessWidget {
  const BoletoWidget({
    super.key,
    required this.data,
    this.paperWidthDots = 576,
    this.barcodeImageBytes,
  });

  final BoletoData data;
  final int paperWidthDots;

  /// PNG do barcode gerado via ZXing. Se null, exibe placeholder.
  final Uint8List? barcodeImageBytes;

  // Base de dimensionamento (defina aqui o "projeto" para 58mm)
  static const double _baseWidth = 384.0;
  static const double _baseHeight = 300.0; // ajuste para deixar boleto mais/menos alto

  double get _barcodeHeight => paperWidthDots == 576 ? 56.0 : 46.0;

  /// Altura do widget em logical pixels — escalada proporcionalmente à largura.
  double get _height =>
      (paperWidthDots * (_baseHeight / _baseWidth)).roundToDouble();

  /// Font sizes proporcionais (escala com a largura)
  double get _fontSize => (paperWidthDots * (11.0 / 576.0)).clamp(8.0, 20.0);
  double get _fontSizeSm => (paperWidthDots * (9.0 / 576.0)).clamp(7.0, 18.0);
  double get _fontSizeXs => (paperWidthDots * (7.0 / 576.0)).clamp(6.0, 14.0);

  /// Padding proporcional
  double get _padding => (paperWidthDots * (8.0 / 576.0)).clamp(4.0, 20.0);

  // Vencimento: usa docData como principal, fallback para processamentoData
  String get _vencimento {
    final date = data.vencimento ?? data.docData ?? data.processamentoData;
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String get _dataDoc {
    final date = data.docData;
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatCurrency(double? v) {
    if (v == null) return '';
    return 'R\$ ${v.toStringAsFixed(2)}';
  }

  String get _linhaDigitavel => (data.linhaDigitavel ?? data.numeroBoleto ?? '').trim();

  String get _bankName => (data.nomeBanco ?? '').trim().isNotEmpty
      ? data.nomeBanco!.trim()
      : 'BOLETO BANCÁRIO';

  String get _bankCodeBox => (data.numeroDigitoBanco ?? '').trim();

  String _aceiteText() {
    final ace = data.aceite;
    if (ace == null) return '';
    if (ace is bool) return ace ? 'A' : 'N';
    // se por acaso for String em runtime
    return ace.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Landscape: largura livre (papel sai), altura = dots da bobina
      height: _height,
      color: Colors.white,
      padding: EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          SizedBox(height: _padding / 2),
          _buildMainGrid(),
          SizedBox(height: _padding / 2),
          _buildInstrucoesRow(),
          SizedBox(height: _padding / 2),
          _buildPagadorRow(),
          SizedBox(height: _padding / 2),
          _buildBarcode(),
        ],
      ),
    );
  }

  // ── Cabeçalho: Banco | Código | Linha Digitável ──────────────────────────
  Widget _buildHeader() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Banco (esquerda grande)
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2),
              child: Text(
                _bankName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _fontSize + 4,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Caixa do código do banco (pequena)
          if (_bankCodeBox.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: _padding / 2),
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Text(
                _bankCodeBox,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _fontSize + 2,
                ),
              ),
            )
          else
            SizedBox(width: _padding),

          // Linha digitável (direita grande)
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2),
              child: Text(
                _linhaDigitavel,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: _fontSize + 2,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Grid principal de campos ─────────────────────────────────────────────
  Widget _buildMainGrid() {
    final sideColumnWidth = (paperWidthDots * (120.0 / 576.0)).roundToDouble();

    return Expanded(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Coluna esquerda (maior)
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildField(
                    'Local de Pagamento',
                    data.localPgto ?? 'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO',
                    boldValue: true,
                  ),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),
                  _buildField('Beneficiário', data.beneficiario),
                  if ((data.nomeEnderecoBeneficiario ?? '').isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: _padding / 2, top: 2),
                      child: Text(
                        data.nomeEnderecoBeneficiario!,
                        style: TextStyle(fontSize: _fontSizeXs, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),

                  // Linha de campos (data doc / nº doc / espécie / aceite / proc. data / nosso nº)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(child: _buildFieldInline('Data do Documento', _dataDoc)),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Nº do Documento', data.docNumero)),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Espécie', data.docEspecie)),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Aceite', _aceiteText())),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Data Process.', _vencimento)),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Nosso Nº', data.nossoNumero)),
                      ],
                    ),
                  ),

                  Divider(height: 6, color: Colors.black, thickness: 0.5),

                  // Linha de valores: uso do banco / carteira / espécie / quantidade / valor / valor do doc
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildFieldInline('Uso do Banco', data.usoDoBanco)),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Carteira', data.carteira)),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Espécie', data.especie)),
                        _verticalSep(),
                        Expanded(child: _buildFieldInline('Quantidade', data.quantidade?.toString())),
                        _verticalSep(),
                        Expanded(
                          flex: 2,
                          child: _buildFieldInline('Valor', _formatCurrency(data.valor ?? data.docValor)),
                        ),
                        _verticalSep(),
                        Expanded(
                          flex: 2,
                          child: _buildFieldInline('Valor do Documento', _formatCurrency(data.docValor ?? data.valor)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Separador vertical
            Container(width: 1, color: Colors.black, margin: EdgeInsets.symmetric(horizontal: _padding / 2)),

            // Coluna direita (campos de cobrança)
            SizedBox(
              width: sideColumnWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildField('Vencimento', _vencimento, boldValue: true),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),
                  _buildField('Agência/Cód. Beneficiário', data.agenciaCodigoBeneficiario),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),
                  _buildField('(-) Desconto/Abatimento', _formatCurrency(data.descontoAbatimento)),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),
                  _buildField('(-) Outras Deduções', _formatCurrency(data.outrasDeducoes)),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),
                  _buildField('(+) Juros/Multa', _formatCurrency(data.jurosMulta)),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),
                  _buildField('(+) Outros Acréscimos', _formatCurrency(data.outrosAcrescimos)),
                  Divider(height: 6, color: Colors.black, thickness: 0.5),
                  _buildField('Valor Cobrado', _formatCurrency(data.valorCobrado)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Instruções ───────────────────────────────────────────────────────────
  Widget _buildInstrucoesRow() {
    final instrucoes = data.instrucoes ?? [];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _padding / 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instruções:',
            style: TextStyle(fontSize: _fontSizeSm, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          ...instrucoes.map(
            (i) => Text(
              i,
              style: TextStyle(
                fontSize: _fontSizeXs,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pagador / Avalista ───────────────────────────────────────────────────
  Widget _buildPagadorRow() {
    final sideColumnWidth = (paperWidthDots * (120.0 / 576.0)).roundToDouble();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pagador (grande)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pagador', style: TextStyle(fontSize: _fontSizeSm, color: Colors.black)),
                  SizedBox(height: 2),
                  Text(
                    data.pagador ?? '',
                    style: TextStyle(fontSize: _fontSize, color: Colors.black, fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((data.pagadorAvalista ?? '').isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text('Avalista:', style: TextStyle(fontSize: _fontSizeSm, color: Colors.black)),
                    Text(
                      data.pagadorAvalista ?? '',
                      style: TextStyle(fontSize: _fontSizeXs, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Separador vertical
          Container(width: 1, color: Colors.black, margin: EdgeInsets.symmetric(horizontal: _padding / 2)),

          // Autenticação mecânica
          SizedBox(
            width: sideColumnWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Autenticação Mecânica', style: TextStyle(fontSize: _fontSizeXs, color: Colors.black)),
                  SizedBox(height: 8),
                  Text('Ficha de Compensação', style: TextStyle(fontSize: _fontSizeSm, color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Barcode ──────────────────────────────────────────────────────────────
  Widget _buildBarcode() {
    final contentWidth = (paperWidthDots - 2 * _padding).roundToDouble();

    return Padding(
      padding: EdgeInsets.only(top: _padding / 3),
      child: SizedBox(
        height: _barcodeHeight,
        width: double.infinity,
        child: Center(
          child: barcodeImageBytes != null
              ? Image.memory(
                  barcodeImageBytes!,
                  width: contentWidth,
                  height: _barcodeHeight,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                )
              : Container(
                  width: contentWidth,
                  height: _barcodeHeight,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: Text(
                    'Barcode',
                    style: TextStyle(
                      fontSize: _fontSizeSm,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  Widget _buildField(String label, String? value, {bool boldValue = false}) {
    final display = (value ?? '').trim();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _padding / 2, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: _fontSizeXs, color: Colors.black),
          ),
          SizedBox(height: 2),
          Text(
            display,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: _fontSize,
              color: Colors.black,
              fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldInline(String label, String? value) {
    final display = (value ?? '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: _fontSizeXs, color: Colors.black)),
        SizedBox(height: 2),
        Text(display, style: TextStyle(fontSize: _fontSizeSm, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _verticalSep() => Container(width: 1, color: Colors.black, margin: EdgeInsets.symmetric(horizontal: 4));
}