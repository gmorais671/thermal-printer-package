// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrintResultImpl _$$PrintResultImplFromJson(Map<String, dynamic> json) =>
    _$PrintResultImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      errorCode: json['errorCode'] as String?,
    );

Map<String, dynamic> _$$PrintResultImplToJson(_$PrintResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'errorCode': instance.errorCode,
    };
