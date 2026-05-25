import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:thermal_printer_pkg/src/abstraction/printer_adapter.dart';
import 'package:thermal_printer_pkg/src/core/exceptions.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/models/print_result.dart';
import 'package:thermal_printer_pkg/src/models/printer_device.dart';
import 'package:thermal_printer_pkg/src/services/escpos_builder.dart';
import 'package:thermal_printer_pkg/src/services/image_raster_service.dart';

const int _safeChunkSize = 120;

/// Implementação do [PrinterAdapter] para impressoras Bluetooth
/// que utilizam o protocolo ESC/POS.
class EscPosBluetoothAdapter implements PrinterAdapter {
  EscPosBluetoothAdapter({EscPosBuilder? builder})
      : _builder = builder ?? EscPosBuilder();

  final EscPosBuilder _builder;

  BluetoothDevice? _connectedBluetoothDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  PrinterDevice? _connectedDevice;

  // UUID padrão para o serviço serial SPP (Serial Port Profile)
  static const String _serialServiceUuid =
      '00001101-0000-1000-8000-00805f9b34fb';

  // UUID alternativo para impressoras BLE genéricas
  static const String _bleWriteCharUuid =
      '0000ff02-0000-1000-8000-00805f9b34fb';

  // ── PrinterAdapter interface ──────────────────────────────────

  @override
  PrinterDevice? get connectedDevice => _connectedDevice;

  @override
  bool get isConnected =>
      _connectedDevice != null &&
      (_connectedDevice?.isConnected ?? false);

  @override
  Stream<PrinterDevice> scan({
    Duration timeout = const Duration(seconds: 10),
  }) async* {
    await FlutterBluePlus.startScan(timeout: timeout);

    await for (final result in FlutterBluePlus.scanResults) {
      for (final r in result) {
        if (r.device.platformName.isNotEmpty) {
          yield PrinterDevice(
            id: r.device.remoteId.str,
            name: r.device.platformName,
            type: PrinterConnectionType.bluetooth,
          );
        }
      }
    }
  }

  @override
  Future<void> connect(PrinterDevice device) async {
    try {
      final btDevice = BluetoothDevice.fromId(device.id);

      await btDevice.connect(
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );

      _writeCharacteristic = await _resolveWriteCharacteristic(btDevice);
      _connectedBluetoothDevice = btDevice;
      _connectedDevice = device.copyWith(isConnected: true);
    } on TimeoutException {
      throw const PrinterTimeoutException();
    } catch (e) {
      throw PrinterUnavailableException(reason: e.toString());
    }
  }

  @override
  Future<void> disconnect() async {
    await _connectedBluetoothDevice?.disconnect();
    _connectedBluetoothDevice = null;
    _writeCharacteristic = null;
    _connectedDevice = null;
  }

  @override
  Future<PrintResult> printBoleto(
    BoletoData boleto,
    GlobalKey boletoWidgetKey,
  ) async {
    _assertConnected();
    try {
      final image = await ImageRasterService.captureToImage(boletoWidgetKey);
      if (image == null) {
        return PrintResult.failure(
          message: 'Falha ao capturar imagem do boleto.',
          errorCode: 'RASTER_CAPTURE_ERROR',
        );
      }
      final bytes = await _builder.buildBoletoFromImageAndBarcode(
        image,
        boleto.codigoBarras,
      );
      await _sendBytes(bytes);
      return PrintResult.success();
    } catch (e) {
      return PrintResult.failure(
        message: 'Erro ao imprimir boleto: $e',
        errorCode: 'BOLETO_PRINT_ERROR',
      );
    }
  }

  @override
  Future<PrintResult> printText(String text) async {
    _assertConnected();
    try {
      final bytes = await _builder.buildText(text);
      await _sendBytes(bytes);
      return PrintResult.success(message: 'Texto impresso com sucesso.');
    } catch (e) {
      return PrintResult.failure(
        message: 'Erro ao imprimir texto: $e',
        errorCode: 'TEXT_PRINT_ERROR',
      );
    }
  }

  @override
  Future<void> feedAndCut() async {
    _assertConnected();
    // ESC/POS: feed 3 linhas + corte total
    const feedAndCutBytes = [0x1B, 0x64, 0x03, 0x1D, 0x56, 0x00];
    await _sendBytes(feedAndCutBytes);
  }

  // ── Helpers privados ──────────────────────────────────────────

  void _assertConnected() {
    if (!isConnected) throw const PrinterNotConnectedException();
  }

  /// Envia bytes em chunks de 512 bytes (limite BLE por MTU padrão).
  Future<void> _sendBytes(List<int> bytes) async {
    const chunkSize = _safeChunkSize;
    for (var i = 0; i < bytes.length; i += chunkSize) {
      final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      final chunk = bytes.sublist(i, end);
      await _writeCharacteristic?.write(chunk, withoutResponse: true);
      // Pequeno delay para não saturar o buffer BLE
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  /// Tenta encontrar a característica de escrita correta no dispositivo.
  Future<BluetoothCharacteristic?> _resolveWriteCharacteristic(
    BluetoothDevice device,
  ) async {
    final services = await device.discoverServices();

    for (final service in services) {
      for (final char in service.characteristics) {
        final props = char.properties;
        final uuid = char.uuid.toString().toLowerCase();

        // Prioriza UUID padrão de impressoras BLE
        if (uuid.contains(_bleWriteCharUuid) &&
            (props.write || props.writeWithoutResponse)) {
          return char;
        }
      }
    }

    // Fallback: primeira característica gravável encontrada
    for (final service in services) {
      for (final char in service.characteristics) {
        if (char.properties.write || char.properties.writeWithoutResponse) {
          return char;
        }
      }
    }

    throw const PrinterUnavailableException(
      reason: 'Nenhuma característica de escrita encontrada no dispositivo.',
    );
  }
}