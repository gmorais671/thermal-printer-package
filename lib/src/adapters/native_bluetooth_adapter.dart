import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:thermal_printer_pkg/src/abstraction/printer_adapter.dart';
import 'package:thermal_printer_pkg/src/models/boleto_data.dart';
import 'package:thermal_printer_pkg/src/models/print_result.dart';
import 'package:thermal_printer_pkg/src/models/printer_device.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg_method_channel.dart';

/// Adapter que usa o SDK nativo (printerlibs.jar) via MethodChannel
class NativeBluetoothAdapter implements PrinterAdapter {
  final _methodChannel = MethodChannelThermalPrinterPkg();
  PrinterDevice? _connectedDevice;

  @override
  PrinterDevice? get connectedDevice => _connectedDevice;

  @override
  Stream<PrinterDevice> scan({Duration timeout = const Duration(seconds: 10)}) {
    // ⚠️ O SDK nativo não expõe scan — você pode usar flutter_blue_plus para scan
    // e depois conectar via NativeBluetoothAdapter.connect(device)
    throw UnimplementedError(
      'Scan deve ser feito via flutter_blue_plus. '
      'Use NativeBluetoothAdapter.connect() com o endereço MAC do dispositivo.',
    );
  }

  @override
  Future<PrintResult> connect(PrinterDevice device) async {
    try {
      // Tenta conectar via BLE usando o ID (endereço MAC)
      final success = await _methodChannel.connectBLE(device.id);
      
      if (success) {
        _connectedDevice = device.copyWith(isConnected: true);
        return PrintResult.success(message: 'Conectado via BLE: ${device.name}');
      } else {
        return PrintResult.failure(
          message: 'Falha ao conectar via BLE',
          errorCode: 'CONNECT_FAILED',
        );
      }
    } catch (e) {
      return PrintResult.failure(
        message: e.toString(),
        errorCode: 'CONNECT_ERROR',
      );
    }
  }

  @override
  Future<PrintResult> disconnect() async {
    try {
      await _methodChannel.disconnect();
      _connectedDevice = _connectedDevice?.copyWith(isConnected: false);
      return PrintResult.success(message: 'Desconectado com sucesso');
    } catch (e) {
      return PrintResult.failure(
        message: e.toString(),
        errorCode: 'DISCONNECT_ERROR',
      );
    }
  }

  @override
  Future<PrintResult> printText(String text, {GlobalKey? boundaryKey}) async {
    if (_connectedDevice == null) {
      return PrintResult.failure(
        message: 'Nenhum dispositivo conectado',
        errorCode: 'NOT_CONNECTED',
      );
    }

    try {
      await _methodChannel.printText(text: text);
      return PrintResult.success(message: 'Texto impresso com sucesso');
    } catch (e) {
      return PrintResult.failure(
        message: e.toString(),
        errorCode: 'PRINT_ERROR',
      );
    }
  }

  @override
  Future<PrintResult> feedAndCut() async {
    if (_connectedDevice == null) {
      return PrintResult.failure(
        message: 'Nenhum dispositivo conectado',
        errorCode: 'NOT_CONNECTED',
      );
    }

    try {
      // Avança 3 linhas e corta (se a impressora suportar)
      await _methodChannel.feedLine();
      await _methodChannel.feedLine();
      await _methodChannel.feedLine();
      
      // ⚠️ O SDK pode não ter comando de corte exposto
      // Se necessário, adicione um método 'cut' no MethodChannel
      
      return PrintResult.success(message: 'Feed executado');
    } catch (e) {
      return PrintResult.failure(
        message: e.toString(),
        errorCode: 'FEED_ERROR',
      );
    }
  }

  @override
  Future<PrintResult> printBoleto(BoletoData boleto, GlobalKey boundaryKey) async {
    if (_connectedDevice == null) {
      return PrintResult.failure(
        message: 'Nenhum dispositivo conectado',
        errorCode: 'NOT_CONNECTED',
      );
    }

    try {
      // ── Cabeçalho ──
      await _methodChannel.setAlign(1); // centro
      await _methodChannel.printText(
        text: 'BOLETO BANCÁRIO\n',
        widthTimes: 1,
        heightTimes: 1,
        fontStyle: 0x08, // bold
      );
      await _methodChannel.feedLine();

      // ── Beneficiário / Pagador ──
      await _methodChannel.setAlign(0); // esquerda
      await _methodChannel.printText(
        text: 'Beneficiário:\n',
        fontStyle: 0x08,
      );
      await _methodChannel.printText(text: '${boleto.beneficiario}\n');
      await _methodChannel.printText(
        text: 'Pagador:\n',
        fontStyle: 0x08,
      );
      await _methodChannel.printText(text: '${boleto.pagador}\n');
      await _methodChannel.feedLine();

      // ── Valor e Vencimento ──
      final valorFormatado = 'R\$ ${boleto.valor.toStringAsFixed(2)}';
      final vencimentoFormatado =
          '${boleto.vencimento.day.toString().padLeft(2, '0')}/'
          '${boleto.vencimento.month.toString().padLeft(2, '0')}/'
          '${boleto.vencimento.year}';

      await _methodChannel.printText(
        text: 'Valor: $valorFormatado\n',
        fontStyle: 0x08,
      );
      await _methodChannel.printText(
        text: 'Vencimento: $vencimentoFormatado\n',
        fontStyle: 0x08,
      );
      await _methodChannel.feedLine();

      // ── Nosso Número ──
      await _methodChannel.printText(
        text: 'Nosso Número:\n',
        fontStyle: 0x08,
      );
      await _methodChannel.printText(text: '${boleto.nossoNumero}\n');

      // ── Instruções ──
      if (boleto.instrucoes != null && boleto.instrucoes!.isNotEmpty) {
        await _methodChannel.feedLine();
        await _methodChannel.printText(
          text: 'Instruções:\n',
          fontStyle: 0x08,
        );
        for (final instrucao in boleto.instrucoes!) {
          await _methodChannel.printText(text: '- $instrucao\n');
        }
      }

      await _methodChannel.feedLine();

      // ── Linha Digitável ──
      await _methodChannel.setAlign(1); // centro
      await _methodChannel.printText(
        text: 'Linha Digitável:\n',
        fontStyle: 0x08,
      );
      final linhaDigitavel = boleto.linhaDigitavel;
      final parte1 = linhaDigitavel.substring(0, 23); // "23793.36128 60033.06250"
      final parte2 = linhaDigitavel.substring(24);     // "8 63000.0 63317 9 95020000125050"
      
      await _methodChannel.printText(text: '$parte1\n');
      await _methodChannel.printText(text: '$parte2\n');
      await _methodChannel.feedLine();

      // ── Código de Barras (ITF nativo) ──
      final cleanedBarcode = boleto.codigoBarras.replaceAll(RegExp(r'\D'), '');
      
      if (cleanedBarcode.length == 44) {
        await _methodChannel.printBarcode(
          data: cleanedBarcode,
          type: 0x46, // ITF
          width: 3,
          height: 96,
          fontPosition: 0, // sem texto HRI (já temos a linha digitável)
        );
      } else {
        return PrintResult.failure(
          message: 'Código de barras inválido: deve ter 44 dígitos, recebido ${cleanedBarcode.length}',
          errorCode: 'INVALID_BARCODE',
        );
      }

      await _methodChannel.feedLine();
      await _methodChannel.feedLine();

      return PrintResult.success(message: 'Boleto impresso com sucesso');
    } catch (e) {
      return PrintResult.failure(
        message: e.toString(),
        errorCode: 'PRINT_ERROR',
      );
    }
  }

  @override
  Future<PrintResult> printRawBytes(Uint8List bytes) async {
    // O SDK nativo não expõe envio de bytes brutos diretamente
    return PrintResult.failure(
      message: 'printRawBytes não suportado pelo adapter nativo. Use printBoleto().',
      errorCode: 'NOT_SUPPORTED',
    );
  }

  @override
  bool get isConnected => _connectedDevice?.isConnected ?? false;
}