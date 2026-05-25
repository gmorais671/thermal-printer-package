package com.example.thermal_printer_pkg

import android.content.Context
import android.util.Log
import com.lvrenyang.io.BTPrinting
import com.lvrenyang.io.Pos

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