// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boleto_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoletoDataImpl _$$BoletoDataImplFromJson(Map<String, dynamic> json) =>
    _$BoletoDataImpl(
      beneficiario: json['beneficiario'] as String,
      pagador: json['pagador'] as String,
      valor: (json['valor'] as num).toDouble(),
      vencimento: DateTime.parse(json['vencimento'] as String),
      linhaDigitavel: json['linhaDigitavel'] as String,
      codigoBarras: json['codigoBarras'] as String,
      nossoNumero: json['nossoNumero'] as String,
      instrucoes: (json['instrucoes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      banco: json['banco'] as String?,
      agencia: json['agencia'] as String?,
      conta: json['conta'] as String?,
      dataDocumento: json['dataDocumento'] == null
          ? null
          : DateTime.parse(json['dataDocumento'] as String),
      numeroDocumento: json['numeroDocumento'] as String?,
      especie: json['especie'] as String?,
      aceite: json['aceite'] as String?,
    );

Map<String, dynamic> _$$BoletoDataImplToJson(_$BoletoDataImpl instance) =>
    <String, dynamic>{
      'beneficiario': instance.beneficiario,
      'pagador': instance.pagador,
      'valor': instance.valor,
      'vencimento': instance.vencimento.toIso8601String(),
      'linhaDigitavel': instance.linhaDigitavel,
      'codigoBarras': instance.codigoBarras,
      'nossoNumero': instance.nossoNumero,
      'instrucoes': instance.instrucoes,
      'banco': instance.banco,
      'agencia': instance.agencia,
      'conta': instance.conta,
      'dataDocumento': instance.dataDocumento?.toIso8601String(),
      'numeroDocumento': instance.numeroDocumento,
      'especie': instance.especie,
      'aceite': instance.aceite,
    };
