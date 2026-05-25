import 'package:flutter_test/flutter_test.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg_platform_interface.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockThermalPrinterPkgPlatform
    with MockPlatformInterfaceMixin
    implements ThermalPrinterPkgPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ThermalPrinterPkgPlatform initialPlatform = ThermalPrinterPkgPlatform.instance;

  test('$MethodChannelThermalPrinterPkg is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelThermalPrinterPkg>());
  });

  test('getPlatformVersion', () async {
    ThermalPrinterPkg thermalPrinterPkgPlugin = ThermalPrinterPkg();
    MockThermalPrinterPkgPlatform fakePlatform = MockThermalPrinterPkgPlatform();
    ThermalPrinterPkgPlatform.instance = fakePlatform;

    //expect(await thermalPrinterPkgPlugin.getPlatformVersion(), '42');
  });
}
