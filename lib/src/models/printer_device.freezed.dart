// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PrinterDevice _$PrinterDeviceFromJson(Map<String, dynamic> json) {
  return _PrinterDevice.fromJson(json);
}

/// @nodoc
mixin _$PrinterDevice {
  /// Endereço MAC (Bluetooth) ou identificador único do dispositivo.
  String get id => throw _privateConstructorUsedError;

  /// Nome amigável do dispositivo (ex: "POS-80", "Bluetooth Printer").
  String get name => throw _privateConstructorUsedError;

  /// Tipo de conexão da impressora.
  PrinterConnectionType get type => throw _privateConstructorUsedError;

  /// Indica se a impressora está atualmente conectada.
  bool get isConnected => throw _privateConstructorUsedError;

  /// Serializes this PrinterDevice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterDeviceCopyWith<PrinterDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterDeviceCopyWith<$Res> {
  factory $PrinterDeviceCopyWith(
    PrinterDevice value,
    $Res Function(PrinterDevice) then,
  ) = _$PrinterDeviceCopyWithImpl<$Res, PrinterDevice>;
  @useResult
  $Res call({
    String id,
    String name,
    PrinterConnectionType type,
    bool isConnected,
  });
}

/// @nodoc
class _$PrinterDeviceCopyWithImpl<$Res, $Val extends PrinterDevice>
    implements $PrinterDeviceCopyWith<$Res> {
  _$PrinterDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? isConnected = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PrinterConnectionType,
            isConnected: null == isConnected
                ? _value.isConnected
                : isConnected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrinterDeviceImplCopyWith<$Res>
    implements $PrinterDeviceCopyWith<$Res> {
  factory _$$PrinterDeviceImplCopyWith(
    _$PrinterDeviceImpl value,
    $Res Function(_$PrinterDeviceImpl) then,
  ) = __$$PrinterDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    PrinterConnectionType type,
    bool isConnected,
  });
}

/// @nodoc
class __$$PrinterDeviceImplCopyWithImpl<$Res>
    extends _$PrinterDeviceCopyWithImpl<$Res, _$PrinterDeviceImpl>
    implements _$$PrinterDeviceImplCopyWith<$Res> {
  __$$PrinterDeviceImplCopyWithImpl(
    _$PrinterDeviceImpl _value,
    $Res Function(_$PrinterDeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrinterDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? isConnected = null,
  }) {
    return _then(
      _$PrinterDeviceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PrinterConnectionType,
        isConnected: null == isConnected
            ? _value.isConnected
            : isConnected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterDeviceImpl implements _PrinterDevice {
  const _$PrinterDeviceImpl({
    required this.id,
    required this.name,
    required this.type,
    this.isConnected = false,
  });

  factory _$PrinterDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterDeviceImplFromJson(json);

  /// Endereço MAC (Bluetooth) ou identificador único do dispositivo.
  @override
  final String id;

  /// Nome amigável do dispositivo (ex: "POS-80", "Bluetooth Printer").
  @override
  final String name;

  /// Tipo de conexão da impressora.
  @override
  final PrinterConnectionType type;

  /// Indica se a impressora está atualmente conectada.
  @override
  @JsonKey()
  final bool isConnected;

  @override
  String toString() {
    return 'PrinterDevice(id: $id, name: $name, type: $type, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, isConnected);

  /// Create a copy of PrinterDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterDeviceImplCopyWith<_$PrinterDeviceImpl> get copyWith =>
      __$$PrinterDeviceImplCopyWithImpl<_$PrinterDeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterDeviceImplToJson(this);
  }
}

abstract class _PrinterDevice implements PrinterDevice {
  const factory _PrinterDevice({
    required final String id,
    required final String name,
    required final PrinterConnectionType type,
    final bool isConnected,
  }) = _$PrinterDeviceImpl;

  factory _PrinterDevice.fromJson(Map<String, dynamic> json) =
      _$PrinterDeviceImpl.fromJson;

  /// Endereço MAC (Bluetooth) ou identificador único do dispositivo.
  @override
  String get id;

  /// Nome amigável do dispositivo (ex: "POS-80", "Bluetooth Printer").
  @override
  String get name;

  /// Tipo de conexão da impressora.
  @override
  PrinterConnectionType get type;

  /// Indica se a impressora está atualmente conectada.
  @override
  bool get isConnected;

  /// Create a copy of PrinterDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterDeviceImplCopyWith<_$PrinterDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
