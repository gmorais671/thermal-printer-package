import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thermal_printer_pkg/src/services/barcode_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BarcodeService service;
  late CapabilityProfile profile;

  // Helper: generator sempre fresco (sem estado acumulado)
  Generator freshGenerator() => Generator(PaperSize.mm80, profile);

  List<int> toDigitList(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    return cleaned.split('').map(int.parse).toList();
  }

  setUpAll(() async {
    profile = await CapabilityProfile.load();
  });

  setUp(() {
    service = BarcodeService();
  });

  group('BarcodeService.buildBarcodeBytes', () {
    test('gera payload válido para código de barras real de 44 dígitos', () {
      const codigo = '00199147100000073690000001200204500001059117';

      final payload = service.buildBarcodeBytes(
        freshGenerator(),
        codigo,
        height: 80,
        width: 3,
        textPos: BarcodeText.none,
      );

      expect(payload, isNotEmpty);
    });

    test('remove caracteres não numéricos e gera o mesmo payload do ESC/POS nativo', () {
      const formatted = '0019914710 0000073690 0000012002 0450000105 9117';
      const clean = '00199147100000073690000001200204500001059117';

      // Dois generators frescos — mesmo estado inicial garantido
      final g1 = freshGenerator();
      final g2 = freshGenerator();

      final actual = service.buildBarcodeBytes(
        g1,
        formatted,
        height: 80,
        width: 3,
        textPos: BarcodeText.none,
      );

      final expected = g2.barcode(
        Barcode.itf(toDigitList(clean)),
        height: 80,
        width: 3,
        textPos: BarcodeText.none,
      );

      expect(actual, equals(expected));
    });

    test('retorna lista vazia quando a entrada tem quantidade ímpar de dígitos', () {
      const linhaDigitavel =
          '23793.38128 60007.145842 54000.063306 1 96900000100000';

      final payload = service.buildBarcodeBytes(
        freshGenerator(),
        linhaDigitavel,
      );

      expect(payload, isEmpty);
    });

    test('propaga height, width e textPos corretamente para o payload nativo', () {
      const codigo = '00194150000000037400000001200204500001059017';

      final g1 = freshGenerator();
      final g2 = freshGenerator();

      final actual = service.buildBarcodeBytes(
        g1,
        codigo,
        height: 120,
        width: 4,
        textPos: BarcodeText.below,
      );

      final expected = g2.barcode(
        Barcode.itf(toDigitList(codigo)),
        height: 120,
        width: 4,
        textPos: BarcodeText.below,
      );

      expect(actual, equals(expected));
    });

    test('payload termina com byte 0 no formato ITF function A', () {
      const codigo = '00198148500000036300000001200204500001058817';

      final payload = service.buildBarcodeBytes(
        freshGenerator(),
        codigo,
      );

      expect(payload, isNotEmpty);
      expect(payload.last, 0);
    });
  });
}