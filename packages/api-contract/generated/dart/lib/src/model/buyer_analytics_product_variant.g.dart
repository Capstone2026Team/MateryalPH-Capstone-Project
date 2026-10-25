// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_product_variant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerAnalyticsProductVariantAvailabilityEnum
    _$buyerAnalyticsProductVariantAvailabilityEnum_IN_STOCK =
    const BuyerAnalyticsProductVariantAvailabilityEnum._('IN_STOCK');
const BuyerAnalyticsProductVariantAvailabilityEnum
    _$buyerAnalyticsProductVariantAvailabilityEnum_LIMITED_STOCK =
    const BuyerAnalyticsProductVariantAvailabilityEnum._('LIMITED_STOCK');
const BuyerAnalyticsProductVariantAvailabilityEnum
    _$buyerAnalyticsProductVariantAvailabilityEnum_NO_CURRENT_OFFERS =
    const BuyerAnalyticsProductVariantAvailabilityEnum._('NO_CURRENT_OFFERS');

BuyerAnalyticsProductVariantAvailabilityEnum
    _$buyerAnalyticsProductVariantAvailabilityEnumValueOf(String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$buyerAnalyticsProductVariantAvailabilityEnum_IN_STOCK;
    case 'LIMITED_STOCK':
      return _$buyerAnalyticsProductVariantAvailabilityEnum_LIMITED_STOCK;
    case 'NO_CURRENT_OFFERS':
      return _$buyerAnalyticsProductVariantAvailabilityEnum_NO_CURRENT_OFFERS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerAnalyticsProductVariantAvailabilityEnum>
    _$buyerAnalyticsProductVariantAvailabilityEnumValues = BuiltSet<
        BuyerAnalyticsProductVariantAvailabilityEnum>(const <BuyerAnalyticsProductVariantAvailabilityEnum>[
  _$buyerAnalyticsProductVariantAvailabilityEnum_IN_STOCK,
  _$buyerAnalyticsProductVariantAvailabilityEnum_LIMITED_STOCK,
  _$buyerAnalyticsProductVariantAvailabilityEnum_NO_CURRENT_OFFERS,
]);

Serializer<BuyerAnalyticsProductVariantAvailabilityEnum>
    _$buyerAnalyticsProductVariantAvailabilityEnumSerializer =
    _$BuyerAnalyticsProductVariantAvailabilityEnumSerializer();

class _$BuyerAnalyticsProductVariantAvailabilityEnumSerializer
    implements
        PrimitiveSerializer<BuyerAnalyticsProductVariantAvailabilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'NO_CURRENT_OFFERS': 'NO_CURRENT_OFFERS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'NO_CURRENT_OFFERS': 'NO_CURRENT_OFFERS',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerAnalyticsProductVariantAvailabilityEnum
  ];
  @override
  final String wireName = 'BuyerAnalyticsProductVariantAvailabilityEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerAnalyticsProductVariantAvailabilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerAnalyticsProductVariantAvailabilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerAnalyticsProductVariantAvailabilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerAnalyticsProductVariant extends BuyerAnalyticsProductVariant {
  @override
  final String groupId;
  @override
  final String displayName;
  @override
  final AnalyticsMaterialRef material;
  @override
  final AnalyticsCategoryRef category;
  @override
  final ComparableSpecification specification;
  @override
  final AnalyticsUnit unit;
  @override
  final int vendorCount;
  @override
  final int listingCount;
  @override
  final AnalyticsPriceRange price;
  @override
  final BuyerAnalyticsProductVariantAvailabilityEnum availability;
  @override
  final ListingImage? image;

  factory _$BuyerAnalyticsProductVariant(
          [void Function(BuyerAnalyticsProductVariantBuilder)? updates]) =>
      (BuyerAnalyticsProductVariantBuilder()..update(updates))._build();

  _$BuyerAnalyticsProductVariant._(
      {required this.groupId,
      required this.displayName,
      required this.material,
      required this.category,
      required this.specification,
      required this.unit,
      required this.vendorCount,
      required this.listingCount,
      required this.price,
      required this.availability,
      this.image})
      : super._();
  @override
  BuyerAnalyticsProductVariant rebuild(
          void Function(BuyerAnalyticsProductVariantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAnalyticsProductVariantBuilder toBuilder() =>
      BuyerAnalyticsProductVariantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAnalyticsProductVariant &&
        groupId == other.groupId &&
        displayName == other.displayName &&
        material == other.material &&
        category == other.category &&
        specification == other.specification &&
        unit == other.unit &&
        vendorCount == other.vendorCount &&
        listingCount == other.listingCount &&
        price == other.price &&
        availability == other.availability &&
        image == other.image;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, material.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, specification.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, listingCount.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, availability.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAnalyticsProductVariant')
          ..add('groupId', groupId)
          ..add('displayName', displayName)
          ..add('material', material)
          ..add('category', category)
          ..add('specification', specification)
          ..add('unit', unit)
          ..add('vendorCount', vendorCount)
          ..add('listingCount', listingCount)
          ..add('price', price)
          ..add('availability', availability)
          ..add('image', image))
        .toString();
  }
}

class BuyerAnalyticsProductVariantBuilder
    implements
        Builder<BuyerAnalyticsProductVariant,
            BuyerAnalyticsProductVariantBuilder> {
  _$BuyerAnalyticsProductVariant? _$v;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  AnalyticsMaterialRefBuilder? _material;
  AnalyticsMaterialRefBuilder get material =>
      _$this._material ??= AnalyticsMaterialRefBuilder();
  set material(AnalyticsMaterialRefBuilder? material) =>
      _$this._material = material;

  AnalyticsCategoryRefBuilder? _category;
  AnalyticsCategoryRefBuilder get category =>
      _$this._category ??= AnalyticsCategoryRefBuilder();
  set category(AnalyticsCategoryRefBuilder? category) =>
      _$this._category = category;

  ComparableSpecificationBuilder? _specification;
  ComparableSpecificationBuilder get specification =>
      _$this._specification ??= ComparableSpecificationBuilder();
  set specification(ComparableSpecificationBuilder? specification) =>
      _$this._specification = specification;

  AnalyticsUnitBuilder? _unit;
  AnalyticsUnitBuilder get unit => _$this._unit ??= AnalyticsUnitBuilder();
  set unit(AnalyticsUnitBuilder? unit) => _$this._unit = unit;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  int? _listingCount;
  int? get listingCount => _$this._listingCount;
  set listingCount(int? listingCount) => _$this._listingCount = listingCount;

  AnalyticsPriceRangeBuilder? _price;
  AnalyticsPriceRangeBuilder get price =>
      _$this._price ??= AnalyticsPriceRangeBuilder();
  set price(AnalyticsPriceRangeBuilder? price) => _$this._price = price;

  BuyerAnalyticsProductVariantAvailabilityEnum? _availability;
  BuyerAnalyticsProductVariantAvailabilityEnum? get availability =>
      _$this._availability;
  set availability(
          BuyerAnalyticsProductVariantAvailabilityEnum? availability) =>
      _$this._availability = availability;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  BuyerAnalyticsProductVariantBuilder() {
    BuyerAnalyticsProductVariant._defaults(this);
  }

  BuyerAnalyticsProductVariantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupId = $v.groupId;
      _displayName = $v.displayName;
      _material = $v.material.toBuilder();
      _category = $v.category.toBuilder();
      _specification = $v.specification.toBuilder();
      _unit = $v.unit.toBuilder();
      _vendorCount = $v.vendorCount;
      _listingCount = $v.listingCount;
      _price = $v.price.toBuilder();
      _availability = $v.availability;
      _image = $v.image?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAnalyticsProductVariant other) {
    _$v = other as _$BuyerAnalyticsProductVariant;
  }

  @override
  void update(void Function(BuyerAnalyticsProductVariantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAnalyticsProductVariant build() => _build();

  _$BuyerAnalyticsProductVariant _build() {
    _$BuyerAnalyticsProductVariant _$result;
    try {
      _$result = _$v ??
          _$BuyerAnalyticsProductVariant._(
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'BuyerAnalyticsProductVariant', 'groupId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'BuyerAnalyticsProductVariant', 'displayName'),
            material: material.build(),
            category: category.build(),
            specification: specification.build(),
            unit: unit.build(),
            vendorCount: BuiltValueNullFieldError.checkNotNull(
                vendorCount, r'BuyerAnalyticsProductVariant', 'vendorCount'),
            listingCount: BuiltValueNullFieldError.checkNotNull(
                listingCount, r'BuyerAnalyticsProductVariant', 'listingCount'),
            price: price.build(),
            availability: BuiltValueNullFieldError.checkNotNull(
                availability, r'BuyerAnalyticsProductVariant', 'availability'),
            image: _image?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'material';
        material.build();
        _$failedField = 'category';
        category.build();
        _$failedField = 'specification';
        specification.build();
        _$failedField = 'unit';
        unit.build();

        _$failedField = 'price';
        price.build();

        _$failedField = 'image';
        _image?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerAnalyticsProductVariant', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
