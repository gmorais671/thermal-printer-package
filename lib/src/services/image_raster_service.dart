import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart'; // GlobalKey está aqui
import 'package:image/image.dart' as img;

class ImageRasterService {
  /// Captura um widget (através de uma GlobalKey) e retorna a imagem binarizada para a impressora.
  static Future<img.Image?> captureToImage(GlobalKey key) async {
    try {
      // Aguarda o frame atual terminar de pintar
      await Future.delayed(const Duration(milliseconds: 300));

      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint('ImageRasterService: boundary nulo');
        return null;
      }

      // Garante que não está em estado "needs paint"
      if (boundary.debugNeedsPaint) {
        debugPrint('ImageRasterService: boundary ainda não pintado, aguardando...');
        await Future.delayed(const Duration(milliseconds: 200));
      }

      final uiImage = await boundary.toImage(pixelRatio: 1.0);
      final byteData =
          await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return null;

      // image ^3.x — construtor posicional
      final rawImage = img.Image.fromBytes(
        uiImage.width,
        uiImage.height,
        byteData.buffer.asUint8List(),
        format: img.Format.rgba,
      );

      // Converte para escala de cinza
      final grayscale = img.grayscale(rawImage);

      // Binarização manual (image ^3.x não tem threshold())
      final binarized = img.Image(grayscale.width, grayscale.height);
      for (var y = 0; y < grayscale.height; y++) {
        for (var x = 0; x < grayscale.width; x++) {
          final pixel = grayscale.getPixel(x, y);
          final luma = img.getRed(pixel); // em grayscale R=G=B=luma
          binarized.setPixel(
            x,
            y,
            luma < 128 ? img.getColor(0, 0, 0) : img.getColor(255, 255, 255),
          );
        }
      }

      return binarized;
    } catch (e) {
      debugPrint('Erro ao capturar raster: $e');
      return null;
    }
  }
}