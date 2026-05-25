import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thermal_printer_pkg/thermal_printer_pkg.dart';

import 'printer_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // Instância da fachada — sem adapter ainda; o scan usa o adapter interno.
  final PrinterService _printerService = PrinterService(
    adapter: EscPosBluetoothAdapter(),
  );

  final List<PrinterDevice> _devices = [];
  StreamSubscription<PrinterDevice>? _scanSubscription;
  bool _isScanning = false;

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() {
      _devices.clear();
      _isScanning = true;
    });

    try {
      // O package expõe um Stream<PrinterDevice> via scanForPrinters().
      _scanSubscription = _printerService
          .scan(timeout: const Duration(seconds: 10))
          .listen(
        (device) {
          if (!mounted) return;
          // Evita duplicatas pelo ID (endereço MAC).
          final alreadyFound = _devices.any((d) => d.id == device.id);
          if (!alreadyFound) {
            setState(() => _devices.add(device));
          }
        },
        onError: (Object error) {
          if (!mounted) return;
          _showError('Erro durante o scan: $error');
          setState(() => _isScanning = false);
        },
        onDone: () {
          if (!mounted) return;
          setState(() => _isScanning = false);
        },
      );
    } catch (e) {
      _showError('Não foi possível iniciar o scan: $e');
      setState(() => _isScanning = false);
    }
  }

  void _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    if (mounted) setState(() => _isScanning = false);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToPrinter(PrinterDevice device) {
    // Para o scan antes de navegar para evitar consumo desnecessário.
    _stopScan();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrinterScreen(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Diagnostic'),
        centerTitle: true,
        actions: [
          if (_isScanning)
            IconButton(
              tooltip: 'Parar scan',
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: _stopScan,
            ),
        ],
      ),
      body: Column(
        children: [
          // ── Progress indicator ──────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isScanning
                ? const LinearProgressIndicator(key: ValueKey('progress'))
                : const SizedBox(height: 4, key: ValueKey('spacer')),
          ),

          // ── Status banner ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  _isScanning ? Icons.radar : Icons.bluetooth_searching,
                  color: _isScanning
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  _isScanning
                      ? 'Escaneando dispositivos BLE...'
                      : _devices.isEmpty
                          ? 'Nenhuma impressora encontrada.'
                          : '${_devices.length} impressora(s) encontrada(s).',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Device list ─────────────────────────────────────────────────
          Expanded(
            child: _devices.isEmpty
                ? _EmptyState(isScanning: _isScanning)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _devices.length,
                    separatorBuilder: (_, __) =>
                        const Divider(indent: 72, height: 1),
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return _DeviceTile(
                        device: device,
                        onTap: () => _navigateToPrinter(device),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ── FAB ─────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isScanning ? _stopScan : _startScan,
        icon: Icon(_isScanning ? Icons.stop : Icons.search),
        label: Text(_isScanning ? 'Parar' : 'Escanear Impressoras'),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, required this.onTap});

  final PrinterDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.print_outlined),
      ),
      title: Text(
        device.name.isNotEmpty ? device.name : 'Dispositivo Desconhecido',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        device.id,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontFamily: 'monospace'),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isScanning});

  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isScanning ? Icons.radar : Icons.print_disabled_outlined,
            size: 72,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            isScanning
                ? 'Procurando impressoras próximas...'
                : 'Toque em "Escanear Impressoras" para começar.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}