import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thermal_printer_pkg/src/abstraction/printer_adapter.dart';
import 'package:thermal_printer_pkg/src/core/exceptions.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/models/print_result.dart';
import 'package:thermal_printer_pkg/src/models/printer_device.dart';
import 'package:thermal_printer_pkg/src/services/printer_service.dart';

class MockPrinterAdapter extends Mock implements PrinterAdapter {}

void main() {
  late PrinterService service;
  late MockPrinterAdapter mockAdapter;

  const device = PrinterDevice(
    id: 'MAC_123',
    name: 'Test Printer',
    type: PrinterConnectionType.bluetooth,
  );

  final boletoBase = BoletoData(
    beneficiario: 'Empresa',
    pagador: 'João',
    valor: 100.0,
    vencimento: DateTime(2025, 12, 31),
    linhaDigitavel: '123',
    codigoBarras: '00199147100000073690000001200204500001059117',
    nossoNumero: '001',
  );

  setUpAll(() {
    registerFallbackValue(
      const PrinterDevice(
        id: 'FALLBACK_DEVICE',
        name: 'Fallback Printer',
        type: PrinterConnectionType.bluetooth,
      ),
    );

    registerFallbackValue(
      BoletoData(
        beneficiario: 'Fallback Beneficiário',
        pagador: 'Fallback Pagador',
        valor: 1.0,
        vencimento: DateTime(2025, 1, 1),
        linhaDigitavel: '000',
        codigoBarras: '00199147100000073690000001200204500001059117',
        nossoNumero: '000',
      ),
    );
  });

  setUp(() {
    mockAdapter = MockPrinterAdapter();
    service = PrinterService(adapter: mockAdapter);
  });

  group('PrinterService', () {
    test('isConnected delega para o adapter', () {
      when(() => mockAdapter.isConnected).thenReturn(false);
      expect(service.isConnected, isFalse);

      when(() => mockAdapter.isConnected).thenReturn(true);
      expect(service.isConnected, isTrue);
    });

    test('connectedDevice delega para o adapter', () {
      when(() => mockAdapter.connectedDevice).thenReturn(null);
      expect(service.connectedDevice, isNull);

      when(() => mockAdapter.connectedDevice).thenReturn(device);
      expect(service.connectedDevice, equals(device));
    });

    test('connect repassa o PrinterDevice para o adapter', () async {
      when(() => mockAdapter.connect(device)).thenAnswer((_) async {});

      await service.connect(device);

      verify(() => mockAdapter.connect(device)).called(1);
    });

    test('disconnect repassa a chamada para o adapter', () async {
      when(() => mockAdapter.disconnect()).thenAnswer((_) async {});

      await service.disconnect();

      verify(() => mockAdapter.disconnect()).called(1);
    });

    test('printBoleto retorna PrintResult de sucesso', () async {
      when(() => mockAdapter.printBoleto(any())).thenAnswer(
        (_) async => const PrintResult(success: true, message: 'OK'),
      );

      final result = await service.printBoleto(boletoBase);

      expect(result.success, isTrue);
      verify(() => mockAdapter.printBoleto(boletoBase)).called(1);
    });

    test('printBoleto retorna PrintResult de falha quando adapter falha', () async {
      when(() => mockAdapter.printBoleto(any())).thenAnswer(
        (_) async => const PrintResult(
          success: false,
          message: 'Falha',
          errorCode: 'TIMEOUT',
        ),
      );

      final result = await service.printBoleto(boletoBase);

      expect(result.success, isFalse);
      expect(result.errorCode, 'TIMEOUT');
      verify(() => mockAdapter.printBoleto(boletoBase)).called(1);
    });

    test('printText retorna PrintResult de sucesso', () async {
      when(() => mockAdapter.printText(any())).thenAnswer(
        (_) async => const PrintResult(success: true, message: 'OK'),
      );

      final result = await service.printText('Teste');

      expect(result.success, isTrue);
      verify(() => mockAdapter.printText('Teste')).called(1);
    });

    test('feedAndCut repassa a chamada para o adapter', () async {
      when(() => mockAdapter.feedAndCut()).thenAnswer((_) async {});

      await service.feedAndCut();

      verify(() => mockAdapter.feedAndCut()).called(1);
    });

    test('connect propaga exceção lançada pelo adapter', () async {
      when(() => mockAdapter.connect(any()))
          .thenThrow(PrinterNotConnectedException());

      expect(
        () => service.connect(device),
        throwsA(isA<PrinterNotConnectedException>()),
      );

      verify(() => mockAdapter.connect(device)).called(1);
    });
  });
}