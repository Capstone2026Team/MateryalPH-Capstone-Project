// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_variant_price.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingVariantPriceCurrencyEnum _$listingVariantPriceCurrencyEnum_PHP =
    const ListingVariantPriceCurrencyEnum._('PHP');

ListingVariantPriceCurrencyEnum _$listingVariantPriceCurrencyEnumValueOf(
    String name) {
  switch (name) {
    case 'PHP':
      return _$listingVariantPriceCurrencyEnum_PHP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingVariantPriceCurrencyEnum>
    _$listingVariantPriceCurrencyEnumValues = BuiltSet<
        ListingVariantPriceCurrencyEnum>(const <ListingVariantPriceCurrencyEnum>[
  _$listingVariantPriceCurrencyEnum_PHP,
]);

const ListingVariantPriceTaxCategoryEnum
    _$listingVariantPriceTaxCategoryEnum_VAT_12 =
    const ListingVariantPriceTaxCategoryEnum._('VAT_12');
const ListingVariantPriceTaxCategoryEnum
    _$listingVariantPriceTaxCategoryEnum_VAT_ZERO =
    const ListingVariantPriceTaxCategoryEnum._('VAT_ZERO');
const ListingVariantPriceTaxCategoryEnum
    _$listingVariantPriceTaxCategoryEnum_VAT_EXEMPT =
    const ListingVariantPriceTaxCategoryEnum._('VAT_EXEMPT');
const ListingVariantPriceTaxCategoryEnum
    _$listingVariantPriceTaxCategoryEnum_NON_VAT =
    const ListingVariantPriceTaxCategoryEnum._('NON_VAT');

ListingVariantPriceTaxCategoryEnum _$listingVariantPriceTaxCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'VAT_12':
      return _$listingVariantPriceTaxCategoryEnum_VAT_12;
    case 'VAT_ZERO':
      return _$listingVariantPriceTaxCategoryEnum_VAT_ZERO;
    case 'VAT_EXEMPT':
      return _$listingVariantPriceTaxCategoryEnum_VAT_EXEMPT;
    case 'NON_VAT':
      return _$listingVariantPriceTaxCategoryEnum_NON_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingVariantPriceTaxCategoryEnum>
    _$listingVariantPriceTaxCategoryEnumValues = BuiltSet<
        ListingVariantPriceTaxCategoryEnum>(const <ListingVariantPriceTaxCategoryEnum>[
  _$listingVariantPriceTaxCategoryEnum_VAT_12,
  _$listingVariantPriceTaxCategoryEnum_VAT_ZERO,
  _$listingVariantPriceTaxCategoryEnum_VAT_EXEMPT,
  _$listingVariantPriceTaxCategoryEnum_NON_VAT,
]);

Serializer<ListingVariantPriceCurrencyEnum>
    _$listingVariantPriceCurrencyEnumSerializer =
    _$ListingVariantPriceCurrencyEnumSerializer();
Serializer<ListingVariantPriceTaxCategoryEnum>
    _$listingVariantPriceTaxCategoryEnumSerializer =
    _$ListingVariantPriceTaxCategoryEnumSerializer();

class _$ListingVariantPriceCurrencyEnumSerializer
    implements PrimitiveSerializer<ListingVariantPriceCurrencyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHP': 'PHP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHP': 'PHP',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingVariantPriceCurrencyEnum];
  @override
  final String wireName = 'ListingVariantPriceCurrencyEnum';

  @override
  Object serialize(
          Serializers serializers, ListingVariantPriceCurrencyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingVariantPriceCurrencyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingVariantPriceCurrencyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingVariantPriceTaxCategoryEnumSerializer
    implements PrimitiveSerializer<ListingVariantPriceTaxCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[ListingVariantPriceTaxCategoryEnum];
  @override
  final String wireName = 'ListingVariantPriceTaxCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, ListingVariantPriceTaxCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingVariantPriceTaxCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingVariantPriceTaxCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingVariantPrice extends ListingVariantPrice {
  @override
  final String priceVersionId;
  @override
  final int unitPriceCentavos;
  @override
  final ListingVariantPriceCurrencyEnum currency;
  @override
  final ListingVariantPriceTaxCategoryEnum taxCategory;
  @override
  final String vatLabel;
  @override
  final int includedVatCentavos;
  @override
  final DateTime effectiveAt;

  factory _$ListingVariantPrice(
          [void Function(ListingVariantPriceBuilder)? updates]) =>
      (ListingVariantPriceBuilder()..update(updates))._build();

  _$ListingVariantPrice._(
      {required this.priceVersionId,
      required this.unitPriceCentavos,
      required this.currency,
      required this.taxCategory,
      required this.vatLabel,
      required this.includedVatCentavos,
      required this.effectiveAt})
      : super._();
  @override
  ListingVariantPrice rebuild(
          void Function(ListingVariantPriceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingVariantPriceBuilder toBuilder() =>
      ListingVariantPriceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingVariantPrice &&
        priceVersionId == other.priceVersionId &&
        unitPriceCentavos == other.unitPriceCentavos &&
        currency == other.currency &&
        taxCategory == other.taxCategory &&
        vatLabel == other.vatLabel &&
        includedVatCentavos == other.includedVatCentavos &&
        effectiveAt == other.effectiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, vatLabel.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingVariantPrice')
          ..add('priceVersionId', priceVersionId)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('currency', currency)
          ..add('taxCategory', taxCategory)
          ..add('vatLabel', vatLabel)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('effectiveAt', effectiveAt))
        .toString();
  }
}

class ListingVariantPriceBuilder
    implements Builder<ListingVariantPrice, ListingVariantPriceBuilder> {
  _$ListingVariantPrice? _$v;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  ListingVariantPriceCurrencyEnum? _currency;
  ListingVariantPriceCurrencyEnum? get currency => _$this._currency;
  set currency(ListingVariantPriceCurrencyEnum? currency) =>
      _$this._currency = currency;

  ListingVariantPriceTaxCategoryEnum? _taxCategory;
  ListingVariantPriceTaxCategoryEnum? get taxCategory => _$this._taxCategory;
  set taxCategory(ListingVariantPriceTaxCategoryEnum? taxCategory) =>
      _$this._taxCategory = taxCategory;

  String? _vatLabel;
  String? get vatLabel => _$this._vatLabel;
  set vatLabel(String? vatLabel) => _$this._vatLabel = vatLabel;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  DateTime? _effectiveAt;
  DateTime? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(DateTime? effectiveAt) => _$this._effectiveAt = effectiveAt;

  ListingVariantPriceBuilder() {
    ListingVariantPrice._defaults(this);
  }

  ListingVariantPriceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _currency = $v.currency;
      _taxCategory = $v.taxCategory;
      _vatLabel = $v.vatLabel;
      _includedVatCentavos = $v.includedVatCentavos;
      _effectiveAt = $v.effectiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingVariantPrice other) {
    _$v = other as _$ListingVariantPrice;
  }

  @override
  void update(void Function(ListingVariantPriceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingVariantPrice build() => _build();

  _$ListingVariantPrice _build() {
    final _$result = _$v ??
        _$ListingVariantPrice._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'ListingVariantPrice', 'priceVersionId'),
          unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
              unitPriceCentavos, r'ListingVariantPrice', 'unitPriceCentavos'),
          currency: BuiltValueNullFieldError.checkNotNull(
              currency, r'ListingVariantPrice', 'currency'),
          taxCategory: BuiltValueNullFieldError.checkNotNull(
              taxCategory, r'ListingVariantPrice', 'taxCategory'),
          vatLabel: BuiltValueNullFieldError.checkNotNull(
              vatLabel, r'ListingVariantPrice', 'vatLabel'),
          includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
              includedVatCentavos,
              r'ListingVariantPrice',
              'includedVatCentavos'),
          effectiveAt: BuiltValueNullFieldError.checkNotNull(
              effectiveAt, r'ListingVariantPrice', 'effectiveAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
