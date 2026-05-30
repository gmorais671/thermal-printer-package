import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;

class ImageRasterService {
  /// Captura o widget e retorna PNG pronto para impressão.
  ///
  /// [key] — GlobalKey do RepaintBoundary do BoletoWidget.
  /// [paperWidthDots] — largura da bobina em dots (384=58mm, 576=80mm).
  /// [rotate90] — true para imprimir em paisagem (rotaciona o canvas 90°).
  static Future<Uint8List?> captureAndPrepare(
    GlobalKey key, {
    int paperWidthDots = 576,
    bool rotate90 = true,
    double pixelRatio = 1.0,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint('ImageRasterService: boundary nulo');
        return null;
      }

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // O widget foi desenhado com height = paperWidthDots (landscape).
      // Capturamos com pixelRatio = 1.0 — o widget já tem as dimensões certas em dots.
      final uiImage = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return null;

      var image = img.Image.fromBytes(
        uiImage.width,
        uiImage.height,
        byteData.buffer.asUint8List(),
        format: img.Format.rgba,
      );

      // 1) Rotaciona 90° no sentido horário para imprimir em paisagem
      if (rotate90) {
        image = img.copyRotate(image, 90);
      }

      // 2) Redimensiona para paperWidthDots de largura (nearest-neighbor)
      if (image.width != paperWidthDots) {
        final targetHeight = (image.height * paperWidthDots / image.width).round();
        image = img.copyResize(
          image,
          width: paperWidthDots,
          height: targetHeight,
          interpolation: img.Interpolation.nearest,
        );
      }

      // 3) Converte para grayscale
      final grayscale = img.grayscale(image);

      // 4) Binarização (threshold 128)
      final binarized = img.Image(grayscale.width, grayscale.height);
      for (var y = 0; y < grayscale.height; y++) {
        for (var x = 0; x < grayscale.width; x++) {
          final pixel = grayscale.getPixel(x, y);
          final luma = img.getRed(pixel);
          binarized.setPixel(
            x, y,
            luma < 128 ? img.getColor(0, 0, 0) : img.getColor(255, 255, 255),
          );
        }
      }

      // 5) Encode para PNG
      final pngBytes = Uint8List.fromList(img.encodePng(binarized));
      debugPrint(
        'ImageRasterService: ${binarized.width}x${binarized.height}px, '
        '${pngBytes.length} bytes',
      );
      return pngBytes;
    } catch (e) {
      debugPrint('Erro ao capturar raster: $e');
      return null;
    }
  }
}