// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'print_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PrintResult _$PrintResultFromJson(Map<String, dynamic> json) {
  return _PrintResult.fromJson(json);
}

/// @nodoc
mixin _$PrintResult {
  /// Indica se a operação foi bem-sucedida.
  bool get success => throw _privateConstructorUsedError;

  /// Mensagem descritiva do resultado (sucesso ou erro).
  String get message => throw _privateConstructorUsedError;

  /// Código de erro opcional para tratamento programático.
  String? get errorCode => throw _privateConstructorUsedError;

  /// Serializes this PrintResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrintResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrintResultCopyWith<PrintResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrintResultCopyWith<$Res> {
  factory $PrintResultCopyWith(
    PrintResult value,
    $Res Function(PrintResult) then,
  ) = _$PrintResultCopyWithImpl<$Res, PrintResult>;
  @useResult
  $Res call({bool success, String message, String? errorCode});
}

/// @nodoc
class _$PrintResultCopyWithImpl<$Res, $Val extends PrintResult>
    implements $PrintResultCopyWith<$Res> {
  _$PrintResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrintResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? errorCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            errorCode: freezed == errorCode
                ? _value.errorCode
                : errorCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrintResultImplCopyWith<$Res>
    implements $PrintResultCopyWith<$Res> {
  factory _$$PrintResultImplCopyWith(
    _$PrintResultImpl value,
    $Res Function(_$PrintResultImpl) then,
  ) = __$$PrintResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, String? errorCode});
}

/// @nodoc
class __$$PrintResultImplCopyWithImpl<$Res>
    extends _$PrintResultCopyWithImpl<$Res, _$PrintResultImpl>
    implements _$$PrintResultImplCopyWith<$Res> {
  __$$PrintResultImplCopyWithImpl(
    _$PrintResultImpl _value,
    $Res Function(_$PrintResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrintResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? errorCode = freezed,
  }) {
    return _then(
      _$PrintResultImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        errorCode: freezed == errorCode
            ? _value.errorCode
            : errorCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrintResultImpl implements _PrintResult {
  const _$PrintResultImpl({
    required this.success,
    required this.message,
    this.errorCode,
  });

  factory _$PrintResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrintResultImplFromJson(json);

  /// Indica se a operação foi bem-sucedida.
  @override
  final bool success;

  /// Mensagem descritiva do resultado (sucesso ou erro).
  @override
  final String message;

  /// Código de erro opcional para tratamento programático.
  @override
  final String? errorCode;

  @override
  String toString() {
    return 'PrintResult(success: $success, message: $message, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrintResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, errorCode);

  /// Create a copy of PrintResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrintResultImplCopyWith<_$PrintResultImpl> get copyWith =>
      __$$PrintResultImplCopyWithImpl<_$PrintResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrintResultImplToJson(this);
  }
}

abstract class _PrintResult implements PrintResult {
  const factory _PrintResult({
    required final bool success,
    required final String message,
    final String? errorCode,
  }) = _$PrintResultImpl;

  factory _PrintResult.fromJson(Map<String, dynamic> json) =
      _$PrintResultImpl.fromJson;

  /// Indica se a operação foi bem-sucedida.
  @override
  bool get success;

  /// Mensagem descritiva do resultado (sucesso ou erro).
  @override
  String get message;

  /// Código de erro opcional para tratamento programático.
  @override
  String? get errorCode;

  /// Create a copy of PrintResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrintResultImplCopyWith<_$PrintResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
