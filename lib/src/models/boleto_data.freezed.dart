// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boleto_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BoletoData _$BoletoDataFromJson(Map<String, dynamic> json) {
  return _BoletoData.fromJson(json);
}

/// @nodoc
mixin _$BoletoData {
  /// Nome ou razão social do beneficiário (cedente).
  String get beneficiario => throw _privateConstructorUsedError;

  /// Nome ou razão social do pagador (sacado).
  String get pagador => throw _privateConstructorUsedError;

  /// Valor do boleto em reais.
  double get valor => throw _privateConstructorUsedError;

  /// Data de vencimento do boleto.
  DateTime get vencimento => throw _privateConstructorUsedError;

  /// Linha digitável completa (47 ou 48 dígitos).
  String get linhaDigitavel => throw _privateConstructorUsedError;

  /// 44 dígitos do código de barras.
  String get codigoBarras => throw _privateConstructorUsedError;

  /// Nosso número — identificador do boleto no banco.
  String get nossoNumero => throw _privateConstructorUsedError;

  /// Instruções adicionais ao caixa/pagador (ex: multa, desconto).
  List<String>? get instrucoes => throw _privateConstructorUsedError;

  /// Nome ou código do banco emissor (ex: "BANCO DO BRASIL", "237").
  String? get banco => throw _privateConstructorUsedError;

  /// Agência do beneficiário (ex: "1234-5").
  String? get agencia => throw _privateConstructorUsedError;

  /// Conta do beneficiário (ex: "00012345-6").
  String? get conta => throw _privateConstructorUsedError;

  /// Data de emissão do documento.
  DateTime? get dataDocumento => throw _privateConstructorUsedError;

  /// Número do documento (identificador interno).
  String? get numeroDocumento => throw _privateConstructorUsedError;

  /// Espécie do documento (ex: "DM", "NF").
  String? get especie => throw _privateConstructorUsedError;

  /// Aceite (ex: "N" ou "S").
  String? get aceite => throw _privateConstructorUsedError;

  /// Serializes this BoletoData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoletoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoletoDataCopyWith<BoletoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoletoDataCopyWith<$Res> {
  factory $BoletoDataCopyWith(
    BoletoData value,
    $Res Function(BoletoData) then,
  ) = _$BoletoDataCopyWithImpl<$Res, BoletoData>;
  @useResult
  $Res call({
    String beneficiario,
    String pagador,
    double valor,
    DateTime vencimento,
    String linhaDigitavel,
    String codigoBarras,
    String nossoNumero,
    List<String>? instrucoes,
    String? banco,
    String? agencia,
    String? conta,
    DateTime? dataDocumento,
    String? numeroDocumento,
    String? especie,
    String? aceite,
  });
}

/// @nodoc
class _$BoletoDataCopyWithImpl<$Res, $Val extends BoletoData>
    implements $BoletoDataCopyWith<$Res> {
  _$BoletoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoletoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beneficiario = null,
    Object? pagador = null,
    Object? valor = null,
    Object? vencimento = null,
    Object? linhaDigitavel = null,
    Object? codigoBarras = null,
    Object? nossoNumero = null,
    Object? instrucoes = freezed,
    Object? banco = freezed,
    Object? agencia = freezed,
    Object? conta = freezed,
    Object? dataDocumento = freezed,
    Object? numeroDocumento = freezed,
    Object? especie = freezed,
    Object? aceite = freezed,
  }) {
    return _then(
      _value.copyWith(
            beneficiario: null == beneficiario
                ? _value.beneficiario
                : beneficiario // ignore: cast_nullable_to_non_nullable
                      as String,
            pagador: null == pagador
                ? _value.pagador
                : pagador // ignore: cast_nullable_to_non_nullable
                      as String,
            valor: null == valor
                ? _value.valor
                : valor // ignore: cast_nullable_to_non_nullable
                      as double,
            vencimento: null == vencimento
                ? _value.vencimento
                : vencimento // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            linhaDigitavel: null == linhaDigitavel
                ? _value.linhaDigitavel
                : linhaDigitavel // ignore: cast_nullable_to_non_nullable
                      as String,
            codigoBarras: null == codigoBarras
                ? _value.codigoBarras
                : codigoBarras // ignore: cast_nullable_to_non_nullable
                      as String,
            nossoNumero: null == nossoNumero
                ? _value.nossoNumero
                : nossoNumero // ignore: cast_nullable_to_non_nullable
                      as String,
            instrucoes: freezed == instrucoes
                ? _value.instrucoes
                : instrucoes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            banco: freezed == banco
                ? _value.banco
                : banco // ignore: cast_nullable_to_non_nullable
                      as String?,
            agencia: freezed == agencia
                ? _value.agencia
                : agencia // ignore: cast_nullable_to_non_nullable
                      as String?,
            conta: freezed == conta
                ? _value.conta
                : conta // ignore: cast_nullable_to_non_nullable
                      as String?,
            dataDocumento: freezed == dataDocumento
                ? _value.dataDocumento
                : dataDocumento // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            numeroDocumento: freezed == numeroDocumento
                ? _value.numeroDocumento
                : numeroDocumento // ignore: cast_nullable_to_non_nullable
                      as String?,
            especie: freezed == especie
                ? _value.especie
                : especie // ignore: cast_nullable_to_non_nullable
                      as String?,
            aceite: freezed == aceite
                ? _value.aceite
                : aceite // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BoletoDataImplCopyWith<$Res>
    implements $BoletoDataCopyWith<$Res> {
  factory _$$BoletoDataImplCopyWith(
    _$BoletoDataImpl value,
    $Res Function(_$BoletoDataImpl) then,
  ) = __$$BoletoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String beneficiario,
    String pagador,
    double valor,
    DateTime vencimento,
    String linhaDigitavel,
    String codigoBarras,
    String nossoNumero,
    List<String>? instrucoes,
    String? banco,
    String? agencia,
    String? conta,
    DateTime? dataDocumento,
    String? numeroDocumento,
    String? especie,
    String? aceite,
  });
}

/// @nodoc
class __$$BoletoDataImplCopyWithImpl<$Res>
    extends _$BoletoDataCopyWithImpl<$Res, _$BoletoDataImpl>
    implements _$$BoletoDataImplCopyWith<$Res> {
  __$$BoletoDataImplCopyWithImpl(
    _$BoletoDataImpl _value,
    $Res Function(_$BoletoDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoletoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beneficiario = null,
    Object? pagador = null,
    Object? valor = null,
    Object? vencimento = null,
    Object? linhaDigitavel = null,
    Object? codigoBarras = null,
    Object? nossoNumero = null,
    Object? instrucoes = freezed,
    Object? banco = freezed,
    Object? agencia = freezed,
    Object? conta = freezed,
    Object? dataDocumento = freezed,
    Object? numeroDocumento = freezed,
    Object? especie = freezed,
    Object? aceite = freezed,
  }) {
    return _then(
      _$BoletoDataImpl(
        beneficiario: null == beneficiario
            ? _value.beneficiario
            : beneficiario // ignore: cast_nullable_to_non_nullable
                  as String,
        pagador: null == pagador
            ? _value.pagador
            : pagador // ignore: cast_nullable_to_non_nullable
                  as String,
        valor: null == valor
            ? _value.valor
            : valor // ignore: cast_nullable_to_non_nullable
                  as double,
        vencimento: null == vencimento
            ? _value.vencimento
            : vencimento // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        linhaDigitavel: null == linhaDigitavel
            ? _value.linhaDigitavel
            : linhaDigitavel // ignore: cast_nullable_to_non_nullable
                  as String,
        codigoBarras: null == codigoBarras
            ? _value.codigoBarras
            : codigoBarras // ignore: cast_nullable_to_non_nullable
                  as String,
        nossoNumero: null == nossoNumero
            ? _value.nossoNumero
            : nossoNumero // ignore: cast_nullable_to_non_nullable
                  as String,
        instrucoes: freezed == instrucoes
            ? _value._instrucoes
            : instrucoes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        banco: freezed == banco
            ? _value.banco
            : banco // ignore: cast_nullable_to_non_nullable
                  as String?,
        agencia: freezed == agencia
            ? _value.agencia
            : agencia // ignore: cast_nullable_to_non_nullable
                  as String?,
        conta: freezed == conta
            ? _value.conta
            : conta // ignore: cast_nullable_to_non_nullable
                  as String?,
        dataDocumento: freezed == dataDocumento
            ? _value.dataDocumento
            : dataDocumento // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        numeroDocumento: freezed == numeroDocumento
            ? _value.numeroDocumento
            : numeroDocumento // ignore: cast_nullable_to_non_nullable
                  as String?,
        especie: freezed == especie
            ? _value.especie
            : especie // ignore: cast_nullable_to_non_nullable
                  as String?,
        aceite: freezed == aceite
            ? _value.aceite
            : aceite // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoletoDataImpl implements _BoletoData {
  const _$BoletoDataImpl({
    required this.beneficiario,
    required this.pagador,
    required this.valor,
    required this.vencimento,
    required this.linhaDigitavel,
    required this.codigoBarras,
    required this.nossoNumero,
    final List<String>? instrucoes,
    this.banco,
    this.agencia,
    this.conta,
    this.dataDocumento,
    this.numeroDocumento,
    this.especie,
    this.aceite,
  }) : _instrucoes = instrucoes;

  factory _$BoletoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoletoDataImplFromJson(json);

  /// Nome ou razão social do beneficiário (cedente).
  @override
  final String beneficiario;

  /// Nome ou razão social do pagador (sacado).
  @override
  final String pagador;

  /// Valor do boleto em reais.
  @override
  final double valor;

  /// Data de vencimento do boleto.
  @override
  final DateTime vencimento;

  /// Linha digitável completa (47 ou 48 dígitos).
  @override
  final String linhaDigitavel;

  /// 44 dígitos do código de barras.
  @override
  final String codigoBarras;

  /// Nosso número — identificador do boleto no banco.
  @override
  final String nossoNumero;

  /// Instruções adicionais ao caixa/pagador (ex: multa, desconto).
  final List<String>? _instrucoes;

  /// Instruções adicionais ao caixa/pagador (ex: multa, desconto).
  @override
  List<String>? get instrucoes {
    final value = _instrucoes;
    if (value == null) return null;
    if (_instrucoes is EqualUnmodifiableListView) return _instrucoes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Nome ou código do banco emissor (ex: "BANCO DO BRASIL", "237").
  @override
  final String? banco;

  /// Agência do beneficiário (ex: "1234-5").
  @override
  final String? agencia;

  /// Conta do beneficiário (ex: "00012345-6").
  @override
  final String? conta;

  /// Data de emissão do documento.
  @override
  final DateTime? dataDocumento;

  /// Número do documento (identificador interno).
  @override
  final String? numeroDocumento;

  /// Espécie do documento (ex: "DM", "NF").
  @override
  final String? especie;

  /// Aceite (ex: "N" ou "S").
  @override
  final String? aceite;

  @override
  String toString() {
    return 'BoletoData(beneficiario: $beneficiario, pagador: $pagador, valor: $valor, vencimento: $vencimento, linhaDigitavel: $linhaDigitavel, codigoBarras: $codigoBarras, nossoNumero: $nossoNumero, instrucoes: $instrucoes, banco: $banco, agencia: $agencia, conta: $conta, dataDocumento: $dataDocumento, numeroDocumento: $numeroDocumento, especie: $especie, aceite: $aceite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoletoDataImpl &&
            (identical(other.beneficiario, beneficiario) ||
                other.beneficiario == beneficiario) &&
            (identical(other.pagador, pagador) || other.pagador == pagador) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.vencimento, vencimento) ||
                other.vencimento == vencimento) &&
            (identical(other.linhaDigitavel, linhaDigitavel) ||
                other.linhaDigitavel == linhaDigitavel) &&
            (identical(other.codigoBarras, codigoBarras) ||
                other.codigoBarras == codigoBarras) &&
            (identical(other.nossoNumero, nossoNumero) ||
                other.nossoNumero == nossoNumero) &&
            const DeepCollectionEquality().equals(
              other._instrucoes,
              _instrucoes,
            ) &&
            (identical(other.banco, banco) || other.banco == banco) &&
            (identical(other.agencia, agencia) || other.agencia == agencia) &&
            (identical(other.conta, conta) || other.conta == conta) &&
            (identical(other.dataDocumento, dataDocumento) ||
                other.dataDocumento == dataDocumento) &&
            (identical(other.numeroDocumento, numeroDocumento) ||
                other.numeroDocumento == numeroDocumento) &&
            (identical(other.especie, especie) || other.especie == especie) &&
            (identical(other.aceite, aceite) || other.aceite == aceite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    beneficiario,
    pagador,
    valor,
    vencimento,
    linhaDigitavel,
    codigoBarras,
    nossoNumero,
    const DeepCollectionEquality().hash(_instrucoes),
    banco,
    agencia,
    conta,
    dataDocumento,
    numeroDocumento,
    especie,
    aceite,
  );

  /// Create a copy of BoletoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoletoDataImplCopyWith<_$BoletoDataImpl> get copyWith =>
      __$$BoletoDataImplCopyWithImpl<_$BoletoDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoletoDataImplToJson(this);
  }
}

abstract class _BoletoData implements BoletoData {
  const factory _BoletoData({
    required final String beneficiario,
    required final String pagador,
    required final double valor,
    required final DateTime vencimento,
    required final String linhaDigitavel,
    required final String codigoBarras,
    required final String nossoNumero,
    final List<String>? instrucoes,
    final String? banco,
    final String? agencia,
    final String? conta,
    final DateTime? dataDocumento,
    final String? numeroDocumento,
    final String? especie,
    final String? aceite,
  }) = _$BoletoDataImpl;

  factory _BoletoData.fromJson(Map<String, dynamic> json) =
      _$BoletoDataImpl.fromJson;

  /// Nome ou razão social do beneficiário (cedente).
  @override
  String get beneficiario;

  /// Nome ou razão social do pagador (sacado).
  @override
  String get pagador;

  /// Valor do boleto em reais.
  @override
  double get valor;

  /// Data de vencimento do boleto.
  @override
  DateTime get vencimento;

  /// Linha digitável completa (47 ou 48 dígitos).
  @override
  String get linhaDigitavel;

  /// 44 dígitos do código de barras.
  @override
  String get codigoBarras;

  /// Nosso número — identificador do boleto no banco.
  @override
  String get nossoNumero;

  /// Instruções adicionais ao caixa/pagador (ex: multa, desconto).
  @override
  List<String>? get instrucoes;

  /// Nome ou código do banco emissor (ex: "BANCO DO BRASIL", "237").
  @override
  String? get banco;

  /// Agência do beneficiário (ex: "1234-5").
  @override
  String? get agencia;

  /// Conta do beneficiário (ex: "00012345-6").
  @override
  String? get conta;

  /// Data de emissão do documento.
  @override
  DateTime? get dataDocumento;

  /// Número do documento (identificador interno).
  @override
  String? get numeroDocumento;

  /// Espécie do documento (ex: "DM", "NF").
  @override
  String? get especie;

  /// Aceite (ex: "N" ou "S").
  @override
  String? get aceite;

  /// Create a copy of BoletoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoletoDataImplCopyWith<_$BoletoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
