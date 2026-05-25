// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrinterDeviceImpl _$$PrinterDeviceImplFromJson(Map<String, dynamic> json) =>
    _$PrinterDeviceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$PrinterConnectionTypeEnumMap, json['type']),
      isConnected: json['isConnected'] as bool? ?? false,
    );

Map<String, dynamic> _$$PrinterDeviceImplToJson(_$PrinterDeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$PrinterConnectionTypeEnumMap[instance.type]!,
      'isConnected': instance.isConnected,
    };

const _$PrinterConnectionTypeEnumMap = {
  PrinterConnectionType.bluetooth: 'bluetooth',
  PrinterConnectionType.usb: 'usb',
  PrinterConnectionType.wifi: 'wifi',
};
