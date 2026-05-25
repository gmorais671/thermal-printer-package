import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_device.freezed.dart';
part 'printer_device.g.dart';

/// Tipo de conexão suportado pela impressora.
enum PrinterConnectionType {
  bluetooth,
  usb,
  wifi,
}

/// Representa uma impressora encontrada durante o scan.
@freezed
class PrinterDevice with _$PrinterDevice {
  const factory PrinterDevice({
    /// Endereço MAC (Bluetooth) ou identificador único do dispositivo.
    required String id,

    /// Nome amigável do dispositivo (ex: "POS-80", "Bluetooth Printer").
    required String name,

    /// Tipo de conexão da impressora.
    required PrinterConnectionType type,

    /// Indica se a impressora está atualmente conectada.
    @Default(false) bool isConnected,
  }) = _PrinterDevice;

  factory PrinterDevice.fromJson(Map<String, dynamic> json) =>
      _$PrinterDeviceFromJson(json);
}