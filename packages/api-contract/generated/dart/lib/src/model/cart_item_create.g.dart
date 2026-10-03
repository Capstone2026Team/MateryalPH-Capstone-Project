// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartItemCreateFulfillmentMethodEnum
    _$cartItemCreateFulfillmentMethodEnum_DELIVERY =
    const CartItemCreateFulfillmentMethodEnum._('DELIVERY');
const CartItemCreateFulfillmentMethodEnum
    _$cartItemCreateFulfillmentMethodEnum_PICKUP =
    const CartItemCreateFulfillmentMethodEnum._('PICKUP');

CartItemCreateFulfillmentMethodEnum
    _$cartItemCreateFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$cartItemCreateFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$cartItemCreateFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartItemCreateFulfillmentMethodEnum>
    _$cartItemCreateFulfillmentMethodEnumValues = BuiltSet<
        CartItemCreateFulfillmentMethodEnum>(const <CartItemCreateFulfillmentMethodEnum>[
  _$cartItemCreateFulfillmentMethodEnum_DELIVERY,
  _$cartItemCreateFulfillmentMethodEnum_PICKUP,
]);

const CartItemCreateOriginSourceEnum _$cartItemCreateOriginSourceEnum_DEVICE =
    const CartItemCreateOriginSourceEnum._('DEVICE');
const CartItemCreateOriginSourceEnum _$cartItemCreateOriginSourceEnum_MAP_PIN =
    const CartItemCreateOriginSourceEnum._('MAP_PIN');
const CartItemCreateOriginSourceEnum _$cartItemCreateOriginSourceEnum_SEARCH =
    const CartItemCreateOriginSourceEnum._('SEARCH');

CartItemCreateOriginSourceEnum _$cartItemCreateOriginSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'DEVICE':
      return _$cartItemCreateOriginSourceEnum_DEVICE;
    case 'MAP_PIN':
      return _$cartItemCreateOriginSourceEnum_MAP_PIN;
    case 'SEARCH':
      return _$cartItemCreateOriginSourceEnum_SEARCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartItemCreateOriginSourceEnum>
    _$cartItemCreateOriginSourceEnumValues = BuiltSet<
        CartItemCreateOriginSourceEnum>(const <CartItemCreateOriginSourceEnum>[
  _$cartItemCreateOriginSourceEnum_DEVICE,
  _$cartItemCreateOriginSourceEnum_MAP_PIN,
  _$cartItemCreateOriginSourceEnum_SEARCH,
]);

Serializer<CartItemCreateFulfillmentMethodEnum>
    _$cartItemCreateFulfillmentMethodEnumSerializer =
    _$CartItemCreateFulfillmentMethodEnumSerializer();
Serializer<CartItemCreateOriginSourceEnum>
    _$cartItemCreateOriginSourceEnumSerializer =
    _$CartItemCreateOriginSourceEnumSerializer();

class _$CartItemCreateFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<CartItemCreateFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CartItemCreateFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'CartItemCreateFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, CartItemCreateFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartItemCreateFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartItemCreateFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartItemCreateOriginSourceEnumSerializer
    implements PrimitiveSerializer<CartItemCreateOriginSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'SEARCH': 'SEARCH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'SEARCH': 'SEARCH',
  };

  @override
  final Iterable<Type> types = const <Type>[CartItemCreateOriginSourceEnum];
  @override
  final String wireName = 'CartItemCreateOriginSourceEnum';

  @override
  Object serialize(
          Serializers serializers, CartItemCreateOriginSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartItemCreateOriginSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartItemCreateOriginSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartItemCreate extends CartItemCreate {
  @override
  final String listingVariantId;
  @override
  final String expectedPriceVersionId;
  @override
  final String quantity;
  @override
  final CartItemCreateFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final String? locationId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final CartItemCreateOriginSourceEnum? originSource;
  @override
  final int? radiusKm;

  factory _$CartItemCreate([void Function(CartItemCreateBuilder)? updates]) =>
      (CartItemCreateBuilder()..update(updates))._build();

  _$CartItemCreate._(
      {required this.listingVariantId,
      required this.expectedPriceVersionId,
      required this.quantity,
      this.fulfillmentMethod,
      this.locationId,
      this.latitude,
      this.longitude,
      this.originSource,
      this.radiusKm})
      : super._();
  @override
  CartItemCreate rebuild(void Function(CartItemCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartItemCreateBuilder toBuilder() => CartItemCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartItemCreate &&
        listingVariantId == other.listingVariantId &&
        expectedPriceVersionId == other.expectedPriceVersionId &&
        quantity == other.quantity &&
        fulfillmentMethod == other.fulfillmentMethod &&
        locationId == other.locationId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        originSource == other.originSource &&
        radiusKm == other.radiusKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, expectedPriceVersionId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, originSource.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartItemCreate')
          ..add('listingVariantId', listingVariantId)
          ..add('expectedPriceVersionId', expectedPriceVersionId)
          ..add('quantity', quantity)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('locationId', locationId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('originSource', originSource)
          ..add('radiusKm', radiusKm))
        .toString();
  }
}

class CartItemCreateBuilder
    implements Builder<CartItemCreate, CartItemCreateBuilder> {
  _$CartItemCreate? _$v;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _expectedPriceVersionId;
  String? get expectedPriceVersionId => _$this._expectedPriceVersionId;
  set expectedPriceVersionId(String? expectedPriceVersionId) =>
      _$this._expectedPriceVersionId = expectedPriceVersionId;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  CartItemCreateFulfillmentMethodEnum? _fulfillmentMethod;
  CartItemCreateFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          CartItemCreateFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  CartItemCreateOriginSourceEnum? _originSource;
  CartItemCreateOriginSourceEnum? get originSource => _$this._originSource;
  set originSource(CartItemCreateOriginSourceEnum? originSource) =>
      _$this._originSource = originSource;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  CartItemCreateBuilder() {
    CartItemCreate._defaults(this);
  }

  CartItemCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingVariantId = $v.listingVariantId;
      _expectedPriceVersionId = $v.expectedPriceVersionId;
      _quantity = $v.quantity;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _locationId = $v.locationId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _originSource = $v.originSource;
      _radiusKm = $v.radiusKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartItemCreate other) {
    _$v = other as _$CartItemCreate;
  }

  @override
  void update(void Function(CartItemCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartItemCreate build() => _build();

  _$CartItemCreate _build() {
    final _$result = _$v ??
        _$CartItemCreate._(
          listingVariantId: BuiltValueNullFieldError.checkNotNull(
              listingVariantId, r'CartItemCreate', 'listingVariantId'),
          expectedPriceVersionId: BuiltValueNullFieldError.checkNotNull(
              expectedPriceVersionId,
              r'CartItemCreate',
              'expectedPriceVersionId'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'CartItemCreate', 'quantity'),
          fulfillmentMethod: fulfillmentMethod,
          locationId: locationId,
          latitude: latitude,
          longitude: longitude,
          originSource: originSource,
          radiusKm: radiusKm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
