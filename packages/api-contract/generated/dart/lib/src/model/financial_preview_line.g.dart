// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_preview_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinancialPreviewLineTaxCategoryEnum
    _$financialPreviewLineTaxCategoryEnum_VAT_12 =
    const FinancialPreviewLineTaxCategoryEnum._('VAT_12');
const FinancialPreviewLineTaxCategoryEnum
    _$financialPreviewLineTaxCategoryEnum_VAT_ZERO =
    const FinancialPreviewLineTaxCategoryEnum._('VAT_ZERO');
const FinancialPreviewLineTaxCategoryEnum
    _$financialPreviewLineTaxCategoryEnum_VAT_EXEMPT =
    const FinancialPreviewLineTaxCategoryEnum._('VAT_EXEMPT');
const FinancialPreviewLineTaxCategoryEnum
    _$financialPreviewLineTaxCategoryEnum_NON_VAT =
    const FinancialPreviewLineTaxCategoryEnum._('NON_VAT');

FinancialPreviewLineTaxCategoryEnum
    _$financialPreviewLineTaxCategoryEnumValueOf(String name) {
  switch (name) {
    case 'VAT_12':
      return _$financialPreviewLineTaxCategoryEnum_VAT_12;
    case 'VAT_ZERO':
      return _$financialPreviewLineTaxCategoryEnum_VAT_ZERO;
    case 'VAT_EXEMPT':
      return _$financialPreviewLineTaxCategoryEnum_VAT_EXEMPT;
    case 'NON_VAT':
      return _$financialPreviewLineTaxCategoryEnum_NON_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinancialPreviewLineTaxCategoryEnum>
    _$financialPreviewLineTaxCategoryEnumValues = BuiltSet<
        FinancialPreviewLineTaxCategoryEnum>(const <FinancialPreviewLineTaxCategoryEnum>[
  _$financialPreviewLineTaxCategoryEnum_VAT_12,
  _$financialPreviewLineTaxCategoryEnum_VAT_ZERO,
  _$financialPreviewLineTaxCategoryEnum_VAT_EXEMPT,
  _$financialPreviewLineTaxCategoryEnum_NON_VAT,
]);

Serializer<FinancialPreviewLineTaxCategoryEnum>
    _$financialPreviewLineTaxCategoryEnumSerializer =
    _$FinancialPreviewLineTaxCategoryEnumSerializer();

class _$FinancialPreviewLineTaxCategoryEnumSerializer
    implements PrimitiveSerializer<FinancialPreviewLineTaxCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VAT_12': 'VAT_12',
    'VAT_ZERO': 'VAT_ZERO',
    'VAT_EXEMPT': 'VAT_EXEMPT',
    'NON_VAT': 'NON_VAT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VAT_12': 'VAT_12',
    'VAT_ZERO': 'VAT_ZERO',
    'VAT_EXEMPT': 'VAT_EXEMPT',
    'NON_VAT': 'NON_VAT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FinancialPreviewLineTaxCategoryEnum
  ];
  @override
  final String wireName = 'FinancialPreviewLineTaxCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, FinancialPreviewLineTaxCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinancialPreviewLineTaxCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinancialPreviewLineTaxCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinancialPreviewLine extends FinancialPreviewLine {
  @override
  final String lineId;
  @override
  final int payableCentavos;
  @override
  final int includedVatCentavos;
  @override
  final FinancialPreviewLineTaxCategoryEnum taxCategory;

  factory _$FinancialPreviewLine(
          [void Function(FinancialPreviewLineBuilder)? updates]) =>
      (FinancialPreviewLineBuilder()..update(updates))._build();

  _$FinancialPreviewLine._(
      {required this.lineId,
      required this.payableCentavos,
      required this.includedVatCentavos,
      required this.taxCategory})
      : super._();
  @override
  FinancialPreviewLine rebuild(
          void Function(FinancialPreviewLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinancialPreviewLineBuilder toBuilder() =>
      FinancialPreviewLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinancialPreviewLine &&
        lineId == other.lineId &&
        payableCentavos == other.payableCentavos &&
        includedVatCentavos == other.includedVatCentavos &&
        taxCategory == other.taxCategory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lineId.hashCode);
    _$hash = $jc(_$hash, payableCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinancialPreviewLine')
          ..add('lineId', lineId)
          ..add('payableCentavos', payableCentavos)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('taxCategory', taxCategory))
        .toString();
  }
}

class FinancialPreviewLineBuilder
    implements Builder<FinancialPreviewLine, FinancialPreviewLineBuilder> {
  _$FinancialPreviewLine? _$v;

  String? _lineId;
  String? get lineId => _$this._lineId;
  set lineId(String? lineId) => _$this._lineId = lineId;

  int? _payableCentavos;
  int? get payableCentavos => _$this._payableCentavos;
  set payableCentavos(int? payableCentavos) =>
      _$this._payableCentavos = payableCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  FinancialPreviewLineTaxCategoryEnum? _taxCategory;
  FinancialPreviewLineTaxCategoryEnum? get taxCategory => _$this._taxCategory;
  set taxCategory(FinancialPreviewLineTaxCategoryEnum? taxCategory) =>
      _$this._taxCategory = taxCategory;

  FinancialPreviewLineBuilder() {
    FinancialPreviewLine._defaults(this);
  }

  FinancialPreviewLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lineId = $v.lineId;
      _payableCentavos = $v.payableCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _taxCategory = $v.taxCategory;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinancialPreviewLine other) {
    _$v = other as _$FinancialPreviewLine;
  }

  @override
  void update(void Function(FinancialPreviewLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinancialPreviewLine build() => _build();

  _$FinancialPreviewLine _build() {
    final _$result = _$v ??
        _$FinancialPreviewLine._(
          lineId: BuiltValueNullFieldError.checkNotNull(
              lineId, r'FinancialPreviewLine', 'lineId'),
          payableCentavos: BuiltValueNullFieldError.checkNotNull(
              payableCentavos, r'FinancialPreviewLine', 'payableCentavos'),
          includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
              includedVatCentavos,
              r'FinancialPreviewLine',
              'includedVatCentavos'),
          taxCategory: BuiltValueNullFieldError.checkNotNull(
              taxCategory, r'FinancialPreviewLine', 'taxCategory'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
