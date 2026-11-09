// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartItemUpdateFulfillmentMethodEnum
    _$cartItemUpdateFulfillmentMethodEnum_DELIVERY =
    const CartItemUpdateFulfillmentMethodEnum._('DELIVERY');
const CartItemUpdateFulfillmentMethodEnum
    _$cartItemUpdateFulfillmentMethodEnum_PICKUP =
    const CartItemUpdateFulfillmentMethodEnum._('PICKUP');

CartItemUpdateFulfillmentMethodEnum
    _$cartItemUpdateFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$cartItemUpdateFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$cartItemUpdateFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartItemUpdateFulfillmentMethodEnum>
    _$cartItemUpdateFulfillmentMethodEnumValues = BuiltSet<
        CartItemUpdateFulfillmentMethodEnum>(const <CartItemUpdateFulfillmentMethodEnum>[
  _$cartItemUpdateFulfillmentMethodEnum_DELIVERY,
  _$cartItemUpdateFulfillmentMethodEnum_PICKUP,
]);

Serializer<CartItemUpdateFulfillmentMethodEnum>
    _$cartItemUpdateFulfillmentMethodEnumSerializer =
    _$CartItemUpdateFulfillmentMethodEnumSerializer();

class _$CartItemUpdateFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<CartItemUpdateFulfillmentMethodEnum> {
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
    CartItemUpdateFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'CartItemUpdateFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, CartItemUpdateFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartItemUpdateFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartItemUpdateFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartItemUpdate extends CartItemUpdate {
  @override
  final int lockVersion;
  @override
  final String? quantity;
  @override
  final bool? savedForLater;
  @override
  final bool? acceptCurrentPrice;
  @override
  final String? listingVariantId;
  @override
  final String? expectedPriceVersionId;
  @override
  final CartItemUpdateFulfillmentMethodEnum? fulfillmentMethod;

  factory _$CartItemUpdate([void Function(CartItemUpdateBuilder)? updates]) =>
      (CartItemUpdateBuilder()..update(updates))._build();

  _$CartItemUpdate._(
      {required this.lockVersion,
      this.quantity,
      this.savedForLater,
      this.acceptCurrentPrice,
      this.listingVariantId,
      this.expectedPriceVersionId,
      this.fulfillmentMethod})
      : super._();
  @override
  CartItemUpdate rebuild(void Function(CartItemUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartItemUpdateBuilder toBuilder() => CartItemUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartItemUpdate &&
        lockVersion == other.lockVersion &&
        quantity == other.quantity &&
        savedForLater == other.savedForLater &&
        acceptCurrentPrice == other.acceptCurrentPrice &&
        listingVariantId == other.listingVariantId &&
        expectedPriceVersionId == other.expectedPriceVersionId &&
        fulfillmentMethod == other.fulfillmentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, savedForLater.hashCode);
    _$hash = $jc(_$hash, acceptCurrentPrice.hashCode);
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, expectedPriceVersionId.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartItemUpdate')
          ..add('lockVersion', lockVersion)
          ..add('quantity', quantity)
          ..add('savedForLater', savedForLater)
          ..add('acceptCurrentPrice', acceptCurrentPrice)
          ..add('listingVariantId', listingVariantId)
          ..add('expectedPriceVersionId', expectedPriceVersionId)
          ..add('fulfillmentMethod', fulfillmentMethod))
        .toString();
  }
}

class CartItemUpdateBuilder
    implements Builder<CartItemUpdate, CartItemUpdateBuilder> {
  _$CartItemUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  bool? _savedForLater;
  bool? get savedForLater => _$this._savedForLater;
  set savedForLater(bool? savedForLater) =>
      _$this._savedForLater = savedForLater;

  bool? _acceptCurrentPrice;
  bool? get acceptCurrentPrice => _$this._acceptCurrentPrice;
  set acceptCurrentPrice(bool? acceptCurrentPrice) =>
      _$this._acceptCurrentPrice = acceptCurrentPrice;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _expectedPriceVersionId;
  String? get expectedPriceVersionId => _$this._expectedPriceVersionId;
  set expectedPriceVersionId(String? expectedPriceVersionId) =>
      _$this._expectedPriceVersionId = expectedPriceVersionId;

  CartItemUpdateFulfillmentMethodEnum? _fulfillmentMethod;
  CartItemUpdateFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          CartItemUpdateFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  CartItemUpdateBuilder() {
    CartItemUpdate._defaults(this);
  }

  CartItemUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _quantity = $v.quantity;
      _savedForLater = $v.savedForLater;
      _acceptCurrentPrice = $v.acceptCurrentPrice;
      _listingVariantId = $v.listingVariantId;
      _expectedPriceVersionId = $v.expectedPriceVersionId;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartItemUpdate other) {
    _$v = other as _$CartItemUpdate;
  }

  @override
  void update(void Function(CartItemUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartItemUpdate build() => _build();

  _$CartItemUpdate _build() {
    final _$result = _$v ??
        _$CartItemUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'CartItemUpdate', 'lockVersion'),
          quantity: quantity,
          savedForLater: savedForLater,
          acceptCurrentPrice: acceptCurrentPrice,
          listingVariantId: listingVariantId,
          expectedPriceVersionId: expectedPriceVersionId,
          fulfillmentMethod: fulfillmentMethod,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
