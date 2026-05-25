import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/services/barcode_service.dart';

/// Responsável por construir os bytes ESC/POS prontos para envio à impressora.
class EscPosBuilder {
  EscPosBuilder({BarcodeService? barcodeService})
      : _barcodeService = barcodeService ?? BarcodeService();

  final BarcodeService _barcodeService;

  Future<Generator> _createGenerator(PaperSize paperSize) async {
    final profile = await CapabilityProfile.load();
    return Generator(paperSize, profile);
  }

  /// Constrói os bytes para impressão de um [BoletoData].
  Future<List<int>> buildBoleto(
    BoletoData boleto, {
    PaperSize paperSize = PaperSize.mm80,
  }) async {
    final generator = await _createGenerator(paperSize);
    var bytes = <int>[];

    // ── Cabeçalho ──────────────────────────────────────────────
    bytes += generator.text(
      'BOLETO BANCÁRIO',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.hr();

    // ── Beneficiário / Pagador ──────────────────────────────────
    bytes += generator.text(
      'Beneficiário:',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.text(boleto.beneficiario);
    bytes += generator.text(
      'Pagador:',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.text(boleto.pagador);
    bytes += generator.hr();

    // ── Valor e Vencimento (lado a lado) ───────────────────────
    final valorFormatado = 'R\$ ${boleto.valor.toStringAsFixed(2)}';
    final vencimentoFormatado =
        '${boleto.vencimento.day.toString().padLeft(2, '0')}/'
        '${boleto.vencimento.month.toString().padLeft(2, '0')}/'
        '${boleto.vencimento.year}';

    bytes += generator.row([
      PosColumn(
        text: 'Valor',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: 'Vencimento',
        width: 6,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: valorFormatado,
        width: 6,
      ),
      PosColumn(
        text: vencimentoFormatado,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr();

    // ── Nosso Número ────────────────────────────────────────────
    bytes += generator.text(
      'Nosso Número:',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.text(boleto.nossoNumero);

    // ── Instruções ──────────────────────────────────────────────
    if (boleto.instrucoes != null && boleto.instrucoes!.isNotEmpty) {
      bytes += generator.hr();
      bytes += generator.text(
        'Instruções:',
        styles: const PosStyles(bold: true),
      );
      for (final instrucao in boleto.instrucoes!) {
        bytes += generator.text('- $instrucao');
      }
    }

    bytes += generator.hr();

    // ── Linha Digitável ─────────────────────────────────────────
    bytes += generator.text(
      'Linha Digitável:',
      styles: const PosStyles(bold: true, align: PosAlign.center),
    );
    bytes += generator.text(
      boleto.linhaDigitavel,
      styles: const PosStyles(align: PosAlign.center),
    );

    // ── Código de Barras (CODE128) ──────────────────────────────
    bytes += generator.feed(1);
    final cleanedBarcode = boleto.codigoBarras.replaceAll(RegExp(r'\D'), '');
    assert(
      cleanedBarcode.length == 44,
      'EscPosBuilder: codigoBarras deve ter exatamente 44 dígitos. '
      'Recebido: ${cleanedBarcode.length} (valor: ${boleto.codigoBarras})',
    );
    if (cleanedBarcode.length == 44) {
      final barcodeBytes = _barcodeService.buildBarcodeBytes(
        generator,
        cleanedBarcode, // passa já limpo
        height: 60,
        width: 2,
        align: PosAlign.center,
      );
      if (barcodeBytes.isNotEmpty) {
        bytes += barcodeBytes;
      }
    }

    // ── Rodapé ──────────────────────────────────────────────────
    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  /// Constrói os bytes ESC/POS: imagem rasterizada do layout + barcode nativo.
  Future<List<int>> buildBoletoFromImageAndBarcode(
    img.Image image,
    String codigoBarras, {
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final generator = await _createGenerator(paperSize);
    var bytes = <int>[];

    // Layout do boleto como imagem
    bytes += generator.imageRaster(image, align: PosAlign.center);
    bytes += generator.feed(1);

    // Barcode nativo ESC/POS — muito melhor qualidade que rasterizado
    final cleanedBarcode = codigoBarras.replaceAll(RegExp(r'\D'), '');
    if (cleanedBarcode.length == 44) {
      final barcodeBytes = _barcodeService.buildBarcodeBytes(
        generator,
        cleanedBarcode,
        height: 80,
        width: 3,
        align: PosAlign.center,
      );
      if (barcodeBytes.isNotEmpty) {
        bytes += barcodeBytes;
      }
    }

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  /// Constrói os bytes para impressão de texto simples.
  Future<List<int>> buildText(
    String text, {
    PaperSize paperSize = PaperSize.mm80,
  }) async {
    final generator = await _createGenerator(paperSize);
    var bytes = <int>[];

    bytes += generator.text(text);
    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }
}