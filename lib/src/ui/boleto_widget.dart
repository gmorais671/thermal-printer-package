import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../thermal_printer_pkg.dart';

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

  double get _height => paperWidthDots.toDouble();
  double get _fontSize => paperWidthDots == 576 ? 11.0 : 9.0;
  double get _fontSizeSm => paperWidthDots == 576 ? 9.5 : 8.0;
  double get _padding => paperWidthDots == 576 ? 10.0 : 6.0;

  String get _vencimento =>
      '${data.vencimento.day.toString().padLeft(2, '0')}/'
      '${data.vencimento.month.toString().padLeft(2, '0')}/'
      '${data.vencimento.year}';

  String get _dataDoc => data.dataDocumento != null
      ? '${data.dataDocumento!.day.toString().padLeft(2, '0')}/'
        '${data.dataDocumento!.month.toString().padLeft(2, '0')}/'
        '${data.dataDocumento!.year}'
      : '';

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
          _buildDivider(),
          _buildMainGrid(),
          _buildDivider(),
          _buildInstrucoesRow(),
          _buildDivider(),
          _buildPagadorRow(),
          _buildDivider(),
          _buildBarcode(),
        ],
      ),
    );
  }

  // ── Cabeçalho: Banco | Código | Linha Digitável ──────────────────────────
  Widget _buildHeader() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banco
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2),
              child: Text(
                data.banco ?? 'BOLETO BANCÁRIO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _fontSize + 2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildVerticalDivider(),
          // Código do banco
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _padding / 2),
            child: Center(
              child: Text(
                data.agencia ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _fontSize + 2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildVerticalDivider(),
          // Linha digitável
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2),
              child: Text(
                data.linhaDigitavel,
                style: TextStyle(
                  fontSize: _fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Grid principal de campos ─────────────────────────────────────────────
  Widget _buildMainGrid() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Coluna esquerda (maior)
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField('Local de Pagamento', 'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO'),
                _buildDivider(),
                _buildField('Beneficiário', data.beneficiario),
                _buildDivider(),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _buildField('Data do Documento', _dataDoc)),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Nº do Documento', data.numeroDocumento ?? '')),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Espécie Doc.', data.especie ?? '')),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Aceite', data.aceite ?? '')),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Data Processamento', _vencimento)),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Nosso Número', data.nossoNumero)),
                    ],
                  ),
                ),
                _buildDivider(),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _buildField('Uso do Banco', '')),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Carteira', '')),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Espécie', 'R\$')),
                      _buildVerticalDivider(),
                      Expanded(child: _buildField('Quantidade', '')),
                      _buildVerticalDivider(),
                      Expanded(flex: 2, child: _buildField('Valor', '')),
                      _buildVerticalDivider(),
                      Expanded(
                        flex: 2,
                        child: _buildField(
                          'Valor do Documento',
                          'R\$ ${data.valor.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildVerticalDivider(),
          // Coluna direita (campos de cobrança)
          SizedBox(
            width: paperWidthDots == 576 ? 130 : 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField('Vencimento', _vencimento, bold: true),
                _buildDivider(),
                _buildField('Agência/Cód. Beneficiário', data.agencia ?? ''),
                _buildDivider(),
                _buildField('(-) Desconto/Abatimento', ''),
                _buildDivider(),
                _buildField('(-) Outras Deduções', ''),
                _buildDivider(),
                _buildField('(+) Juros/Multa', ''),
                _buildDivider(),
                _buildField('(+) Outros Acréscimos', ''),
                _buildDivider(),
                _buildField('Valor Cobrado', ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Instruções ───────────────────────────────────────────────────────────
  Widget _buildInstrucoesRow() {
    final instrucoes = data.instrucoes ?? [];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _padding / 2, horizontal: _padding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instruções - Todas as informações deste boleto são de exclusiva responsabilidade do beneficiário',
            style: TextStyle(fontSize: _fontSizeSm, color: Colors.black),
          ),
          ...instrucoes.map(
            (i) => Text(
              i,
              style: TextStyle(
                fontSize: _fontSizeSm,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pagador / Avalista ───────────────────────────────────────────────────
  Widget _buildPagadorRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pagador', style: TextStyle(fontSize: _fontSizeSm, color: Colors.black)),
                  Text(
                    data.pagador,
                    style: TextStyle(fontSize: _fontSize, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  if (data.conta != null)
                    Text(data.conta!, style: TextStyle(fontSize: _fontSizeSm, color: Colors.black)),
                ],
              ),
            ),
          ),
          _buildVerticalDivider(),
          SizedBox(
            width: paperWidthDots == 576 ? 130 : 100,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding / 2, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Autenticação Mecânica', style: TextStyle(fontSize: _fontSizeSm, color: Colors.black)),
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
    return Padding(
      padding: EdgeInsets.only(top: _padding / 2),
      child: barcodeImageBytes != null
          ? Image.memory(
              barcodeImageBytes!,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.none, // sem interpolação!
              height: paperWidthDots == 576 ? 60 : 50,
            )
          : Container(
              height: paperWidthDots == 576 ? 60 : 50,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Barcode',
                  style: TextStyle(fontSize: _fontSizeSm, color: Colors.grey),
                ),
              ),
            ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  Widget _buildField(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _padding / 2, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: _fontSizeSm - 1, color: Colors.black)),
          Text(
            value,
            style: TextStyle(
              fontSize: _fontSize,
              color: Colors.black,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(color: Colors.black, thickness: 0.5, height: 1);

  Widget _buildVerticalDivider() => const VerticalDivider(color: Colors.black, thickness: 0.5, width: 1);
}