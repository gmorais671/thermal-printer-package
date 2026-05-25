/// Base class para todas as exceções do thermal_printer_pkg.
sealed class ThermalPrinterException implements Exception {
  const ThermalPrinterException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Lançada quando se tenta operar em uma impressora não conectada.
final class PrinterNotConnectedException extends ThermalPrinterException {
  const PrinterNotConnectedException({
    String message = 'Nenhuma impressora conectada. '
        'Conecte-se a uma impressora antes de imprimir.',
  }) : super(message);
}

/// Lançada quando a impressora não responde dentro do tempo limite.
final class PrinterTimeoutException extends ThermalPrinterException {
  const PrinterTimeoutException({
    this.timeoutSeconds = 10,
    String? message,
  }) : super(message ??
            'A impressora não respondeu após $timeoutSeconds segundos.');

  final int timeoutSeconds;
}

/// Lançada quando a impressora está indisponível (ocupada, sem papel, erro de hardware).
final class PrinterUnavailableException extends ThermalPrinterException {
  const PrinterUnavailableException({
    this.reason,
    String? message,
  }) : super(message ??
            'Impressora indisponível${reason != null ? ': $reason' : '.'}');

  /// Motivo específico da indisponibilidade, se conhecido.
  final String? reason;
}