import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thermal_printer_pkg/src/abstraction/printer_adapter.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/models/print_result.dart';
import 'package:thermal_printer_pkg/src/models/printer_device.dart';
import 'package:thermal_printer_pkg/src/services/image_raster_service.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg_method_channel.dart';

class NativeBluetoothAdapter implements PrinterAdapter {
  final _methodChannel = MethodChannelThermalPrinterPkg();
  PrinterDevice? _connectedDevice;

  /// Largura da bobina em dots. Definida na conexão ou manualmente.
  int paperWidthDots = 576; // padrão 80mm

  @override
  PrinterDevice? get connectedDevice => _connectedDevice;

  @override
  bool get isConnected => _connectedDevice?.isConnected ?? false;

  @override
  Stream<PrinterDevice> scan({Duration timeout = const Duration(seconds: 10)}) {
    throw UnimplementedError(
      'Scan deve ser feito via flutter_blue_plus. '
      'Use NativeBluetoothAdapter.connect() com o endereço MAC.',
    );
  }

  @override
  Future<PrintResult> connect(PrinterDevice device) async {
    try {
      final success = await _methodChannel.connectBT(device.id);
      if (success) {
        _connectedDevice = device.copyWith(isConnected: true);
        return PrintResult.success(message: 'Conectado: ${device.name}');
      }
      return PrintResult.failure(message: 'Falha ao conectar', errorCode: 'CONNECT_FAILED');
    } catch (e) {
      return PrintResult.failure(message: e.toString(), errorCode: 'CONNECT_ERROR');
    }
  }

  @override
  Future<PrintResult> disconnect() async {
    try {
      await _methodChannel.disconnect();
      _connectedDevice = _connectedDevice?.copyWith(isConnected: false);
      return PrintResult.success(message: 'Desconectado');
    } catch (e) {
      return PrintResult.failure(message: e.toString(), errorCode: 'DISCONNECT_ERROR');
    }
  }

  @override
  Future<PrintResult> printText(String text, {GlobalKey? boundaryKey}) async {
    if (!isConnected) return _notConnected();
    try {
      await _methodChannel.printText(text: text);
      return PrintResult.success(message: 'Texto impresso');
    } catch (e) {
      return PrintResult.failure(message: e.toString(), errorCode: 'PRINT_ERROR');
    }
  }

  @override
  Future<PrintResult> feedAndCut() async {
    if (!isConnected) return _notConnected();
    try {
      await _methodChannel.feedLine();
      await _methodChannel.feedLine();
      await _methodChannel.feedLine();
      return PrintResult.success(message: 'Feed executado');
    } catch (e) {
      return PrintResult.failure(message: e.toString(), errorCode: 'FEED_ERROR');
    }
  }

  /// Fluxo principal: ZXing barcode → injeta no widget → captura raster → rotaciona → imprime.
  @override
  Future<PrintResult> printBoleto(BoletoData boleto, GlobalKey boundaryKey) async {
    if (!isConnected) return _notConnected();

    try {
      final cleanBarcode = boleto.codigoBarras.replaceAll(RegExp(r'\D'), '');
      if (cleanBarcode.length != 44) {
        return PrintResult.failure(
          message: 'Código de barras inválido: ${cleanBarcode.length} dígitos',
          errorCode: 'INVALID_BARCODE',
        );
      }

      // ── 1) Gera barcode ITF via ZXing nativo ──────────────────────────────
      // Largura = paperWidthDots (o barcode vai ocupar toda a largura do boleto)
      // Altura = 80 dots (ajuste conforme necessário)
      final barcodePng = await _methodChannel.generateItfBarcode(
        data: cleanBarcode,
        widthPx: paperWidthDots,
        heightPx: 80,
        margin: 10,
      );

      // ── 2) Injeta o barcode no widget via callback ─────────────────────────
      // O widget precisa ser reconstruído com barcodeImageBytes.
      // Isso é feito pelo app host — o adapter sinaliza via resultado intermediário.
      // Por ora, o boundaryKey já deve apontar para o widget com barcode injetado.
      // (ver nota abaixo sobre StatefulWidget)

      // ── 3) Captura o widget como raster PNG ───────────────────────────────
      final pngBytes = await ImageRasterService.captureAndPrepare(
        boundaryKey,
        paperWidthDots: paperWidthDots,
        rotate90: true,
      );

      if (pngBytes == null) {
        return PrintResult.failure(
          message: 'Falha ao capturar raster do boleto',
          errorCode: 'RASTER_ERROR',
        );
      }

      // ── 4) Imprime via POS_PrintPicture ───────────────────────────────────
      final success = await _methodChannel.printRasterImage(
        bytes: pngBytes,
        paperWidthDots: paperWidthDots,
      );

      if (!success) {
        return PrintResult.failure(
          message: 'Falha ao imprimir raster',
          errorCode: 'PRINT_RASTER_ERROR',
        );
      }

      // Feed + corte
      await feedAndCut();

      return PrintResult.success(message: 'Boleto impresso com sucesso');
    } catch (e) {
      return PrintResult.failure(message: e.toString(), errorCode: 'PRINT_ERROR');
    }
  }

  @override
  Future<PrintResult> printRawBytes(Uint8List bytes) async {
    if (!isConnected) return _notConnected();
    try {
      final success = await _methodChannel.printRasterImage(
        bytes: bytes,
        paperWidthDots: paperWidthDots,
      );
      return success
          ? PrintResult.success(message: 'Bytes impressos')
          : PrintResult.failure(message: 'Falha ao imprimir bytes', errorCode: 'PRINT_ERROR');
    } catch (e) {
      return PrintResult.failure(message: e.toString(), errorCode: 'PRINT_ERROR');
    }
  }

  PrintResult _notConnected() => PrintResult.failure(
        message: 'Nenhum dispositivo conectado',
        errorCode: 'NOT_CONNECTED',
      );
}