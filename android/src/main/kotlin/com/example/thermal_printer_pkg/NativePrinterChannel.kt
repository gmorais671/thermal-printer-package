package com.example.thermal_printer_pkg

import android.graphics.BitmapFactory
import com.lvrenyang.io.BLEPrinting
import com.lvrenyang.io.BTPrinting
import com.lvrenyang.io.Pos
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NativePrinterChannel : MethodChannel.MethodCallHandler {

    private val pos = Pos()
    private var blePrinting: BLEPrinting? = null
    private var btPrinting: BTPrinting? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "connectBLE" -> {
                try {
                    val address = call.argument<String>("address")
                        ?: return result.error("INVALID_ARGUMENT", "address is required", null)
                    
                    blePrinting = BLEPrinting()
                    pos.Set(blePrinting)
                    val success = blePrinting!!.Open(address)
                    result.success(success)
                } catch (e: Exception) {
                    result.error("CONNECT_ERROR", e.message, null)
                }
            }

            "connectBT" -> {
                try {
                    val address = call.argument<String>("address")
                        ?: return result.error("INVALID_ARGUMENT", "address is required", null)
                    
                    btPrinting = BTPrinting()
                    pos.Set(btPrinting)
                    val success = btPrinting!!.Open(address)
                    result.success(success)
                } catch (e: Exception) {
                    result.error("CONNECT_ERROR", e.message, null)
                }
            }

            "printBarcode" -> {
                try {
                    val data = call.argument<String>("data")
                        ?: return result.error("INVALID_ARGUMENT", "data is required", null)
                    val type = call.argument<Int>("type") ?: 0x46  // ITF por padrão
                    val width = call.argument<Int>("width") ?: 3
                    val height = call.argument<Int>("height") ?: 96
                    val orgx = call.argument<Int>("orgx") ?: 0
                    val fontType = call.argument<Int>("fontType") ?: 0
                    val fontPosition = call.argument<Int>("fontPosition") ?: 2

                    pos.POS_S_SetBarcode(data, orgx, type, width, height, fontType, fontPosition)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("PRINT_ERROR", e.message, null)
                }
            }

            "printText" -> {
                try {
                    val text = call.argument<String>("text")
                        ?: return result.error("INVALID_ARGUMENT", "text is required", null)
                    val encoding = call.argument<String>("encoding") ?: "GBK"
                    val orgx = call.argument<Int>("orgx") ?: 0
                    val widthTimes = call.argument<Int>("widthTimes") ?: 0
                    val heightTimes = call.argument<Int>("heightTimes") ?: 0
                    val fontType = call.argument<Int>("fontType") ?: 0
                    val fontStyle = call.argument<Int>("fontStyle") ?: 0

                    pos.POS_S_TextOut(text, encoding, orgx, widthTimes, heightTimes, fontType, fontStyle)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("PRINT_ERROR", e.message, null)
                }
            }

            "printImage" -> {
                try {
                    val bytes = call.argument<ByteArray>("bytes")
                        ?: return result.error("INVALID_ARGUMENT", "bytes is required", null)
                    val width = call.argument<Int>("width") ?: 384
                    val mode = call.argument<Int>("mode") ?: 0

                    val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                    pos.POS_PrintPicture(bitmap, width, mode)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("PRINT_ERROR", e.message, null)
                }
            }

            "setAlign" -> {
                try {
                    val align = call.argument<Int>("align") ?: 0
                    pos.POS_S_Align(align)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("PRINT_ERROR", e.message, null)
                }
            }

            "feedLine" -> {
                try {
                    pos.POS_FeedLine()
                    result.success(true)
                } catch (e: Exception) {
                    result.error("PRINT_ERROR", e.message, null)
                }
            }

            "reset" -> {
                try {
                    pos.POS_Reset()
                    result.success(true)
                } catch (e: Exception) {
                    result.error("PRINT_ERROR", e.message, null)
                }
            }

            "disconnect" -> {
                try {
                    blePrinting?.Close()
                    btPrinting?.Close()
                    blePrinting = null
                    btPrinting = null
                    result.success(true)
                } catch (e: Exception) {
                    result.error("DISCONNECT_ERROR", e.message, null)
                }
            }

            else -> result.notImplemented()
        }
    }
}