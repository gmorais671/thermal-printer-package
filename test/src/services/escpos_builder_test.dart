import 'package:flutter_test/flutter_test.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/services/barcode_service.dart';
import 'package:thermal_printer_pkg/src/services/escpos_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EscPosBuilder builder;

  // Boleto base válido para reuso nos testes
  final boletoBase = BoletoData(
    beneficiario: 'Empresa Teste LTDA',
    pagador: 'João da Silva',
    valor: 100.00,
    vencimento: DateTime(2025, 12, 31),
    linhaDigitavel: '00190.00009 01234.567890 12345.678901 1 00000000010000',
    codigoBarras: '00191000000000100000000009012345678901234567890',
    nossoNumero: '00012345678',
  );

  setUp(() {
    builder = EscPosBuilder(barcodeService: BarcodeService());
  });

  group('EscPosBuilder.buildBoleto', () {
    test('retorna payload não vazio para boleto válido', () async {
      final bytes = await builder.buildBoleto(boletoBase);

      expect(bytes, isNotEmpty);
    });

    test('payload contém bytes do nome do beneficiário', () async {
      final bytes = await builder.buildBoleto(boletoBase);
      final payload = String.fromCharCodes(bytes);

      expect(payload, contains('Empresa Teste LTDA'));
    });

    test('payload contém bytes do nome do pagador', () async {
      final bytes = await builder.buildBoleto(boletoBase);
      final payload = String.fromCharCodes(bytes);

      expect(payload, contains('João da Silva'));
    });

    test('payload contém valor formatado em reais', () async {
      final bytes = await builder.buildBoleto(boletoBase);
      final payload = String.fromCharCodes(bytes);

      expect(payload, contains('R\$ 100.00'));
    });

    test('payload contém data de vencimento formatada', () async {
      final bytes = await builder.buildBoleto(boletoBase);
      final payload = String.fromCharCodes(bytes);

      expect(payload, contains('31/12/2025'));
    });

    test('payload contém nosso número', () async {
      final bytes = await builder.buildBoleto(boletoBase);
      final payload = String.fromCharCodes(bytes);

      expect(payload, contains('00012345678'));
    });

    test('payload contém linha digitável', () async {
      final bytes = await builder.buildBoleto(boletoBase);
      final payload = String.fromCharCodes(bytes);

      expect(
        payload,
        contains('00190.00009 01234.567890 12345.678901 1 00000000010000'),
      );
    });

    test('payload NÃO contém seção de instruções quando instrucoes é null', () async {
      final bytes = await builder.buildBoleto(boletoBase);
      final payload = String.fromCharCodes(bytes);

      expect(payload, isNot(contains('Instruções:')));
    });

    test('payload contém instruções quando fornecidas', () async {
      final boletoComInstrucoes = boletoBase.copyWith(
        instrucoes: ['Não receber após vencimento', 'Multa de 2% ao mês'],
      );

      final bytes = await builder.buildBoleto(boletoComInstrucoes);
      final payload = String.fromCharCodes(bytes);

      expect(payload, contains('Instruções:'));
      expect(payload, contains('Não receber após vencimento'));
      expect(payload, contains('Multa de 2% ao mês'));
    });

    test('payload termina com comando de corte (GS V)', () async {
      final bytes = await builder.buildBoleto(boletoBase);

      final hasPartialCut = _containsSequence(bytes, [0x1D, 0x56, 0x42]);
      final hasFullCut    = _containsSequence(bytes, [0x1D, 0x56, 0x00]);
      final hasFeedCut    = _containsSequence(bytes, [0x1D, 0x56, 0x30]); // ← adiciona

      expect(hasPartialCut || hasFullCut || hasFeedCut, isTrue,
          reason: 'Payload deve conter comando ESC/POS de corte de papel');
    });

    test('buildText retorna payload não vazio', () async {
      final bytes = await builder.buildText('Texto de teste');

      expect(bytes, isNotEmpty);
    });

    test('buildText contém o texto fornecido', () async {
      final bytes = await builder.buildText('Texto de teste');
      final payload = String.fromCharCodes(bytes);

      expect(payload, contains('Texto de teste'));
    });

    test('buildText termina com comando de corte', () async {
      final bytes = await builder.buildText('Qualquer texto');

      final hasPartialCut = _containsSequence(bytes, [0x1D, 0x56, 0x42]);
      final hasFullCut    = _containsSequence(bytes, [0x1D, 0x56, 0x00]);
      final hasFeedCut    = _containsSequence(bytes, [0x1D, 0x56, 0x30]); // ← adiciona

      expect(hasPartialCut || hasFullCut || hasFeedCut, isTrue);
    });
  });
}

/// Verifica se [haystack] contém a subsequência [needle].
bool _containsSequence(List<int> haystack, List<int> needle) {
  for (var i = 0; i <= haystack.length - needle.length; i++) {
    if (haystack.skip(i).take(needle.length).toList().toString() ==
        needle.toString()) {
      return true;
    }
  }
  return false;
}