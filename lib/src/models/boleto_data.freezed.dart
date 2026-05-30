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

/// @nodoc
mixin _$BoletoData {
  // Cabeçalho / banco
  String? get nomeBanco => throw _privateConstructorUsedError;
  String? get numeroDigitoBanco =>
      throw _privateConstructorUsedError; // ex: "001-9" (ou separação de número + dígito)
  // Identificadores / linhas
  String? get numeroBoleto =>
      throw _privateConstructorUsedError; // linha digitável (47/48 dígitos) — legado/alias
  String? get linhaDigitavel =>
      throw _privateConstructorUsedError; // alternativa/alias para linha digitável
  String get codigoBarras =>
      throw _privateConstructorUsedError; // 44 dígitos do código de barras (obrigatório)
  // Local e beneficiário
  String? get localPgto => throw _privateConstructorUsedError;
  String? get beneficiario => throw _privateConstructorUsedError;
  String? get nomeEnderecoBeneficiario =>
      throw _privateConstructorUsedError; // Documento
  DateTime? get docData =>
      throw _privateConstructorUsedError; // data do documento (emissão)
  DateTime? get vencimento =>
      throw _privateConstructorUsedError; // data de vencimento explícita (adicionada)
  String? get docNumero => throw _privateConstructorUsedError;
  String? get docEspecie => throw _privateConstructorUsedError;
  bool? get aceite =>
      throw _privateConstructorUsedError; // true -> aceite, false -> não aceite
  // Processamento / uso do banco
  DateTime? get processamentoData => throw _privateConstructorUsedError;
  String? get usoDoBanco => throw _privateConstructorUsedError;
  String? get agenciaCodigoBeneficiario => throw _privateConstructorUsedError;
  String? get nossoNumero =>
      throw _privateConstructorUsedError; // Carteira / espécie / quantidade
  String? get carteira => throw _privateConstructorUsedError;
  String? get especie => throw _privateConstructorUsedError;
  int? get quantidade => throw _privateConstructorUsedError; // Valores
  double? get valor => throw _privateConstructorUsedError;
  double? get docValor => throw _privateConstructorUsedError;
  double? get descontoAbatimento => throw _privateConstructorUsedError;
  double? get outrasDeducoes => throw _privateConstructorUsedError;
  double? get jurosMulta => throw _privateConstructorUsedError;
  double? get outrosAcrescimos => throw _privateConstructorUsedError;
  double? get valorCobrado =>
      throw _privateConstructorUsedError; // Instruções / texto livre
  List<String>? get instrucoes =>
      throw _privateConstructorUsedError; // Pagador / avalista
  String? get pagador => throw _privateConstructorUsedError;
  String? get pagadorAvalista => throw _privateConstructorUsedError; // Outros
  String? get codigoBaixa => throw _privateConstructorUsedError;

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
    String? nomeBanco,
    String? numeroDigitoBanco,
    String? numeroBoleto,
    String? linhaDigitavel,
    String codigoBarras,
    String? localPgto,
    String? beneficiario,
    String? nomeEnderecoBeneficiario,
    DateTime? docData,
    DateTime? vencimento,
    String? docNumero,
    String? docEspecie,
    bool? aceite,
    DateTime? processamentoData,
    String? usoDoBanco,
    String? agenciaCodigoBeneficiario,
    String? nossoNumero,
    String? carteira,
    String? especie,
    int? quantidade,
    double? valor,
    double? docValor,
    double? descontoAbatimento,
    double? outrasDeducoes,
    double? jurosMulta,
    double? outrosAcrescimos,
    double? valorCobrado,
    List<String>? instrucoes,
    String? pagador,
    String? pagadorAvalista,
    String? codigoBaixa,
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
    Object? nomeBanco = freezed,
    Object? numeroDigitoBanco = freezed,
    Object? numeroBoleto = freezed,
    Object? linhaDigitavel = freezed,
    Object? codigoBarras = null,
    Object? localPgto = freezed,
    Object? beneficiario = freezed,
    Object? nomeEnderecoBeneficiario = freezed,
    Object? docData = freezed,
    Object? vencimento = freezed,
    Object? docNumero = freezed,
    Object? docEspecie = freezed,
    Object? aceite = freezed,
    Object? processamentoData = freezed,
    Object? usoDoBanco = freezed,
    Object? agenciaCodigoBeneficiario = freezed,
    Object? nossoNumero = freezed,
    Object? carteira = freezed,
    Object? especie = freezed,
    Object? quantidade = freezed,
    Object? valor = freezed,
    Object? docValor = freezed,
    Object? descontoAbatimento = freezed,
    Object? outrasDeducoes = freezed,
    Object? jurosMulta = freezed,
    Object? outrosAcrescimos = freezed,
    Object? valorCobrado = freezed,
    Object? instrucoes = freezed,
    Object? pagador = freezed,
    Object? pagadorAvalista = freezed,
    Object? codigoBaixa = freezed,
  }) {
    return _then(
      _value.copyWith(
            nomeBanco: freezed == nomeBanco
                ? _value.nomeBanco
                : nomeBanco // ignore: cast_nullable_to_non_nullable
                      as String?,
            numeroDigitoBanco: freezed == numeroDigitoBanco
                ? _value.numeroDigitoBanco
                : numeroDigitoBanco // ignore: cast_nullable_to_non_nullable
                      as String?,
            numeroBoleto: freezed == numeroBoleto
                ? _value.numeroBoleto
                : numeroBoleto // ignore: cast_nullable_to_non_nullable
                      as String?,
            linhaDigitavel: freezed == linhaDigitavel
                ? _value.linhaDigitavel
                : linhaDigitavel // ignore: cast_nullable_to_non_nullable
                      as String?,
            codigoBarras: null == codigoBarras
                ? _value.codigoBarras
                : codigoBarras // ignore: cast_nullable_to_non_nullable
                      as String,
            localPgto: freezed == localPgto
                ? _value.localPgto
                : localPgto // ignore: cast_nullable_to_non_nullable
                      as String?,
            beneficiario: freezed == beneficiario
                ? _value.beneficiario
                : beneficiario // ignore: cast_nullable_to_non_nullable
                      as String?,
            nomeEnderecoBeneficiario: freezed == nomeEnderecoBeneficiario
                ? _value.nomeEnderecoBeneficiario
                : nomeEnderecoBeneficiario // ignore: cast_nullable_to_non_nullable
                      as String?,
            docData: freezed == docData
                ? _value.docData
                : docData // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            vencimento: freezed == vencimento
                ? _value.vencimento
                : vencimento // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            docNumero: freezed == docNumero
                ? _value.docNumero
                : docNumero // ignore: cast_nullable_to_non_nullable
                      as String?,
            docEspecie: freezed == docEspecie
                ? _value.docEspecie
                : docEspecie // ignore: cast_nullable_to_non_nullable
                      as String?,
            aceite: freezed == aceite
                ? _value.aceite
                : aceite // ignore: cast_nullable_to_non_nullable
                      as bool?,
            processamentoData: freezed == processamentoData
                ? _value.processamentoData
                : processamentoData // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            usoDoBanco: freezed == usoDoBanco
                ? _value.usoDoBanco
                : usoDoBanco // ignore: cast_nullable_to_non_nullable
                      as String?,
            agenciaCodigoBeneficiario: freezed == agenciaCodigoBeneficiario
                ? _value.agenciaCodigoBeneficiario
                : agenciaCodigoBeneficiario // ignore: cast_nullable_to_non_nullable
                      as String?,
            nossoNumero: freezed == nossoNumero
                ? _value.nossoNumero
                : nossoNumero // ignore: cast_nullable_to_non_nullable
                      as String?,
            carteira: freezed == carteira
                ? _value.carteira
                : carteira // ignore: cast_nullable_to_non_nullable
                      as String?,
            especie: freezed == especie
                ? _value.especie
                : especie // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantidade: freezed == quantidade
                ? _value.quantidade
                : quantidade // ignore: cast_nullable_to_non_nullable
                      as int?,
            valor: freezed == valor
                ? _value.valor
                : valor // ignore: cast_nullable_to_non_nullable
                      as double?,
            docValor: freezed == docValor
                ? _value.docValor
                : docValor // ignore: cast_nullable_to_non_nullable
                      as double?,
            descontoAbatimento: freezed == descontoAbatimento
                ? _value.descontoAbatimento
                : descontoAbatimento // ignore: cast_nullable_to_non_nullable
                      as double?,
            outrasDeducoes: freezed == outrasDeducoes
                ? _value.outrasDeducoes
                : outrasDeducoes // ignore: cast_nullable_to_non_nullable
                      as double?,
            jurosMulta: freezed == jurosMulta
                ? _value.jurosMulta
                : jurosMulta // ignore: cast_nullable_to_non_nullable
                      as double?,
            outrosAcrescimos: freezed == outrosAcrescimos
                ? _value.outrosAcrescimos
                : outrosAcrescimos // ignore: cast_nullable_to_non_nullable
                      as double?,
            valorCobrado: freezed == valorCobrado
                ? _value.valorCobrado
                : valorCobrado // ignore: cast_nullable_to_non_nullable
                      as double?,
            instrucoes: freezed == instrucoes
                ? _value.instrucoes
                : instrucoes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            pagador: freezed == pagador
                ? _value.pagador
                : pagador // ignore: cast_nullable_to_non_nullable
                      as String?,
            pagadorAvalista: freezed == pagadorAvalista
                ? _value.pagadorAvalista
                : pagadorAvalista // ignore: cast_nullable_to_non_nullable
                      as String?,
            codigoBaixa: freezed == codigoBaixa
                ? _value.codigoBaixa
                : codigoBaixa // ignore: cast_nullable_to_non_nullable
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
    String? nomeBanco,
    String? numeroDigitoBanco,
    String? numeroBoleto,
    String? linhaDigitavel,
    String codigoBarras,
    String? localPgto,
    String? beneficiario,
    String? nomeEnderecoBeneficiario,
    DateTime? docData,
    DateTime? vencimento,
    String? docNumero,
    String? docEspecie,
    bool? aceite,
    DateTime? processamentoData,
    String? usoDoBanco,
    String? agenciaCodigoBeneficiario,
    String? nossoNumero,
    String? carteira,
    String? especie,
    int? quantidade,
    double? valor,
    double? docValor,
    double? descontoAbatimento,
    double? outrasDeducoes,
    double? jurosMulta,
    double? outrosAcrescimos,
    double? valorCobrado,
    List<String>? instrucoes,
    String? pagador,
    String? pagadorAvalista,
    String? codigoBaixa,
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
    Object? nomeBanco = freezed,
    Object? numeroDigitoBanco = freezed,
    Object? numeroBoleto = freezed,
    Object? linhaDigitavel = freezed,
    Object? codigoBarras = null,
    Object? localPgto = freezed,
    Object? beneficiario = freezed,
    Object? nomeEnderecoBeneficiario = freezed,
    Object? docData = freezed,
    Object? vencimento = freezed,
    Object? docNumero = freezed,
    Object? docEspecie = freezed,
    Object? aceite = freezed,
    Object? processamentoData = freezed,
    Object? usoDoBanco = freezed,
    Object? agenciaCodigoBeneficiario = freezed,
    Object? nossoNumero = freezed,
    Object? carteira = freezed,
    Object? especie = freezed,
    Object? quantidade = freezed,
    Object? valor = freezed,
    Object? docValor = freezed,
    Object? descontoAbatimento = freezed,
    Object? outrasDeducoes = freezed,
    Object? jurosMulta = freezed,
    Object? outrosAcrescimos = freezed,
    Object? valorCobrado = freezed,
    Object? instrucoes = freezed,
    Object? pagador = freezed,
    Object? pagadorAvalista = freezed,
    Object? codigoBaixa = freezed,
  }) {
    return _then(
      _$BoletoDataImpl(
        nomeBanco: freezed == nomeBanco
            ? _value.nomeBanco
            : nomeBanco // ignore: cast_nullable_to_non_nullable
                  as String?,
        numeroDigitoBanco: freezed == numeroDigitoBanco
            ? _value.numeroDigitoBanco
            : numeroDigitoBanco // ignore: cast_nullable_to_non_nullable
                  as String?,
        numeroBoleto: freezed == numeroBoleto
            ? _value.numeroBoleto
            : numeroBoleto // ignore: cast_nullable_to_non_nullable
                  as String?,
        linhaDigitavel: freezed == linhaDigitavel
            ? _value.linhaDigitavel
            : linhaDigitavel // ignore: cast_nullable_to_non_nullable
                  as String?,
        codigoBarras: null == codigoBarras
            ? _value.codigoBarras
            : codigoBarras // ignore: cast_nullable_to_non_nullable
                  as String,
        localPgto: freezed == localPgto
            ? _value.localPgto
            : localPgto // ignore: cast_nullable_to_non_nullable
                  as String?,
        beneficiario: freezed == beneficiario
            ? _value.beneficiario
            : beneficiario // ignore: cast_nullable_to_non_nullable
                  as String?,
        nomeEnderecoBeneficiario: freezed == nomeEnderecoBeneficiario
            ? _value.nomeEnderecoBeneficiario
            : nomeEnderecoBeneficiario // ignore: cast_nullable_to_non_nullable
                  as String?,
        docData: freezed == docData
            ? _value.docData
            : docData // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        vencimento: freezed == vencimento
            ? _value.vencimento
            : vencimento // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        docNumero: freezed == docNumero
            ? _value.docNumero
            : docNumero // ignore: cast_nullable_to_non_nullable
                  as String?,
        docEspecie: freezed == docEspecie
            ? _value.docEspecie
            : docEspecie // ignore: cast_nullable_to_non_nullable
                  as String?,
        aceite: freezed == aceite
            ? _value.aceite
            : aceite // ignore: cast_nullable_to_non_nullable
                  as bool?,
        processamentoData: freezed == processamentoData
            ? _value.processamentoData
            : processamentoData // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        usoDoBanco: freezed == usoDoBanco
            ? _value.usoDoBanco
            : usoDoBanco // ignore: cast_nullable_to_non_nullable
                  as String?,
        agenciaCodigoBeneficiario: freezed == agenciaCodigoBeneficiario
            ? _value.agenciaCodigoBeneficiario
            : agenciaCodigoBeneficiario // ignore: cast_nullable_to_non_nullable
                  as String?,
        nossoNumero: freezed == nossoNumero
            ? _value.nossoNumero
            : nossoNumero // ignore: cast_nullable_to_non_nullable
                  as String?,
        carteira: freezed == carteira
            ? _value.carteira
            : carteira // ignore: cast_nullable_to_non_nullable
                  as String?,
        especie: freezed == especie
            ? _value.especie
            : especie // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantidade: freezed == quantidade
            ? _value.quantidade
            : quantidade // ignore: cast_nullable_to_non_nullable
                  as int?,
        valor: freezed == valor
            ? _value.valor
            : valor // ignore: cast_nullable_to_non_nullable
                  as double?,
        docValor: freezed == docValor
            ? _value.docValor
            : docValor // ignore: cast_nullable_to_non_nullable
                  as double?,
        descontoAbatimento: freezed == descontoAbatimento
            ? _value.descontoAbatimento
            : descontoAbatimento // ignore: cast_nullable_to_non_nullable
                  as double?,
        outrasDeducoes: freezed == outrasDeducoes
            ? _value.outrasDeducoes
            : outrasDeducoes // ignore: cast_nullable_to_non_nullable
                  as double?,
        jurosMulta: freezed == jurosMulta
            ? _value.jurosMulta
            : jurosMulta // ignore: cast_nullable_to_non_nullable
                  as double?,
        outrosAcrescimos: freezed == outrosAcrescimos
            ? _value.outrosAcrescimos
            : outrosAcrescimos // ignore: cast_nullable_to_non_nullable
                  as double?,
        valorCobrado: freezed == valorCobrado
            ? _value.valorCobrado
            : valorCobrado // ignore: cast_nullable_to_non_nullable
                  as double?,
        instrucoes: freezed == instrucoes
            ? _value._instrucoes
            : instrucoes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        pagador: freezed == pagador
            ? _value.pagador
            : pagador // ignore: cast_nullable_to_non_nullable
                  as String?,
        pagadorAvalista: freezed == pagadorAvalista
            ? _value.pagadorAvalista
            : pagadorAvalista // ignore: cast_nullable_to_non_nullable
                  as String?,
        codigoBaixa: freezed == codigoBaixa
            ? _value.codigoBaixa
            : codigoBaixa // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BoletoDataImpl implements _BoletoData {
  const _$BoletoDataImpl({
    this.nomeBanco,
    this.numeroDigitoBanco,
    this.numeroBoleto,
    this.linhaDigitavel,
    required this.codigoBarras,
    this.localPgto,
    this.beneficiario,
    this.nomeEnderecoBeneficiario,
    this.docData,
    this.vencimento,
    this.docNumero,
    this.docEspecie,
    this.aceite,
    this.processamentoData,
    this.usoDoBanco,
    this.agenciaCodigoBeneficiario,
    this.nossoNumero,
    this.carteira,
    this.especie,
    this.quantidade,
    this.valor,
    this.docValor,
    this.descontoAbatimento,
    this.outrasDeducoes,
    this.jurosMulta,
    this.outrosAcrescimos,
    this.valorCobrado,
    final List<String>? instrucoes,
    this.pagador,
    this.pagadorAvalista,
    this.codigoBaixa,
  }) : _instrucoes = instrucoes;

  // Cabeçalho / banco
  @override
  final String? nomeBanco;
  @override
  final String? numeroDigitoBanco;
  // ex: "001-9" (ou separação de número + dígito)
  // Identificadores / linhas
  @override
  final String? numeroBoleto;
  // linha digitável (47/48 dígitos) — legado/alias
  @override
  final String? linhaDigitavel;
  // alternativa/alias para linha digitável
  @override
  final String codigoBarras;
  // 44 dígitos do código de barras (obrigatório)
  // Local e beneficiário
  @override
  final String? localPgto;
  @override
  final String? beneficiario;
  @override
  final String? nomeEnderecoBeneficiario;
  // Documento
  @override
  final DateTime? docData;
  // data do documento (emissão)
  @override
  final DateTime? vencimento;
  // data de vencimento explícita (adicionada)
  @override
  final String? docNumero;
  @override
  final String? docEspecie;
  @override
  final bool? aceite;
  // true -> aceite, false -> não aceite
  // Processamento / uso do banco
  @override
  final DateTime? processamentoData;
  @override
  final String? usoDoBanco;
  @override
  final String? agenciaCodigoBeneficiario;
  @override
  final String? nossoNumero;
  // Carteira / espécie / quantidade
  @override
  final String? carteira;
  @override
  final String? especie;
  @override
  final int? quantidade;
  // Valores
  @override
  final double? valor;
  @override
  final double? docValor;
  @override
  final double? descontoAbatimento;
  @override
  final double? outrasDeducoes;
  @override
  final double? jurosMulta;
  @override
  final double? outrosAcrescimos;
  @override
  final double? valorCobrado;
  // Instruções / texto livre
  final List<String>? _instrucoes;
  // Instruções / texto livre
  @override
  List<String>? get instrucoes {
    final value = _instrucoes;
    if (value == null) return null;
    if (_instrucoes is EqualUnmodifiableListView) return _instrucoes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Pagador / avalista
  @override
  final String? pagador;
  @override
  final String? pagadorAvalista;
  // Outros
  @override
  final String? codigoBaixa;

  @override
  String toString() {
    return 'BoletoData(nomeBanco: $nomeBanco, numeroDigitoBanco: $numeroDigitoBanco, numeroBoleto: $numeroBoleto, linhaDigitavel: $linhaDigitavel, codigoBarras: $codigoBarras, localPgto: $localPgto, beneficiario: $beneficiario, nomeEnderecoBeneficiario: $nomeEnderecoBeneficiario, docData: $docData, vencimento: $vencimento, docNumero: $docNumero, docEspecie: $docEspecie, aceite: $aceite, processamentoData: $processamentoData, usoDoBanco: $usoDoBanco, agenciaCodigoBeneficiario: $agenciaCodigoBeneficiario, nossoNumero: $nossoNumero, carteira: $carteira, especie: $especie, quantidade: $quantidade, valor: $valor, docValor: $docValor, descontoAbatimento: $descontoAbatimento, outrasDeducoes: $outrasDeducoes, jurosMulta: $jurosMulta, outrosAcrescimos: $outrosAcrescimos, valorCobrado: $valorCobrado, instrucoes: $instrucoes, pagador: $pagador, pagadorAvalista: $pagadorAvalista, codigoBaixa: $codigoBaixa)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoletoDataImpl &&
            (identical(other.nomeBanco, nomeBanco) ||
                other.nomeBanco == nomeBanco) &&
            (identical(other.numeroDigitoBanco, numeroDigitoBanco) ||
                other.numeroDigitoBanco == numeroDigitoBanco) &&
            (identical(other.numeroBoleto, numeroBoleto) ||
                other.numeroBoleto == numeroBoleto) &&
            (identical(other.linhaDigitavel, linhaDigitavel) ||
                other.linhaDigitavel == linhaDigitavel) &&
            (identical(other.codigoBarras, codigoBarras) ||
                other.codigoBarras == codigoBarras) &&
            (identical(other.localPgto, localPgto) ||
                other.localPgto == localPgto) &&
            (identical(other.beneficiario, beneficiario) ||
                other.beneficiario == beneficiario) &&
            (identical(
                  other.nomeEnderecoBeneficiario,
                  nomeEnderecoBeneficiario,
                ) ||
                other.nomeEnderecoBeneficiario == nomeEnderecoBeneficiario) &&
            (identical(other.docData, docData) || other.docData == docData) &&
            (identical(other.vencimento, vencimento) ||
                other.vencimento == vencimento) &&
            (identical(other.docNumero, docNumero) ||
                other.docNumero == docNumero) &&
            (identical(other.docEspecie, docEspecie) ||
                other.docEspecie == docEspecie) &&
            (identical(other.aceite, aceite) || other.aceite == aceite) &&
            (identical(other.processamentoData, processamentoData) ||
                other.processamentoData == processamentoData) &&
            (identical(other.usoDoBanco, usoDoBanco) ||
                other.usoDoBanco == usoDoBanco) &&
            (identical(
                  other.agenciaCodigoBeneficiario,
                  agenciaCodigoBeneficiario,
                ) ||
                other.agenciaCodigoBeneficiario == agenciaCodigoBeneficiario) &&
            (identical(other.nossoNumero, nossoNumero) ||
                other.nossoNumero == nossoNumero) &&
            (identical(other.carteira, carteira) ||
                other.carteira == carteira) &&
            (identical(other.especie, especie) || other.especie == especie) &&
            (identical(other.quantidade, quantidade) ||
                other.quantidade == quantidade) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.docValor, docValor) ||
                other.docValor == docValor) &&
            (identical(other.descontoAbatimento, descontoAbatimento) ||
                other.descontoAbatimento == descontoAbatimento) &&
            (identical(other.outrasDeducoes, outrasDeducoes) ||
                other.outrasDeducoes == outrasDeducoes) &&
            (identical(other.jurosMulta, jurosMulta) ||
                other.jurosMulta == jurosMulta) &&
            (identical(other.outrosAcrescimos, outrosAcrescimos) ||
                other.outrosAcrescimos == outrosAcrescimos) &&
            (identical(other.valorCobrado, valorCobrado) ||
                other.valorCobrado == valorCobrado) &&
            const DeepCollectionEquality().equals(
              other._instrucoes,
              _instrucoes,
            ) &&
            (identical(other.pagador, pagador) || other.pagador == pagador) &&
            (identical(other.pagadorAvalista, pagadorAvalista) ||
                other.pagadorAvalista == pagadorAvalista) &&
            (identical(other.codigoBaixa, codigoBaixa) ||
                other.codigoBaixa == codigoBaixa));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    nomeBanco,
    numeroDigitoBanco,
    numeroBoleto,
    linhaDigitavel,
    codigoBarras,
    localPgto,
    beneficiario,
    nomeEnderecoBeneficiario,
    docData,
    vencimento,
    docNumero,
    docEspecie,
    aceite,
    processamentoData,
    usoDoBanco,
    agenciaCodigoBeneficiario,
    nossoNumero,
    carteira,
    especie,
    quantidade,
    valor,
    docValor,
    descontoAbatimento,
    outrasDeducoes,
    jurosMulta,
    outrosAcrescimos,
    valorCobrado,
    const DeepCollectionEquality().hash(_instrucoes),
    pagador,
    pagadorAvalista,
    codigoBaixa,
  ]);

  /// Create a copy of BoletoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoletoDataImplCopyWith<_$BoletoDataImpl> get copyWith =>
      __$$BoletoDataImplCopyWithImpl<_$BoletoDataImpl>(this, _$identity);
}

abstract class _BoletoData implements BoletoData {
  const factory _BoletoData({
    final String? nomeBanco,
    final String? numeroDigitoBanco,
    final String? numeroBoleto,
    final String? linhaDigitavel,
    required final String codigoBarras,
    final String? localPgto,
    final String? beneficiario,
    final String? nomeEnderecoBeneficiario,
    final DateTime? docData,
    final DateTime? vencimento,
    final String? docNumero,
    final String? docEspecie,
    final bool? aceite,
    final DateTime? processamentoData,
    final String? usoDoBanco,
    final String? agenciaCodigoBeneficiario,
    final String? nossoNumero,
    final String? carteira,
    final String? especie,
    final int? quantidade,
    final double? valor,
    final double? docValor,
    final double? descontoAbatimento,
    final double? outrasDeducoes,
    final double? jurosMulta,
    final double? outrosAcrescimos,
    final double? valorCobrado,
    final List<String>? instrucoes,
    final String? pagador,
    final String? pagadorAvalista,
    final String? codigoBaixa,
  }) = _$BoletoDataImpl;

  // Cabeçalho / banco
  @override
  String? get nomeBanco;
  @override
  String? get numeroDigitoBanco; // ex: "001-9" (ou separação de número + dígito)
  // Identificadores / linhas
  @override
  String? get numeroBoleto; // linha digitável (47/48 dígitos) — legado/alias
  @override
  String? get linhaDigitavel; // alternativa/alias para linha digitável
  @override
  String get codigoBarras; // 44 dígitos do código de barras (obrigatório)
  // Local e beneficiário
  @override
  String? get localPgto;
  @override
  String? get beneficiario;
  @override
  String? get nomeEnderecoBeneficiario; // Documento
  @override
  DateTime? get docData; // data do documento (emissão)
  @override
  DateTime? get vencimento; // data de vencimento explícita (adicionada)
  @override
  String? get docNumero;
  @override
  String? get docEspecie;
  @override
  bool? get aceite; // true -> aceite, false -> não aceite
  // Processamento / uso do banco
  @override
  DateTime? get processamentoData;
  @override
  String? get usoDoBanco;
  @override
  String? get agenciaCodigoBeneficiario;
  @override
  String? get nossoNumero; // Carteira / espécie / quantidade
  @override
  String? get carteira;
  @override
  String? get especie;
  @override
  int? get quantidade; // Valores
  @override
  double? get valor;
  @override
  double? get docValor;
  @override
  double? get descontoAbatimento;
  @override
  double? get outrasDeducoes;
  @override
  double? get jurosMulta;
  @override
  double? get outrosAcrescimos;
  @override
  double? get valorCobrado; // Instruções / texto livre
  @override
  List<String>? get instrucoes; // Pagador / avalista
  @override
  String? get pagador;
  @override
  String? get pagadorAvalista; // Outros
  @override
  String? get codigoBaixa;

  /// Create a copy of BoletoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoletoDataImplCopyWith<_$BoletoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
