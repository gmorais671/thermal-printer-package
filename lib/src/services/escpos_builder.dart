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

  String _formatCurrency(double? value) {
    if (value == null) return '-';
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  DateTime? _resolveVencimento(BoletoData boleto) {
    // prioridade: vencimento explícito → docData → processamentoData
    return boleto.vencimento ?? boleto.docData ?? boleto.processamentoData;
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

    // ── Cabeçalho com banco (opcional)
    if ((boleto.nomeBanco ?? '').isNotEmpty ||
        (boleto.numeroDigitoBanco ?? '').isNotEmpty) {
      final bancoLine = [
        if (boleto.nomeBanco != null && boleto.nomeBanco!.isNotEmpty)
          boleto.nomeBanco!,
        if (boleto.numeroDigitoBanco != null &&
            boleto.numeroDigitoBanco!.isNotEmpty)
          ' ${boleto.numeroDigitoBanco!}',
      ].join();
      bytes += generator.text(bancoLine, styles: const PosStyles(bold: true));
      bytes += generator.hr();
    }

    // ── Beneficiário / Pagador ──────────────────────────────────
    if (boleto.beneficiario != null && boleto.beneficiario!.isNotEmpty) {
      bytes += generator.text(
        'Beneficiário:',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(boleto.beneficiario!);
    }

    if (boleto.pagador != null && boleto.pagador!.isNotEmpty) {
      bytes += generator.text(
        'Pagador:',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(boleto.pagador!);
    }
    bytes += generator.hr();

    // ── Valor e Vencimento (lado a lado) ───────────────────────
    final valorParaExibir = boleto.valor ?? boleto.docValor ?? boleto.valorCobrado;
    final valorFormatado = _formatCurrency(valorParaExibir);

    final vencimentoDate = _resolveVencimento(boleto);
    final vencimentoFormatado = _formatDate(vencimentoDate);

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

    // ── Nosso Número (opcional) ───────────────────────────────
    if (boleto.nossoNumero != null && boleto.nossoNumero!.isNotEmpty) {
      bytes += generator.text(
        'Nosso Número:',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(boleto.nossoNumero!);
    }

    // ── Agência / Beneficiário (opcional)
    if (boleto.agenciaCodigoBeneficiario != null &&
        boleto.agenciaCodigoBeneficiario!.isNotEmpty) {
      bytes += generator.text(
        'Agência / Beneficiário:',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(boleto.agenciaCodigoBeneficiario!);
    }

    // ── Instruções ──────────────────────────────────────────────
    if (boleto.instrucoes != null && boleto.instrucoes!.isNotEmpty) {
      bytes += generator.hr();
      bytes += generator.text(
        'Instruções:',
        styles: const PosStyles(bold: true),
      );
      for (final instrucao in boleto.instrucoes!) {
        if (instrucao.trim().isEmpty) continue;
        bytes += generator.text('- $instrucao');
      }
    }

    bytes += generator.hr();

    // ── Linha Digitável ─────────────────────────────────────────
    final linhaDigitavel =
      (boleto.linhaDigitavel?.trim().isNotEmpty ?? false)
          ? boleto.linhaDigitavel!.trim()
          : (boleto.numeroBoleto?.trim() ?? '');

    if (linhaDigitavel.isNotEmpty) {
      bytes += generator.text(
        'Linha Digitável:',
        styles: const PosStyles(bold: true, align: PosAlign.center),
      );
      bytes += generator.text(
        linhaDigitavel,
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    // ── Código de Barras (CODE128) ──────────────────────────────
    bytes += generator.feed(1);

    final rawBarcode = boleto.codigoBarras;
    final cleanedBarcode = rawBarcode.replaceAll(RegExp(r'\D'), '');

    if (cleanedBarcode.isEmpty) {
      // não imprime barcode nativo se não houver dados
    } else {
      if (cleanedBarcode.length != 44) {
        assert(
          cleanedBarcode.length == 44,
          'EscPosBuilder: codigoBarras deve ter exatamente 44 dígitos. '
          'Recebido: ${cleanedBarcode.length} (valor: $rawBarcode)',
        );
      }
      if (cleanedBarcode.length == 44) {
        final barcodeBytes = _barcodeService.buildBarcodeBytes(
          generator,
          cleanedBarcode,
          height: 60,
          width: 2,
          align: PosAlign.center,
        );
        if (barcodeBytes.isNotEmpty) {
          bytes += barcodeBytes;
        }
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