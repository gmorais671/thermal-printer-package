import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'thermal_printer_pkg_method_channel.dart';

abstract class ThermalPrinterPkgPlatform extends PlatformInterface {
  /// Constructs a ThermalPrinterPkgPlatform.
  ThermalPrinterPkgPlatform() : super(token: _token);

  static final Object _token = Object();

  static ThermalPrinterPkgPlatform _instance = MethodChannelThermalPrinterPkg();

  /// The default instance of [ThermalPrinterPkgPlatform] to use.
  ///
  /// Defaults to [MethodChannelThermalPrinterPkg].
  static ThermalPrinterPkgPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ThermalPrinterPkgPlatform] when
  /// they register themselves.
  static set instance(ThermalPrinterPkgPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
