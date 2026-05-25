import 'package:flutter/material.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/models/print_result.dart';
import 'package:thermal_printer_pkg/src/models/printer_device.dart';

/// Contrato central do package.
/// Qualquer adapter (Bluetooth, USB, Wi-Fi) deve implementar esta interface.
abstract interface class PrinterAdapter {
  /// Escaneia por dispositivos disponíveis.
  /// Retorna um stream de [PrinterDevice] encontrados.
  Stream<PrinterDevice> scan({Duration timeout = const Duration(seconds: 10)});

  /// Conecta ao dispositivo informado.
  /// Lança [PrinterNotConnectedException] se falhar.
  Future<void> connect(PrinterDevice device);

  /// Desconecta do dispositivo atual.
  Future<void> disconnect();

  /// Retorna o dispositivo atualmente conectado, ou null.
  PrinterDevice? get connectedDevice;

  /// Indica se há uma impressora conectada no momento.
  bool get isConnected;

  /// Imprime um boleto bancário completo.
  Future<PrintResult> printBoleto(BoletoData boleto, GlobalKey boletoWidgetKey);

  /// Imprime texto simples (útil para testes e recibos genéricos).
  Future<PrintResult> printText(String text);

  /// Avança o papel e corta (se a impressora suportar guilhotina).
  Future<void> feedAndCut();
}