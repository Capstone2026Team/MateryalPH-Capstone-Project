// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_variant_offer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingVariantOfferStockLabelEnum
    _$listingVariantOfferStockLabelEnum_IN_STOCK =
    const ListingVariantOfferStockLabelEnum._('IN_STOCK');
const ListingVariantOfferStockLabelEnum
    _$listingVariantOfferStockLabelEnum_LIMITED_STOCK =
    const ListingVariantOfferStockLabelEnum._('LIMITED_STOCK');

ListingVariantOfferStockLabelEnum _$listingVariantOfferStockLabelEnumValueOf(
    String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$listingVariantOfferStockLabelEnum_IN_STOCK;
    case 'LIMITED_STOCK':
      return _$listingVariantOfferStockLabelEnum_LIMITED_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingVariantOfferStockLabelEnum>
    _$listingVariantOfferStockLabelEnumValues = BuiltSet<
        ListingVariantOfferStockLabelEnum>(const <ListingVariantOfferStockLabelEnum>[
  _$listingVariantOfferStockLabelEnum_IN_STOCK,
  _$listingVariantOfferStockLabelEnum_LIMITED_STOCK,
]);

Serializer<ListingVariantOfferStockLabelEnum>
    _$listingVariantOfferStockLabelEnumSerializer =
    _$ListingVariantOfferStockLabelEnumSerializer();

class _$ListingVariantOfferStockLabelEnumSerializer
    implements PrimitiveSerializer<ListingVariantOfferStockLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingVariantOfferStockLabelEnum];
  @override
  final String wireName = 'ListingVariantOfferStockLabelEnum';

  @override
  Object serialize(
          Serializers serializers, ListingVariantOfferStockLabelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingVariantOfferStockLabelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingVariantOfferStockLabelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingVariantOffer extends ListingVariantOffer {
  @override
  final String variantId;
  @override
  final String sku;
  @override
  final String? label;
  @override
  final BuiltMap<String, JsonObject?> attributes;
  @override
  final String unitCode;
  @override
  final String unitName;
  @override
  final String packQuantity;
  @override
  final String quantityStep;
  @override
  final bool available;
  @override
  final String? availabilityNote;
  @override
  final ListingVariantOfferStockLabelEnum? stockLabel;
  @override
  final DateTime? stockConfirmedAt;
  @override
  final ListingVariantPrice? price;
  @override
  final BuiltList<VolumeTier> volumeTiers;
  @override
  final bool bestPrice;
  @override
  final ComparableStatus? comparable;

  factory _$ListingVariantOffer(
          [void Function(ListingVariantOfferBuilder)? updates]) =>
      (ListingVariantOfferBuilder()..update(updates))._build();

  _$ListingVariantOffer._(
      {required this.variantId,
      required this.sku,
      this.label,
      required this.attributes,
      required this.unitCode,
      required this.unitName,
      required this.packQuantity,
      required this.quantityStep,
      required this.available,
      this.availabilityNote,
      this.stockLabel,
      this.stockConfirmedAt,
      this.price,
      required this.volumeTiers,
      required this.bestPrice,
      this.comparable})
      : super._();
  @override
  ListingVariantOffer rebuild(
          void Function(ListingVariantOfferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingVariantOfferBuilder toBuilder() =>
      ListingVariantOfferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingVariantOffer &&
        variantId == other.variantId &&
        sku == other.sku &&
        label == other.label &&
        attributes == other.attributes &&
        unitCode == other.unitCode &&
        unitName == other.unitName &&
        packQuantity == other.packQuantity &&
        quantityStep == other.quantityStep &&
        available == other.available &&
        availabilityNote == other.availabilityNote &&
        stockLabel == other.stockLabel &&
        stockConfirmedAt == other.stockConfirmedAt &&
        price == other.price &&
        volumeTiers == other.volumeTiers &&
        bestPrice == other.bestPrice &&
        comparable == other.comparable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, unitName.hashCode);
    _$hash = $jc(_$hash, packQuantity.hashCode);
    _$hash = $jc(_$hash, quantityStep.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, availabilityNote.hashCode);
    _$hash = $jc(_$hash, stockLabel.hashCode);
    _$hash = $jc(_$hash, stockConfirmedAt.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, volumeTiers.hashCode);
    _$hash = $jc(_$hash, bestPrice.hashCode);
    _$hash = $jc(_$hash, comparable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingVariantOffer')
          ..add('variantId', variantId)
          ..add('sku', sku)
          ..add('label', label)
          ..add('attributes', attributes)
          ..add('unitCode', unitCode)
          ..add('unitName', unitName)
          ..add('packQuantity', packQuantity)
          ..add('quantityStep', quantityStep)
          ..add('available', available)
          ..add('availabilityNote', availabilityNote)
          ..add('stockLabel', stockLabel)
          ..add('stockConfirmedAt', stockConfirmedAt)
          ..add('price', price)
          ..add('volumeTiers', volumeTiers)
          ..add('bestPrice', bestPrice)
          ..add('comparable', comparable))
        .toString();
  }
}

class ListingVariantOfferBuilder
    implements Builder<ListingVariantOffer, ListingVariantOfferBuilder> {
  _$ListingVariantOffer? _$v;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  MapBuilder<String, JsonObject?>? _attributes;
  MapBuilder<String, JsonObject?> get attributes =>
      _$this._attributes ??= MapBuilder<String, JsonObject?>();
  set attributes(MapBuilder<String, JsonObject?>? attributes) =>
      _$this._attributes = attributes;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _unitName;
  String? get unitName => _$this._unitName;
  set unitName(String? unitName) => _$this._unitName = unitName;

  String? _packQuantity;
  String? get packQuantity => _$this._packQuantity;
  set packQuantity(String? packQuantity) => _$this._packQuantity = packQuantity;

  String? _quantityStep;
  String? get quantityStep => _$this._quantityStep;
  set quantityStep(String? quantityStep) => _$this._quantityStep = quantityStep;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _availabilityNote;
  String? get availabilityNote => _$this._availabilityNote;
  set availabilityNote(String? availabilityNote) =>
      _$this._availabilityNote = availabilityNote;

  ListingVariantOfferStockLabelEnum? _stockLabel;
  ListingVariantOfferStockLabelEnum? get stockLabel => _$this._stockLabel;
  set stockLabel(ListingVariantOfferStockLabelEnum? stockLabel) =>
      _$this._stockLabel = stockLabel;

  DateTime? _stockConfirmedAt;
  DateTime? get stockConfirmedAt => _$this._stockConfirmedAt;
  set stockConfirmedAt(DateTime? stockConfirmedAt) =>
      _$this._stockConfirmedAt = stockConfirmedAt;

  ListingVariantPriceBuilder? _price;
  ListingVariantPriceBuilder get price =>
      _$this._price ??= ListingVariantPriceBuilder();
  set price(ListingVariantPriceBuilder? price) => _$this._price = price;

  ListBuilder<VolumeTier>? _volumeTiers;
  ListBuilder<VolumeTier> get volumeTiers =>
      _$this._volumeTiers ??= ListBuilder<VolumeTier>();
  set volumeTiers(ListBuilder<VolumeTier>? volumeTiers) =>
      _$this._volumeTiers = volumeTiers;

  bool? _bestPrice;
  bool? get bestPrice => _$this._bestPrice;
  set bestPrice(bool? bestPrice) => _$this._bestPrice = bestPrice;

  ComparableStatusBuilder? _comparable;
  ComparableStatusBuilder get comparable =>
      _$this._comparable ??= ComparableStatusBuilder();
  set comparable(ComparableStatusBuilder? comparable) =>
      _$this._comparable = comparable;

  ListingVariantOfferBuilder() {
    ListingVariantOffer._defaults(this);
  }

  ListingVariantOfferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _variantId = $v.variantId;
      _sku = $v.sku;
      _label = $v.label;
      _attributes = $v.attributes.toBuilder();
      _unitCode = $v.unitCode;
      _unitName = $v.unitName;
      _packQuantity = $v.packQuantity;
      _quantityStep = $v.quantityStep;
      _available = $v.available;
      _availabilityNote = $v.availabilityNote;
      _stockLabel = $v.stockLabel;
      _stockConfirmedAt = $v.stockConfirmedAt;
      _price = $v.price?.toBuilder();
      _volumeTiers = $v.volumeTiers.toBuilder();
      _bestPrice = $v.bestPrice;
      _comparable = $v.comparable?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingVariantOffer other) {
    _$v = other as _$ListingVariantOffer;
  }

  @override
  void update(void Function(ListingVariantOfferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingVariantOffer build() => _build();

  _$ListingVariantOffer _build() {
    _$ListingVariantOffer _$result;
    try {
      _$result = _$v ??
          _$ListingVariantOffer._(
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'ListingVariantOffer', 'variantId'),
            sku: BuiltValueNullFieldError.checkNotNull(
                sku, r'ListingVariantOffer', 'sku'),
            label: label,
            attributes: attributes.build(),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'ListingVariantOffer', 'unitCode'),
            unitName: BuiltValueNullFieldError.checkNotNull(
                unitName, r'ListingVariantOffer', 'unitName'),
            packQuantity: BuiltValueNullFieldError.checkNotNull(
                packQuantity, r'ListingVariantOffer', 'packQuantity'),
            quantityStep: BuiltValueNullFieldError.checkNotNull(
                quantityStep, r'ListingVariantOffer', 'quantityStep'),
            available: BuiltValueNullFieldError.checkNotNull(
                available, r'ListingVariantOffer', 'available'),
            availabilityNote: availabilityNote,
            stockLabel: stockLabel,
            stockConfirmedAt: stockConfirmedAt,
            price: _price?.build(),
            volumeTiers: volumeTiers.build(),
            bestPrice: BuiltValueNullFieldError.checkNotNull(
                bestPrice, r'ListingVariantOffer', 'bestPrice'),
            comparable: _comparable?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attributes';
        attributes.build();

        _$failedField = 'price';
        _price?.build();
        _$failedField = 'volumeTiers';
        volumeTiers.build();

        _$failedField = 'comparable';
        _comparable?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingVariantOffer', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
