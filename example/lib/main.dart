import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/scan_screen.dart';

void main() {
  runApp(const PrinterDiagnosticApp());
}

class PrinterDiagnosticApp extends StatelessWidget {
  const PrinterDiagnosticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer Diagnostic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PermissionGate(),
    );
  }
}

/// Garante que todas as permissões BLE estejam concedidas antes de
/// exibir a ScanScreen. Exibe um estado de erro acionável caso o
/// usuário negue permanentemente.
class PermissionGate extends StatefulWidget {
  const PermissionGate({super.key});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate>
    with WidgetsBindingObserver {
  _PermissionStatus _status = _PermissionStatus.checking;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Revalida permissões quando o usuário retorna das configurações do sistema.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _status == _PermissionStatus.permanentlyDenied) {
      _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    setState(() => _status = _PermissionStatus.checking);

    // No iOS o BLE não exige location; no Android 12+ exige os novos grants.
    final List<Permission> permissions = Platform.isAndroid
        ? [
            Permission.bluetoothScan,
            Permission.bluetoothConnect,
            Permission.bluetoothAdvertise,
            Permission.locationWhenInUse,
          ]
        : [Permission.bluetooth];

    final Map<Permission, PermissionStatus> results =
        await permissions.request();

    final bool allGranted =
        results.values.every((s) => s == PermissionStatus.granted);

    final bool anyPermanentlyDenied =
        results.values.any((s) => s == PermissionStatus.permanentlyDenied);

    if (!mounted) return;

    if (allGranted) {
      setState(() => _status = _PermissionStatus.granted);
    } else if (anyPermanentlyDenied) {
      setState(() => _status = _PermissionStatus.permanentlyDenied);
    } else {
      setState(() => _status = _PermissionStatus.denied);
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_status) {
      _PermissionStatus.granted => const ScanScreen(),
      _PermissionStatus.checking => const _LoadingView(),
      _PermissionStatus.denied => _PermissionDeniedView(
          message:
              'As permissões de Bluetooth são necessárias para escanear impressoras.',
          onRetry: _requestPermissions,
        ),
      _PermissionStatus.permanentlyDenied => _PermissionDeniedView(
          message:
              'Permissão negada permanentemente. Habilite o Bluetooth nas configurações do app.',
          isPermanent: true,
          onRetry: openAppSettings,
        ),
    };
  }
}

enum _PermissionStatus { checking, granted, denied, permanentlyDenied }

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Verificando permissões...'),
          ],
        ),
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView({
    required this.message,
    required this.onRetry,
    this.isPermanent = false,
  });

  final String message;
  final VoidCallback onRetry;
  final bool isPermanent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bluetooth_disabled, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onRetry,
                icon: Icon(isPermanent ? Icons.settings : Icons.refresh),
                label: Text(isPermanent ? 'Abrir Configurações' : 'Tentar Novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}