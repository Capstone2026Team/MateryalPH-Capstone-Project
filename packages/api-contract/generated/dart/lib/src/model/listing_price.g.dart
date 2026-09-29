// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_price.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingPriceCurrencyEnum _$listingPriceCurrencyEnum_PHP =
    const ListingPriceCurrencyEnum._('PHP');

ListingPriceCurrencyEnum _$listingPriceCurrencyEnumValueOf(String name) {
  switch (name) {
    case 'PHP':
      return _$listingPriceCurrencyEnum_PHP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingPriceCurrencyEnum> _$listingPriceCurrencyEnumValues =
    BuiltSet<ListingPriceCurrencyEnum>(const <ListingPriceCurrencyEnum>[
  _$listingPriceCurrencyEnum_PHP,
]);

const ListingPriceTaxCategoryEnum _$listingPriceTaxCategoryEnum_VAT_12 =
    const ListingPriceTaxCategoryEnum._('VAT_12');
const ListingPriceTaxCategoryEnum _$listingPriceTaxCategoryEnum_VAT_ZERO =
    const ListingPriceTaxCategoryEnum._('VAT_ZERO');
const ListingPriceTaxCategoryEnum _$listingPriceTaxCategoryEnum_VAT_EXEMPT =
    const ListingPriceTaxCategoryEnum._('VAT_EXEMPT');
const ListingPriceTaxCategoryEnum _$listingPriceTaxCategoryEnum_NON_VAT =
    const ListingPriceTaxCategoryEnum._('NON_VAT');

ListingPriceTaxCategoryEnum _$listingPriceTaxCategoryEnumValueOf(String name) {
  switch (name) {
    case 'VAT_12':
      return _$listingPriceTaxCategoryEnum_VAT_12;
    case 'VAT_ZERO':
      return _$listingPriceTaxCategoryEnum_VAT_ZERO;
    case 'VAT_EXEMPT':
      return _$listingPriceTaxCategoryEnum_VAT_EXEMPT;
    case 'NON_VAT':
      return _$listingPriceTaxCategoryEnum_NON_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingPriceTaxCategoryEnum>
    _$listingPriceTaxCategoryEnumValues =
    BuiltSet<ListingPriceTaxCategoryEnum>(const <ListingPriceTaxCategoryEnum>[
  _$listingPriceTaxCategoryEnum_VAT_12,
  _$listingPriceTaxCategoryEnum_VAT_ZERO,
  _$listingPriceTaxCategoryEnum_VAT_EXEMPT,
  _$listingPriceTaxCategoryEnum_NON_VAT,
]);

Serializer<ListingPriceCurrencyEnum> _$listingPriceCurrencyEnumSerializer =
    _$ListingPriceCurrencyEnumSerializer();
Serializer<ListingPriceTaxCategoryEnum>
    _$listingPriceTaxCategoryEnumSerializer =
    _$ListingPriceTaxCategoryEnumSerializer();

class _$ListingPriceCurrencyEnumSerializer
    implements PrimitiveSerializer<ListingPriceCurrencyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHP': 'PHP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHP': 'PHP',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingPriceCurrencyEnum];
  @override
  final String wireName = 'ListingPriceCurrencyEnum';

  @override
  Object serialize(Serializers serializers, ListingPriceCurrencyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingPriceCurrencyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingPriceCurrencyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingPriceTaxCategoryEnumSerializer
    implements PrimitiveSerializer<ListingPriceTaxCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[ListingPriceTaxCategoryEnum];
  @override
  final String wireName = 'ListingPriceTaxCategoryEnum';

  @override
  Object serialize(Serializers serializers, ListingPriceTaxCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingPriceTaxCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingPriceTaxCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingPrice extends ListingPrice {
  @override
  final int unitPriceCentavos;
  @override
  final ListingPriceCurrencyEnum currency;
  @override
  final String unitCode;
  @override
  final String unitName;
  @override
  final String packQuantity;
  @override
  final ListingPriceTaxCategoryEnum taxCategory;
  @override
  final String vatLabel;
  @override
  final String priceVersionId;
  @override
  final DateTime effectiveAt;

  factory _$ListingPrice([void Function(ListingPriceBuilder)? updates]) =>
      (ListingPriceBuilder()..update(updates))._build();

  _$ListingPrice._(
      {required this.unitPriceCentavos,
      required this.currency,
      required this.unitCode,
      required this.unitName,
      required this.packQuantity,
      required this.taxCategory,
      required this.vatLabel,
      required this.priceVersionId,
      required this.effectiveAt})
      : super._();
  @override
  ListingPrice rebuild(void Function(ListingPriceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingPriceBuilder toBuilder() => ListingPriceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingPrice &&
        unitPriceCentavos == other.unitPriceCentavos &&
        currency == other.currency &&
        unitCode == other.unitCode &&
        unitName == other.unitName &&
        packQuantity == other.packQuantity &&
        taxCategory == other.taxCategory &&
        vatLabel == other.vatLabel &&
        priceVersionId == other.priceVersionId &&
        effectiveAt == other.effectiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, unitName.hashCode);
    _$hash = $jc(_$hash, packQuantity.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, vatLabel.hashCode);
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingPrice')
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('currency', currency)
          ..add('unitCode', unitCode)
          ..add('unitName', unitName)
          ..add('packQuantity', packQuantity)
          ..add('taxCategory', taxCategory)
          ..add('vatLabel', vatLabel)
          ..add('priceVersionId', priceVersionId)
          ..add('effectiveAt', effectiveAt))
        .toString();
  }
}

class ListingPriceBuilder
    implements Builder<ListingPrice, ListingPriceBuilder> {
  _$ListingPrice? _$v;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  ListingPriceCurrencyEnum? _currency;
  ListingPriceCurrencyEnum? get currency => _$this._currency;
  set currency(ListingPriceCurrencyEnum? currency) =>
      _$this._currency = currency;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _unitName;
  String? get unitName => _$this._unitName;
  set unitName(String? unitName) => _$this._unitName = unitName;

  String? _packQuantity;
  String? get packQuantity => _$this._packQuantity;
  set packQuantity(String? packQuantity) => _$this._packQuantity = packQuantity;

  ListingPriceTaxCategoryEnum? _taxCategory;
  ListingPriceTaxCategoryEnum? get taxCategory => _$this._taxCategory;
  set taxCategory(ListingPriceTaxCategoryEnum? taxCategory) =>
      _$this._taxCategory = taxCategory;

  String? _vatLabel;
  String? get vatLabel => _$this._vatLabel;
  set vatLabel(String? vatLabel) => _$this._vatLabel = vatLabel;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  DateTime? _effectiveAt;
  DateTime? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(DateTime? effectiveAt) => _$this._effectiveAt = effectiveAt;

  ListingPriceBuilder() {
    ListingPrice._defaults(this);
  }

  ListingPriceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _unitPriceCentavos = $v.unitPriceCentavos;
      _currency = $v.currency;
      _unitCode = $v.unitCode;
      _unitName = $v.unitName;
      _packQuantity = $v.packQuantity;
      _taxCategory = $v.taxCategory;
      _vatLabel = $v.vatLabel;
      _priceVersionId = $v.priceVersionId;
      _effectiveAt = $v.effectiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingPrice other) {
    _$v = other as _$ListingPrice;
  }

  @override
  void update(void Function(ListingPriceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingPrice build() => _build();

  _$ListingPrice _build() {
    final _$result = _$v ??
        _$ListingPrice._(
          unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
              unitPriceCentavos, r'ListingPrice', 'unitPriceCentavos'),
          currency: BuiltValueNullFieldError.checkNotNull(
              currency, r'ListingPrice', 'currency'),
          unitCode: BuiltValueNullFieldError.checkNotNull(
              unitCode, r'ListingPrice', 'unitCode'),
          unitName: BuiltValueNullFieldError.checkNotNull(
              unitName, r'ListingPrice', 'unitName'),
          packQuantity: BuiltValueNullFieldError.checkNotNull(
              packQuantity, r'ListingPrice', 'packQuantity'),
          taxCategory: BuiltValueNullFieldError.checkNotNull(
              taxCategory, r'ListingPrice', 'taxCategory'),
          vatLabel: BuiltValueNullFieldError.checkNotNull(
              vatLabel, r'ListingPrice', 'vatLabel'),
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'ListingPrice', 'priceVersionId'),
          effectiveAt: BuiltValueNullFieldError.checkNotNull(
              effectiveAt, r'ListingPrice', 'effectiveAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
