// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_fulfillment_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartFulfillmentUpdateFulfillmentMethodEnum
    _$cartFulfillmentUpdateFulfillmentMethodEnum_DELIVERY =
    const CartFulfillmentUpdateFulfillmentMethodEnum._('DELIVERY');
const CartFulfillmentUpdateFulfillmentMethodEnum
    _$cartFulfillmentUpdateFulfillmentMethodEnum_PICKUP =
    const CartFulfillmentUpdateFulfillmentMethodEnum._('PICKUP');

CartFulfillmentUpdateFulfillmentMethodEnum
    _$cartFulfillmentUpdateFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$cartFulfillmentUpdateFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$cartFulfillmentUpdateFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartFulfillmentUpdateFulfillmentMethodEnum>
    _$cartFulfillmentUpdateFulfillmentMethodEnumValues = BuiltSet<
        CartFulfillmentUpdateFulfillmentMethodEnum>(const <CartFulfillmentUpdateFulfillmentMethodEnum>[
  _$cartFulfillmentUpdateFulfillmentMethodEnum_DELIVERY,
  _$cartFulfillmentUpdateFulfillmentMethodEnum_PICKUP,
]);

Serializer<CartFulfillmentUpdateFulfillmentMethodEnum>
    _$cartFulfillmentUpdateFulfillmentMethodEnumSerializer =
    _$CartFulfillmentUpdateFulfillmentMethodEnumSerializer();

class _$CartFulfillmentUpdateFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<CartFulfillmentUpdateFulfillmentMethodEnum> {
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
    CartFulfillmentUpdateFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'CartFulfillmentUpdateFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          CartFulfillmentUpdateFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartFulfillmentUpdateFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartFulfillmentUpdateFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartFulfillmentUpdate extends CartFulfillmentUpdate {
  @override
  final int lockVersion;
  @override
  final CartFulfillmentUpdateFulfillmentMethodEnum fulfillmentMethod;

  factory _$CartFulfillmentUpdate(
          [void Function(CartFulfillmentUpdateBuilder)? updates]) =>
      (CartFulfillmentUpdateBuilder()..update(updates))._build();

  _$CartFulfillmentUpdate._(
      {required this.lockVersion, required this.fulfillmentMethod})
      : super._();
  @override
  CartFulfillmentUpdate rebuild(
          void Function(CartFulfillmentUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartFulfillmentUpdateBuilder toBuilder() =>
      CartFulfillmentUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartFulfillmentUpdate &&
        lockVersion == other.lockVersion &&
        fulfillmentMethod == other.fulfillmentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartFulfillmentUpdate')
          ..add('lockVersion', lockVersion)
          ..add('fulfillmentMethod', fulfillmentMethod))
        .toString();
  }
}

class CartFulfillmentUpdateBuilder
    implements Builder<CartFulfillmentUpdate, CartFulfillmentUpdateBuilder> {
  _$CartFulfillmentUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  CartFulfillmentUpdateFulfillmentMethodEnum? _fulfillmentMethod;
  CartFulfillmentUpdateFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          CartFulfillmentUpdateFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  CartFulfillmentUpdateBuilder() {
    CartFulfillmentUpdate._defaults(this);
  }

  CartFulfillmentUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartFulfillmentUpdate other) {
    _$v = other as _$CartFulfillmentUpdate;
  }

  @override
  void update(void Function(CartFulfillmentUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartFulfillmentUpdate build() => _build();

  _$CartFulfillmentUpdate _build() {
    final _$result = _$v ??
        _$CartFulfillmentUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'CartFulfillmentUpdate', 'lockVersion'),
          fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
              fulfillmentMethod, r'CartFulfillmentUpdate', 'fulfillmentMethod'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
