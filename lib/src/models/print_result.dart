import 'package:freezed_annotation/freezed_annotation.dart';

part 'print_result.freezed.dart';
part 'print_result.g.dart';

/// Resultado de qualquer operação de impressão.
@freezed
class PrintResult with _$PrintResult {
  const factory PrintResult({
    /// Indica se a operação foi bem-sucedida.
    required bool success,

    /// Mensagem descritiva do resultado (sucesso ou erro).
    required String message,

    /// Código de erro opcional para tratamento programático.
    String? errorCode,
  }) = _PrintResult;

  /// Construtor de conveniência para resultado de sucesso.
  factory PrintResult.success({String message = 'Impressão realizada com sucesso.'}) =>
      PrintResult(success: true, message: message);

  /// Construtor de conveniência para resultado de falha.
  factory PrintResult.failure({
    required String message,
    String? errorCode,
  }) =>
      PrintResult(success: false, message: message, errorCode: errorCode);

  factory PrintResult.fromJson(Map<String, dynamic> json) =>
      _$PrintResultFromJson(json);
}