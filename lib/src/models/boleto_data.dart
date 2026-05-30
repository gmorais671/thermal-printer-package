import 'package:freezed_annotation/freezed_annotation.dart';

part 'boleto_data.freezed.dart';

/// Dados necessários para impressão de um boleto bancário.
/// Observação: todos os campos são opcionais (nullable) exceto `codigoBarras`.
@freezed
class BoletoData with _$BoletoData {
  const factory BoletoData({
    // Cabeçalho / banco
    String? nomeBanco,
    String? numeroDigitoBanco, // ex: "001-9" (ou separação de número + dígito)

    // Identificadores / linhas
    String? numeroBoleto, // linha digitável (47/48 dígitos) — legado/alias
    String? linhaDigitavel, // alternativa/alias para linha digitável
    required String codigoBarras, // 44 dígitos do código de barras (obrigatório)

    // Local e beneficiário
    String? localPgto,
    String? beneficiario,
    String? nomeEnderecoBeneficiario,

    // Documento
    DateTime? docData, // data do documento (emissão)
    DateTime? vencimento, // data de vencimento explícita (adicionada)
    String? docNumero,
    String? docEspecie,
    bool? aceite, // true -> aceite, false -> não aceite

    // Processamento / uso do banco
    DateTime? processamentoData,
    String? usoDoBanco,
    String? agenciaCodigoBeneficiario,
    String? nossoNumero,

    // Carteira / espécie / quantidade
    String? carteira,
    String? especie,
    int? quantidade,

    // Valores
    double? valor,
    double? docValor,
    double? descontoAbatimento,
    double? outrasDeducoes,
    double? jurosMulta,
    double? outrosAcrescimos,
    double? valorCobrado,

    // Instruções / texto livre
    List<String>? instrucoes,

    // Pagador / avalista
    String? pagador,
    String? pagadorAvalista,

    // Outros
    String? codigoBaixa,
  }) = _BoletoData;
}