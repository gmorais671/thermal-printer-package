import 'dart:developer';

import 'package:esc_pos_utils/esc_pos_utils.dart';

class BarcodeService {
  List<int> buildBarcodeBytes(
    Generator generator,
    String data, {
    int height = 80,
    int width = 2,
    BarcodeText textPos = BarcodeText.none,
    PosAlign align = PosAlign.center,
  }) {
    try {
      final cleaned = data.replaceAll(RegExp(r'\D'), '');

      if (cleaned.length != 44) {
        log(
          'BarcodeService: codigoBarras deve ter exatamente 44 dígitos. '
          'Recebido: ${cleaned.length} dígitos.',
        );
        return [];
      }

      if (!cleaned.length.isEven) {
        log(
          'BarcodeService: CODE128-C exige quantidade par de dígitos. '
          'Recebido: ${cleaned.length} dígitos.',
        );
        return [];
      }

      return _buildBarcodeItf(
        cleaned,
        height: height,
        width: width,
        textPos: textPos,
        align: align,
      );
    } catch (e, st) {
      log('BarcodeService erro: $e', stackTrace: st);
      return [];
    }
  }

  List<int> _buildBarcodeItf(
    String numericData, {
    required int height,
    required int width,
    required BarcodeText textPos,
    required PosAlign align,
  }) {
    final bytes = <int>[];

    // Alinhamento
    bytes.addAll([0x1B, 0x61, _alignValue(align)]);

    // Altura
    bytes.addAll([0x1D, 0x68, height.clamp(1, 255)]);

    // Largura
    bytes.addAll([0x1D, 0x77, width.clamp(1, 6)]);

    // Posição HRI (texto abaixo/acima do barcode)
    bytes.addAll([0x1D, 0x48, _barcodeTextValue(textPos)]);

    // ITF legado: GS k 5 <dados> NUL
    // m = 5 => Interleaved 2 of 5
    bytes.addAll([0x1D, 0x6B, 5]);
    bytes.addAll(numericData.codeUnits); // sem prefixo, só os 44 dígitos
    bytes.add(0x00); // terminador NUL

    bytes.add(0x0A);
    bytes.addAll([0x1B, 0x61, 0]); // volta alinhamento esquerda

    return bytes;
  }

  List<int> _buildCode128C(
    String numericData, {
    required int height,
    required int width,
    required BarcodeText textPos,
    required PosAlign align,
  }) {
    final bytes = <int>[];

    // Alinhamento
    bytes.addAll([0x1B, 0x61, _alignValue(align)]);

    // Altura
    bytes.addAll([0x1D, 0x68, height.clamp(1, 255)]);

    // Largura
    bytes.addAll([0x1D, 0x77, width.clamp(1, 6)]);

    // Posição HRI
    bytes.addAll([0x1D, 0x48, _barcodeTextValue(textPos)]);

    // Seleciona CODE128: GS k 8 (formato legado, terminado em NUL)
    // m = 8 => CODE128
    final payload = '{C$numericData';
    bytes.addAll([0x1D, 0x6B, 8]);
    bytes.addAll(payload.codeUnits);
    bytes.add(0x00); // terminador NUL obrigatório no formato legado

    bytes.add(0x0A);
    bytes.addAll([0x1B, 0x61, 0]); // volta alinhamento esquerda

    return bytes;
  }

  int _alignValue(PosAlign align) {
    switch (align) {
      case PosAlign.left:
        return 0;
      case PosAlign.center:
        return 1;
      case PosAlign.right:
        return 2;
    }
    throw ArgumentError('PosAlign desconhecido: $align');
  }

  int _barcodeTextValue(BarcodeText textPos) {
    switch (textPos) {
      case BarcodeText.none:
        return 0;
      case BarcodeText.above:
        return 1;
      case BarcodeText.below:
        return 2;
      case BarcodeText.both:
        return 3;
    }
    throw ArgumentError('BarcodeText desconhecido: $textPos');
  }
}