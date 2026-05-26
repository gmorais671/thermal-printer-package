package com.example.thermal_printer_pkg

import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ThermalPrinterPkgPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var printerManager: PrinterManager? = null
    private val TAG = "ThermalPrinterPlugin"

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "thermal_printer_pkg")
        channel.setMethodCallHandler(this)
        Log.d(TAG, "✅ Plugin registrado no canal 'thermal_printer_pkg'")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "📞 Método chamado: ${call.method}")
        
        when (call.method) {
            "connectBLE", "connectBT" -> {
                val address = call.argument<String>("address")
                Log.d(TAG, "🔵 Conectando em: $address")
                
                if (address == null) {
                    result.error("INVALID_ARGUMENT", "Endereço MAC é obrigatório", null)
                    return
                }
                
                if (printerManager == null) {
                    printerManager = PrinterManager(context)
                }
                
                val success = printerManager?.connect(address) ?: false
                Log.d(TAG, "📊 Resultado da conexão: $success")
                result.success(success)
            }
            
            "disconnect" -> {
                Log.d(TAG, "🔴 Desconectando...")
                printerManager?.disconnect()
                result.success(true)
            }
            
            "printText" -> {
                val text = call.argument<String>("text")
                Log.d(TAG, "📝 Imprimindo texto: $text")
                
                if (text == null) {
                    result.error("INVALID_ARGUMENT", "Texto é obrigatório", null)
                    return
                }
                
                val success = printerManager?.printText(text) ?: false
                result.success(success)
            }
            
            "printBarcode" -> {
                val data = call.argument<String>("data")
                Log.d(TAG, "📊 printBarcode chamado com data: $data")
                
                if (data == null) {
                    Log.e(TAG, "❌ Data é null!")
                    result.error("INVALID_ARGUMENT", "Dados do barcode são obrigatórios", null)
                    return
                }
                
                Log.d(TAG, "🔵 Chamando printerManager.printBarcodeITF($data)")
                val success = printerManager?.printBarcodeITF(data) ?: false
                Log.d(TAG, "📊 Resultado printBarcodeITF: $success")
                
                result.success(success)
            }

            // ── NOVO: gera barcode ITF com ZXing, retorna PNG como ByteArray ──
            "generateItfBarcode" -> {
                val data = call.argument<String>("data")
                if (data == null) { result.error("INVALID_ARGUMENT", "data é obrigatório", null); return }
                val widthPx = call.argument<Int>("widthPx") ?: 576
                val heightPx = call.argument<Int>("heightPx") ?: 100
                val margin = call.argument<Int>("margin") ?: 10

                val pngBytes = printerManager?.generateItfBarcode(data, widthPx, heightPx, margin)
                if (pngBytes != null) {
                    result.success(pngBytes)
                } else {
                    result.error("BARCODE_ERROR", "Falha ao gerar barcode ITF", null)
                }
            }

            // ── NOVO: imprime PNG raster via POS_PrintPicture ──
            "printRasterImage" -> {
                val bytes = call.argument<ByteArray>("bytes")
                if (bytes == null) { result.error("INVALID_ARGUMENT", "bytes é obrigatório", null); return }
                val paperWidthDots = call.argument<Int>("paperWidthDots") ?: 576
                result.success(printerManager?.printRasterImage(bytes, paperWidthDots) ?: false)
            }
            
            "setAlign" -> {
                val align = call.argument<Int>("align") ?: 0
                Log.d(TAG, "📐 Definindo alinhamento: $align")
                
                val success = printerManager?.setAlign(align) ?: false
                result.success(success)
            }
            
            "feedLine" -> {
                Log.d(TAG, "📄 Avançando linha...")
                val success = printerManager?.feedLine() ?: false
                result.success(success)
            }
            
            "reset" -> {
                Log.d(TAG, "🔄 Resetando impressora...")
                val success = printerManager?.reset() ?: false
                result.success(success)
            }
            
            else -> {
                Log.w(TAG, "⚠️ Método não implementado: ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        printerManager?.disconnect()
        printerManager = null
    }
}