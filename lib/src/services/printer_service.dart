import 'package:flutter/material.dart';
import 'package:thermal_printer_pkg/src/abstraction/printer_adapter.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/models/print_result.dart';
import 'package:thermal_printer_pkg/src/models/printer_device.dart';

/// Fachada pública do package.
/// O app consome apenas esta classe — não conhece adapters nem ESC/POS.
class PrinterService {
  PrinterService({required PrinterAdapter adapter}) : _adapter = adapter;

  final PrinterAdapter _adapter;

  /// Dispositivo atualmente conectado.
  PrinterDevice? get connectedDevice => _adapter.connectedDevice;

  /// Indica se há impressora conectada.
  bool get isConnected => _adapter.isConnected;

  /// Escaneia por impressoras disponíveis.
  Stream<PrinterDevice> scan({
    Duration timeout = const Duration(seconds: 10),
  }) =>
      _adapter.scan(timeout: timeout);

  /// Conecta a uma impressora.
  Future<void> connect(PrinterDevice device) => _adapter.connect(device);

  /// Desconecta da impressora atual.
  Future<void> disconnect() => _adapter.disconnect();

  /// Imprime um boleto bancário.
  Future<PrintResult> printBoleto(BoletoData boleto, GlobalKey boletoWidgetKey) {
    return _adapter.printBoleto(boleto, boletoWidgetKey);
  }

  /// Imprime texto simples.
  Future<PrintResult> printText(String text) => _adapter.printText(text);

  /// Avança papel e corta.
  Future<void> feedAndCut() => _adapter.feedAndCut();
}