// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_line_current.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartLineCurrentTaxCategoryEnum _$cartLineCurrentTaxCategoryEnum_VAT_12 =
    const CartLineCurrentTaxCategoryEnum._('VAT_12');
const CartLineCurrentTaxCategoryEnum _$cartLineCurrentTaxCategoryEnum_VAT_ZERO =
    const CartLineCurrentTaxCategoryEnum._('VAT_ZERO');
const CartLineCurrentTaxCategoryEnum
    _$cartLineCurrentTaxCategoryEnum_VAT_EXEMPT =
    const CartLineCurrentTaxCategoryEnum._('VAT_EXEMPT');
const CartLineCurrentTaxCategoryEnum _$cartLineCurrentTaxCategoryEnum_NON_VAT =
    const CartLineCurrentTaxCategoryEnum._('NON_VAT');

CartLineCurrentTaxCategoryEnum _$cartLineCurrentTaxCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'VAT_12':
      return _$cartLineCurrentTaxCategoryEnum_VAT_12;
    case 'VAT_ZERO':
      return _$cartLineCurrentTaxCategoryEnum_VAT_ZERO;
    case 'VAT_EXEMPT':
      return _$cartLineCurrentTaxCategoryEnum_VAT_EXEMPT;
    case 'NON_VAT':
      return _$cartLineCurrentTaxCategoryEnum_NON_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartLineCurrentTaxCategoryEnum>
    _$cartLineCurrentTaxCategoryEnumValues = BuiltSet<
        CartLineCurrentTaxCategoryEnum>(const <CartLineCurrentTaxCategoryEnum>[
  _$cartLineCurrentTaxCategoryEnum_VAT_12,
  _$cartLineCurrentTaxCategoryEnum_VAT_ZERO,
  _$cartLineCurrentTaxCategoryEnum_VAT_EXEMPT,
  _$cartLineCurrentTaxCategoryEnum_NON_VAT,
]);

const CartLineCurrentStockLabelEnum _$cartLineCurrentStockLabelEnum_IN_STOCK =
    const CartLineCurrentStockLabelEnum._('IN_STOCK');
const CartLineCurrentStockLabelEnum
    _$cartLineCurrentStockLabelEnum_LIMITED_STOCK =
    const CartLineCurrentStockLabelEnum._('LIMITED_STOCK');
const CartLineCurrentStockLabelEnum
    _$cartLineCurrentStockLabelEnum_OUT_OF_STOCK =
    const CartLineCurrentStockLabelEnum._('OUT_OF_STOCK');

CartLineCurrentStockLabelEnum _$cartLineCurrentStockLabelEnumValueOf(
    String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$cartLineCurrentStockLabelEnum_IN_STOCK;
    case 'LIMITED_STOCK':
      return _$cartLineCurrentStockLabelEnum_LIMITED_STOCK;
    case 'OUT_OF_STOCK':
      return _$cartLineCurrentStockLabelEnum_OUT_OF_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartLineCurrentStockLabelEnum>
    _$cartLineCurrentStockLabelEnumValues = BuiltSet<
        CartLineCurrentStockLabelEnum>(const <CartLineCurrentStockLabelEnum>[
  _$cartLineCurrentStockLabelEnum_IN_STOCK,
  _$cartLineCurrentStockLabelEnum_LIMITED_STOCK,
  _$cartLineCurrentStockLabelEnum_OUT_OF_STOCK,
]);

Serializer<CartLineCurrentTaxCategoryEnum>
    _$cartLineCurrentTaxCategoryEnumSerializer =
    _$CartLineCurrentTaxCategoryEnumSerializer();
Serializer<CartLineCurrentStockLabelEnum>
    _$cartLineCurrentStockLabelEnumSerializer =
    _$CartLineCurrentStockLabelEnumSerializer();

class _$CartLineCurrentTaxCategoryEnumSerializer
    implements PrimitiveSerializer<CartLineCurrentTaxCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[CartLineCurrentTaxCategoryEnum];
  @override
  final String wireName = 'CartLineCurrentTaxCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, CartLineCurrentTaxCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartLineCurrentTaxCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartLineCurrentTaxCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartLineCurrentStockLabelEnumSerializer
    implements PrimitiveSerializer<CartLineCurrentStockLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[CartLineCurrentStockLabelEnum];
  @override
  final String wireName = 'CartLineCurrentStockLabelEnum';

  @override
  Object serialize(
          Serializers serializers, CartLineCurrentStockLabelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartLineCurrentStockLabelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartLineCurrentStockLabelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartLineCurrent extends CartLineCurrent {
  @override
  final String priceVersionId;
  @override
  final int unitPriceCentavos;
  @override
  final CartLineCurrentTaxCategoryEnum taxCategory;
  @override
  final int appliedUnitPriceCentavos;
  @override
  final String appliedPriceVersionId;
  @override
  final bool volumeTierApplied;
  @override
  final CartLineCurrentStockLabelEnum stockLabel;
  @override
  final bool vacationMode;

  factory _$CartLineCurrent([void Function(CartLineCurrentBuilder)? updates]) =>
      (CartLineCurrentBuilder()..update(updates))._build();

  _$CartLineCurrent._(
      {required this.priceVersionId,
      required this.unitPriceCentavos,
      required this.taxCategory,
      required this.appliedUnitPriceCentavos,
      required this.appliedPriceVersionId,
      required this.volumeTierApplied,
      required this.stockLabel,
      required this.vacationMode})
      : super._();
  @override
  CartLineCurrent rebuild(void Function(CartLineCurrentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartLineCurrentBuilder toBuilder() => CartLineCurrentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartLineCurrent &&
        priceVersionId == other.priceVersionId &&
        unitPriceCentavos == other.unitPriceCentavos &&
        taxCategory == other.taxCategory &&
        appliedUnitPriceCentavos == other.appliedUnitPriceCentavos &&
        appliedPriceVersionId == other.appliedPriceVersionId &&
        volumeTierApplied == other.volumeTierApplied &&
        stockLabel == other.stockLabel &&
        vacationMode == other.vacationMode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, appliedUnitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, appliedPriceVersionId.hashCode);
    _$hash = $jc(_$hash, volumeTierApplied.hashCode);
    _$hash = $jc(_$hash, stockLabel.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartLineCurrent')
          ..add('priceVersionId', priceVersionId)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('taxCategory', taxCategory)
          ..add('appliedUnitPriceCentavos', appliedUnitPriceCentavos)
          ..add('appliedPriceVersionId', appliedPriceVersionId)
          ..add('volumeTierApplied', volumeTierApplied)
          ..add('stockLabel', stockLabel)
          ..add('vacationMode', vacationMode))
        .toString();
  }
}

class CartLineCurrentBuilder
    implements Builder<CartLineCurrent, CartLineCurrentBuilder> {
  _$CartLineCurrent? _$v;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  CartLineCurrentTaxCategoryEnum? _taxCategory;
  CartLineCurrentTaxCategoryEnum? get taxCategory => _$this._taxCategory;
  set taxCategory(CartLineCurrentTaxCategoryEnum? taxCategory) =>
      _$this._taxCategory = taxCategory;

  int? _appliedUnitPriceCentavos;
  int? get appliedUnitPriceCentavos => _$this._appliedUnitPriceCentavos;
  set appliedUnitPriceCentavos(int? appliedUnitPriceCentavos) =>
      _$this._appliedUnitPriceCentavos = appliedUnitPriceCentavos;

  String? _appliedPriceVersionId;
  String? get appliedPriceVersionId => _$this._appliedPriceVersionId;
  set appliedPriceVersionId(String? appliedPriceVersionId) =>
      _$this._appliedPriceVersionId = appliedPriceVersionId;

  bool? _volumeTierApplied;
  bool? get volumeTierApplied => _$this._volumeTierApplied;
  set volumeTierApplied(bool? volumeTierApplied) =>
      _$this._volumeTierApplied = volumeTierApplied;

  CartLineCurrentStockLabelEnum? _stockLabel;
  CartLineCurrentStockLabelEnum? get stockLabel => _$this._stockLabel;
  set stockLabel(CartLineCurrentStockLabelEnum? stockLabel) =>
      _$this._stockLabel = stockLabel;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  CartLineCurrentBuilder() {
    CartLineCurrent._defaults(this);
  }

  CartLineCurrentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _taxCategory = $v.taxCategory;
      _appliedUnitPriceCentavos = $v.appliedUnitPriceCentavos;
      _appliedPriceVersionId = $v.appliedPriceVersionId;
      _volumeTierApplied = $v.volumeTierApplied;
      _stockLabel = $v.stockLabel;
      _vacationMode = $v.vacationMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartLineCurrent other) {
    _$v = other as _$CartLineCurrent;
  }

  @override
  void update(void Function(CartLineCurrentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartLineCurrent build() => _build();

  _$CartLineCurrent _build() {
    final _$result = _$v ??
        _$CartLineCurrent._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'CartLineCurrent', 'priceVersionId'),
          unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
              unitPriceCentavos, r'CartLineCurrent', 'unitPriceCentavos'),
          taxCategory: BuiltValueNullFieldError.checkNotNull(
              taxCategory, r'CartLineCurrent', 'taxCategory'),
          appliedUnitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
              appliedUnitPriceCentavos,
              r'CartLineCurrent',
              'appliedUnitPriceCentavos'),
          appliedPriceVersionId: BuiltValueNullFieldError.checkNotNull(
              appliedPriceVersionId,
              r'CartLineCurrent',
              'appliedPriceVersionId'),
          volumeTierApplied: BuiltValueNullFieldError.checkNotNull(
              volumeTierApplied, r'CartLineCurrent', 'volumeTierApplied'),
          stockLabel: BuiltValueNullFieldError.checkNotNull(
              stockLabel, r'CartLineCurrent', 'stockLabel'),
          vacationMode: BuiltValueNullFieldError.checkNotNull(
              vacationMode, r'CartLineCurrent', 'vacationMode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
