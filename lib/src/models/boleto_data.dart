import 'package:freezed_annotation/freezed_annotation.dart';

part 'boleto_data.freezed.dart';
part 'boleto_data.g.dart';

/// Dados necessários para impressão de um boleto bancário.
@freezed
class BoletoData with _$BoletoData {
  const factory BoletoData({
    /// Nome ou razão social do beneficiário (cedente).
    required String beneficiario,

    /// Nome ou razão social do pagador (sacado).
    required String pagador,

    /// Valor do boleto em reais.
    required double valor,

    /// Data de vencimento do boleto.
    required DateTime vencimento,

    /// Linha digitável completa (47 ou 48 dígitos).
    required String linhaDigitavel,

    /// 44 dígitos do código de barras.
    required String codigoBarras,

    /// Nosso número — identificador do boleto no banco.
    required String nossoNumero,

    /// Instruções adicionais ao caixa/pagador (ex: multa, desconto).
    List<String>? instrucoes,

    /// Nome ou código do banco emissor (ex: "BANCO DO BRASIL", "237").
    String? banco,

    /// Agência do beneficiário (ex: "1234-5").
    String? agencia,

    /// Conta do beneficiário (ex: "00012345-6").
    String? conta,

    /// Data de emissão do documento.
    DateTime? dataDocumento,

    /// Número do documento (identificador interno).
    String? numeroDocumento,

    /// Espécie do documento (ex: "DM", "NF").
    String? especie,

    /// Aceite (ex: "N" ou "S").
    String? aceite,
  }) = _BoletoData;

  factory BoletoData.fromJson(Map<String, dynamic> json) =>
      _$BoletoDataFromJson(json);
}