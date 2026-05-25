import 'package:flutter_test/flutter_test.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/models/print_result.dart';
import 'package:thermal_printer_pkg/src/models/printer_device.dart';

void main() {
  group('PrintResult', () {
    test('sucesso serializa e deserializa corretamente', () {
      const result = PrintResult(success: true, message: 'Sucesso');
      final json = result.toJson();

      expect(json['success'], isTrue);
      expect(PrintResult.fromJson(json), equals(result));
    });

    test('erro contém errorCode opcional', () {
      const result = PrintResult(
        success: false,
        message: 'erro',
        errorCode: 'TIMEOUT',
      );
      expect(result.errorCode, 'TIMEOUT');
    });

    test('errorCode é null por padrão', () {
      const result = PrintResult(success: true, message: 'OK');
      expect(result.errorCode, isNull);
    });
  });

  group('BoletoData', () {
    test('instrucoes é opcional (pode ser null)', () {
      final boleto = BoletoData(
        beneficiario: 'B',
        pagador: 'P',
        valor: 1.0,
        vencimento: DateTime.now(),
        linhaDigitavel: '123',
        codigoBarras: '123',
        nossoNumero: '001',
        instrucoes: null,
      );
      expect(boleto.instrucoes, isNull);
    });

    test('copyWith mantém imutabilidade mas altera campo específico', () {
      final boleto = BoletoData(
        beneficiario: 'Original',
        pagador: 'P',
        valor: 10.0,
        vencimento: DateTime(2025),
        linhaDigitavel: 'L',
        codigoBarras: 'C',
        nossoNumero: 'N',
      );

      final alterado = boleto.copyWith(beneficiario: 'Novo');

      expect(alterado.beneficiario, 'Novo');
      expect(alterado.pagador, 'P');
      expect(boleto.beneficiario, 'Original'); // imutável
    });

    test('serializa e deserializa corretamente', () {
      final boleto = BoletoData(
        beneficiario: 'Empresa',
        pagador: 'João',
        valor: 99.90,
        vencimento: DateTime(2025, 12, 31),
        linhaDigitavel: '123',
        codigoBarras: '456',
        nossoNumero: '789',
      );

      final json = boleto.toJson();
      final restored = BoletoData.fromJson(json);

      expect(restored, equals(boleto));
    });
  });

  group('PrinterDevice', () {
    test('isConnected é false por padrão', () {
      const device = PrinterDevice(
        id: 'MAC_123',
        name: 'HP Printer',
        type: PrinterConnectionType.bluetooth,
      );

      expect(device.isConnected, isFalse);
    });

    test('identifica corretamente o tipo da impressora', () {
      const device = PrinterDevice(
        id: 'MAC_123',
        name: 'HP Printer',
        type: PrinterConnectionType.bluetooth,
      );

      expect(device.type, PrinterConnectionType.bluetooth);
    });

    test('copyWith atualiza isConnected corretamente', () {
      const device = PrinterDevice(
        id: 'MAC_123',
        name: 'HP Printer',
        type: PrinterConnectionType.bluetooth,
      );

      final connected = device.copyWith(isConnected: true);

      expect(connected.isConnected, isTrue);
      expect(device.isConnected, isFalse); // imutável
    });
  });
}