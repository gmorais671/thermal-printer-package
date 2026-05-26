package com.example.thermal_printer_pkg

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.util.Log
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.MultiFormatWriter
import com.lvrenyang.io.BTPrinting
import com.lvrenyang.io.Pos
import java.io.ByteArrayOutputStream

class PrinterManager(private val context: Context) {
    private var btPrinter: BTPrinting? = null
    private var pos: Pos? = null
    private val TAG = "PrinterManager"

    fun connect(macAddress: String): Boolean {
        return try {
            Log.d(TAG, "Conectando em $macAddress...")
            
            // ADICIONAR AQUI ⬇️
            Log.d(TAG, "Tentando instanciar BTPrinting...")
            btPrinter = BTPrinting()
            Log.d(TAG, "✓ BTPrinting instanciado: ${btPrinter != null}")
            
            Log.d(TAG, "Tentando instanciar Pos...")
            pos = Pos()
            Log.d(TAG, "✓ Pos instanciado: ${pos != null}")
            
            // Conectar via Bluetooth Classic (apenas MAC address)
            Log.d(TAG, "Chamando btPrinter.Open($macAddress)...")
            val result = btPrinter?.Open(macAddress) ?: false
            Log.d(TAG, "Resultado do Open: $result")
            
            if (result) {
                pos?.Set(btPrinter)
                Log.d(TAG, "✓ Conectado com sucesso!")
                true
            } else {
                Log.e(TAG, "✗ Open retornou false")
                btPrinter = null
                pos = null
                false
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ EXCEÇÃO: ${e.javaClass.simpleName} - ${e.message}")
            e.printStackTrace()
            btPrinter = null
            pos = null
            false
        }
    }

    fun disconnect() {
        try {
            btPrinter?.Close()
            btPrinter = null
            pos = null
            Log.d(TAG, "Desconectado")
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao desconectar: ${e.message}")
        }
    }

    fun printText(text: String): Boolean {
        return try {
            if (btPrinter == null || pos == null) {
                Log.e(TAG, "Impressora não conectada")
                return false
            }
            
            // ✅ USAR CP860 (Português BR) em vez de UTF-8
            pos?.POS_S_TextOut(
                text,           // pszString
                "ISO-8859-1",        // ← MUDAR AQUI (era "UTF-8")
                0,              // nOrgx
                0,              // nWidthTimes
                0,              // nHeightTimes
                0,              // nFontType
                0               // nFontStyle
            )
            
            Log.d(TAG, "Texto enviado: $text")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao imprimir texto: ${e.message}")
            false
        }
    }

    fun printBytes(bytes: ByteArray): Boolean {
        return try {
            if (btPrinter == null || pos == null) {
                Log.e(TAG, "Impressora não conectada")
                return false
            }
            
            // Enviar bytes diretamente via IO.Write
            val written = pos?.IO?.Write(bytes, 0, bytes.size) ?: 0
            
            if (written == bytes.size) {
                Log.d(TAG, "Bytes enviados: ${bytes.size}")
                true
            } else {
                Log.e(TAG, "Falha ao enviar bytes: $written/${bytes.size}")
                false
            }
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao enviar bytes: ${e.message}")
            false
        }
    }

    /**
     * Gera o barcode ITF com ZXing e retorna PNG como ByteArray.
     * widthPx/heightPx em pixels (dots da impressora).
     * margin = quiet zone em módulos (padrão 10).
     */
    fun generateItfBarcode(
        data: String,
        widthPx: Int = 576,
        heightPx: Int = 100,
        margin: Int = 10
    ): ByteArray? {
        return try {
            val clean = data.replace(Regex("[^0-9]"), "")
            if (clean.length != 44) {
                Log.e(TAG, "ITF deve ter 44 dígitos. Recebido: ${clean.length}")
                return null
            }

            val hints = mapOf(
                EncodeHintType.MARGIN to margin,
                EncodeHintType.ERROR_CORRECTION to null
            ).filterValues { it != null }

            val bitMatrix = MultiFormatWriter().encode(
                clean,
                BarcodeFormat.ITF,
                widthPx,
                heightPx,
                hints
            )

            // Converte BitMatrix → Bitmap 1-bit (preto/branco puro, sem antialias)
            val bitmap = Bitmap.createBitmap(widthPx, heightPx, Bitmap.Config.ARGB_8888)
            for (x in 0 until widthPx) {
                for (y in 0 until heightPx) {
                    bitmap.setPixel(x, y, if (bitMatrix.get(x, y)) Color.BLACK else Color.WHITE)
                }
            }

            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            Log.d(TAG, "✅ Barcode ITF gerado: ${widthPx}x${heightPx}px, ${stream.size()} bytes")
            stream.toByteArray()
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao gerar barcode ZXing: ${e.message}", e)
            null
        }
    }

    /**
     * Imprime imagem PNG (ByteArray) via POS_PrintPicture.
     * paperWidthDots: 384 (58mm) ou 576 (80mm).
     */
    fun printRasterImage(pngBytes: ByteArray, paperWidthDots: Int = 576): Boolean {
        return try {
            if (btPrinter == null || pos == null) {
                Log.e(TAG, "Impressora não conectada")
                return false
            }

            val bitmap = android.graphics.BitmapFactory.decodeByteArray(pngBytes, 0, pngBytes.size)
            if (bitmap == null) {
                Log.e(TAG, "Falha ao decodificar PNG")
                return false
            }

            Log.d(TAG, "🖨️ Imprimindo raster: ${bitmap.width}x${bitmap.height}px, paper=$paperWidthDots")
            pos?.POS_PrintPicture(bitmap, paperWidthDots, 0)
            true
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao imprimir raster: ${e.message}", e)
            false
        }
    }

    fun feedAndCut(): Boolean {
        return try {
            if (btPrinter == null || pos == null) return false
            
            // Feed 3 linhas
            pos?.POS_FeedLine()
            pos?.POS_FeedLine()
            pos?.POS_FeedLine()
            
            // Corte parcial via comando ESC/POS direto
            val cutCmd = byteArrayOf(
                0x1D.toByte(), 0x56.toByte(), 0x01.toByte()  // GS V 1 (corte parcial)
            )
            pos?.IO?.Write(cutCmd, 0, cutCmd.size)
            
            Log.d(TAG, "Feed e corte executados")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Erro no corte: ${e.message}")
            false
        }
    }
    
    fun printBarcodeITF(data: String, is58mm: Boolean = true): Boolean {
        try {
            if (btPrinter == null || pos == null) return false

            val clean = data.replace(Regex("[^0-9]"), "")
            if (clean.length != 44) {
                Log.e(TAG, "ITF deve ter 44 dígitos. Recebido: ${clean.length}")
                return false
            }

            val moduleWidth = if (is58mm) 1 else 2 // 58mm quase sempre precisa 1
            val height = 80

            fun writeAll(bytes: ByteArray) {
                pos!!.IO.Write(bytes, 0, bytes.size)
            }

            // Reset + center + settings (HRI off)
            writeAll(byteArrayOf(0x1B, 0x40))                 // ESC @
            writeAll(byteArrayOf(0x1B, 0x61, 0x01))           // ESC a 1 (center)
            writeAll(byteArrayOf(0x1D, 0x48, 0x00))           // GS H 0 (HRI none)
            writeAll(byteArrayOf(0x1D, 0x68, height.toByte()))// GS h
            writeAll(byteArrayOf(0x1D, 0x77, moduleWidth.toByte())) // GS w

            val ascii = clean.toByteArray(Charsets.US_ASCII)

            // --- TENTATIVA 1: formato com comprimento (m=0x46 para ITF) ---
            writeAll(byteArrayOf(0x1D, 0x6B, 0x46, clean.length.toByte())) // GS k 0x46 n
            writeAll(ascii)
            writeAll(byteArrayOf(0x0A)) // LF (muitos modelos "soltam" aqui)

            // volta alinhamento
            writeAll(byteArrayOf(0x1B, 0x61, 0x00))
            pos!!.POS_FeedLine()
            return true
        } catch (e: Exception) {
            Log.e(TAG, "Erro barcode: ${e.message}", e)
            return false
        }
    }

    fun setAlign(align: Int): Boolean {
        return try {
            if (btPrinter == null || pos == null) return false
            
            // ESC a n (0=esquerda, 1=centro, 2=direita)
            val alignCmd = byteArrayOf(0x1B.toByte(), 0x61.toByte(), align.toByte())
            pos?.IO?.Write(alignCmd, 0, alignCmd.size)
            Log.d(TAG, "Alinhamento definido: $align")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao definir alinhamento: ${e.message}")
            false
        }
    }

    fun feedLine(): Boolean {
        return try {
            if (btPrinter == null || pos == null) return false
            pos?.POS_FeedLine()
            true
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao avançar linha: ${e.message}")
            false
        }
    }

    fun reset(): Boolean {
        return try {
            if (btPrinter == null || pos == null) return false
            pos?.POS_Reset()
            Log.d(TAG, "Impressora resetada")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao resetar: ${e.message}")
            false
        }
    }
}