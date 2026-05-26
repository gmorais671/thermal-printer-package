import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg_platform_interface.dart';

/// Implementação do MethodChannel para comunicação com o SDK nativo (printerlibs.jar)
class MethodChannelThermalPrinterPkg extends ThermalPrinterPkgPlatform {
  /// O MethodChannel usado para comunicação com o código nativo
  @visibleForTesting
  final methodChannel = const MethodChannel('thermal_printer_pkg');

  /// Conecta via BLE usando o SDK nativo
  Future<bool> connectBLE(String address) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('connectBLE', {
        'address': address,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao conectar BLE: ${e.message}');
    }
  }

  /// Conecta via Bluetooth Classic (SPP) usando o SDK nativo
  Future<bool> connectBT(String address) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('connectBT', {
        'address': address,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao conectar BT: ${e.message}');
    }
  }

  /// Imprime código de barras usando o comando ESC/POS nativo
  Future<bool> printBarcode({
    required String data,
    int type = 0x46, // ITF por padrão (boleto)
    int width = 3, // 2-6
    int height = 96, // altura em pontos
    int orgx = 0, // posição X
    int fontType = 0,
    int fontPosition = 2, // 0=nenhum, 1=acima, 2=abaixo, 3=ambos
  }) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printBarcode', {
        'data': data,
        'type': type,
        'width': width,
        'height': height,
        'orgx': orgx,
        'fontType': fontType,
        'fontPosition': fontPosition,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao imprimir barcode: ${e.message}');
    }
  }

  /// Imprime texto formatado
  Future<bool> printText({
    required String text,
    String encoding = 'GBK',
    int orgx = 0,
    int widthTimes = 0,
    int heightTimes = 0,
    int fontType = 0,
    int fontStyle = 0,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printText', {
        'text': text,
        'encoding': encoding,
        'orgx': orgx,
        'widthTimes': widthTimes,
        'heightTimes': heightTimes,
        'fontType': fontType,
        'fontStyle': fontStyle,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao imprimir texto: ${e.message}');
    }
  }

  /// Imprime imagem (bitmap)
  Future<bool> printImage({
    required Uint8List bytes,
    int width = 384,
    int mode = 0,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printImage', {
        'bytes': bytes,
        'width': width,
        'mode': mode,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao imprimir imagem: ${e.message}');
    }
  }

  /// Gera barcode ITF via ZXing nativo. Retorna PNG como Uint8List.
  /// [widthPx] deve ser igual ao paperWidthDots (384 ou 576).
  Future<Uint8List> generateItfBarcode({
    required String data,
    int widthPx = 576,
    int heightPx = 100,
    int margin = 10,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<Uint8List>('generateItfBarcode', {
        'data': data,
        'widthPx': widthPx,
        'heightPx': heightPx,
        'margin': margin,
      });
      if (result == null) throw Exception('generateItfBarcode retornou null');
      return result;
    } on PlatformException catch (e) {
      throw Exception('Erro ao gerar barcode: ${e.message}');
    }
  }

  /// Imprime PNG raster via POS_PrintPicture.
  Future<bool> printRasterImage({
    required Uint8List bytes,
    int paperWidthDots = 576,
  }) async {
    try {
      return await methodChannel.invokeMethod<bool>('printRasterImage', {
        'bytes': bytes,
        'paperWidthDots': paperWidthDots,
      }) ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao imprimir raster: ${e.message}');
    }
  }

  /// Define alinhamento (0=esquerda, 1=centro, 2=direita)
  Future<bool> setAlign(int align) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('setAlign', {
        'align': align,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao definir alinhamento: ${e.message}');
    }
  }

  /// Avança linha
  Future<bool> feedLine() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('feedLine');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao avançar linha: ${e.message}');
    }
  }

  /// Reset da impressora
  Future<bool> reset() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('reset');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao resetar impressora: ${e.message}');
    }
  }

  /// Desconecta da impressora
  Future<bool> disconnect() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('disconnect');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Erro ao desconectar: ${e.message}');
    }
  }
}