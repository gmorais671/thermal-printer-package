/// thermal_printer_pkg
/// Integração com impressoras térmicas via Bluetooth usando ESC/POS.
library thermal_printer_pkg;

// Abstraction
export 'src/abstraction/printer_adapter.dart';

// Adapters
export 'src/adapters/escpos_bluetooth_adapter.dart';
export 'src/adapters/native_bluetooth_adapter.dart';

// Models
export 'src/models/boleto_data.dart';
export 'src/models/print_result.dart';
export 'src/models/printer_device.dart';

// Services
export 'src/services/barcode_service.dart';
export 'src/services/escpos_builder.dart';
export 'src/services/printer_service.dart';
export 'src/services/image_raster_service.dart';

// Core
export 'src/core/exceptions.dart';

//UI
export 'src/ui/boleto_widget.dart';

/// Stub de compatibilidade com o template gerado pelo Flutter.
/// Para uso real, utilize [PrinterService] diretamente.
class ThermalPrinterPkg {
  const ThermalPrinterPkg._();
  const ThermalPrinterPkg();
}