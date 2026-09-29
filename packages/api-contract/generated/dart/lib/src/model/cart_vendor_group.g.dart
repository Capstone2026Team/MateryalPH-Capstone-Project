// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_vendor_group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartVendorGroupFulfillmentMethodEnum
    _$cartVendorGroupFulfillmentMethodEnum_DELIVERY =
    const CartVendorGroupFulfillmentMethodEnum._('DELIVERY');
const CartVendorGroupFulfillmentMethodEnum
    _$cartVendorGroupFulfillmentMethodEnum_PICKUP =
    const CartVendorGroupFulfillmentMethodEnum._('PICKUP');

CartVendorGroupFulfillmentMethodEnum
    _$cartVendorGroupFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$cartVendorGroupFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$cartVendorGroupFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartVendorGroupFulfillmentMethodEnum>
    _$cartVendorGroupFulfillmentMethodEnumValues = BuiltSet<
        CartVendorGroupFulfillmentMethodEnum>(const <CartVendorGroupFulfillmentMethodEnum>[
  _$cartVendorGroupFulfillmentMethodEnum_DELIVERY,
  _$cartVendorGroupFulfillmentMethodEnum_PICKUP,
]);

const CartVendorGroupFulfillmentOptionsEnum
    _$cartVendorGroupFulfillmentOptionsEnum_DELIVERY =
    const CartVendorGroupFulfillmentOptionsEnum._('DELIVERY');
const CartVendorGroupFulfillmentOptionsEnum
    _$cartVendorGroupFulfillmentOptionsEnum_PICKUP =
    const CartVendorGroupFulfillmentOptionsEnum._('PICKUP');

CartVendorGroupFulfillmentOptionsEnum
    _$cartVendorGroupFulfillmentOptionsEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$cartVendorGroupFulfillmentOptionsEnum_DELIVERY;
    case 'PICKUP':
      return _$cartVendorGroupFulfillmentOptionsEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartVendorGroupFulfillmentOptionsEnum>
    _$cartVendorGroupFulfillmentOptionsEnumValues = BuiltSet<
        CartVendorGroupFulfillmentOptionsEnum>(const <CartVendorGroupFulfillmentOptionsEnum>[
  _$cartVendorGroupFulfillmentOptionsEnum_DELIVERY,
  _$cartVendorGroupFulfillmentOptionsEnum_PICKUP,
]);

const CartVendorGroupStatusEnum _$cartVendorGroupStatusEnum_READY =
    const CartVendorGroupStatusEnum._('READY');
const CartVendorGroupStatusEnum _$cartVendorGroupStatusEnum_ACTION_REQUIRED =
    const CartVendorGroupStatusEnum._('ACTION_REQUIRED');
const CartVendorGroupStatusEnum _$cartVendorGroupStatusEnum_BLOCKED =
    const CartVendorGroupStatusEnum._('BLOCKED');

CartVendorGroupStatusEnum _$cartVendorGroupStatusEnumValueOf(String name) {
  switch (name) {
    case 'READY':
      return _$cartVendorGroupStatusEnum_READY;
    case 'ACTION_REQUIRED':
      return _$cartVendorGroupStatusEnum_ACTION_REQUIRED;
    case 'BLOCKED':
      return _$cartVendorGroupStatusEnum_BLOCKED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartVendorGroupStatusEnum> _$cartVendorGroupStatusEnumValues =
    BuiltSet<CartVendorGroupStatusEnum>(const <CartVendorGroupStatusEnum>[
  _$cartVendorGroupStatusEnum_READY,
  _$cartVendorGroupStatusEnum_ACTION_REQUIRED,
  _$cartVendorGroupStatusEnum_BLOCKED,
]);

Serializer<CartVendorGroupFulfillmentMethodEnum>
    _$cartVendorGroupFulfillmentMethodEnumSerializer =
    _$CartVendorGroupFulfillmentMethodEnumSerializer();
Serializer<CartVendorGroupFulfillmentOptionsEnum>
    _$cartVendorGroupFulfillmentOptionsEnumSerializer =
    _$CartVendorGroupFulfillmentOptionsEnumSerializer();
Serializer<CartVendorGroupStatusEnum> _$cartVendorGroupStatusEnumSerializer =
    _$CartVendorGroupStatusEnumSerializer();

class _$CartVendorGroupFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<CartVendorGroupFulfillmentMethodEnum> {
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
    CartVendorGroupFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'CartVendorGroupFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, CartVendorGroupFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartVendorGroupFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartVendorGroupFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartVendorGroupFulfillmentOptionsEnumSerializer
    implements PrimitiveSerializer<CartVendorGroupFulfillmentOptionsEnum> {
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
    CartVendorGroupFulfillmentOptionsEnum
  ];
  @override
  final String wireName = 'CartVendorGroupFulfillmentOptionsEnum';

  @override
  Object serialize(
          Serializers serializers, CartVendorGroupFulfillmentOptionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartVendorGroupFulfillmentOptionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartVendorGroupFulfillmentOptionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartVendorGroupStatusEnumSerializer
    implements PrimitiveSerializer<CartVendorGroupStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'READY': 'READY',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'READY': 'READY',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
  };

  @override
  final Iterable<Type> types = const <Type>[CartVendorGroupStatusEnum];
  @override
  final String wireName = 'CartVendorGroupStatusEnum';

  @override
  Object serialize(Serializers serializers, CartVendorGroupStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartVendorGroupStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartVendorGroupStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartVendorGroup extends CartVendorGroup {
  @override
  final CartVendorRef vendor;
  @override
  final CartVendorGroupFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final BuiltList<CartVendorGroupFulfillmentOptionsEnum> fulfillmentOptions;
  @override
  final BuiltList<CartLine> lines;
  @override
  final int materialsSubtotalCentavos;
  @override
  final CartVendorGroupStatusEnum status;

  factory _$CartVendorGroup([void Function(CartVendorGroupBuilder)? updates]) =>
      (CartVendorGroupBuilder()..update(updates))._build();

  _$CartVendorGroup._(
      {required this.vendor,
      this.fulfillmentMethod,
      required this.fulfillmentOptions,
      required this.lines,
      required this.materialsSubtotalCentavos,
      required this.status})
      : super._();
  @override
  CartVendorGroup rebuild(void Function(CartVendorGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartVendorGroupBuilder toBuilder() => CartVendorGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartVendorGroup &&
        vendor == other.vendor &&
        fulfillmentMethod == other.fulfillmentMethod &&
        fulfillmentOptions == other.fulfillmentOptions &&
        lines == other.lines &&
        materialsSubtotalCentavos == other.materialsSubtotalCentavos &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, fulfillmentOptions.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, materialsSubtotalCentavos.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartVendorGroup')
          ..add('vendor', vendor)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('fulfillmentOptions', fulfillmentOptions)
          ..add('lines', lines)
          ..add('materialsSubtotalCentavos', materialsSubtotalCentavos)
          ..add('status', status))
        .toString();
  }
}

class CartVendorGroupBuilder
    implements Builder<CartVendorGroup, CartVendorGroupBuilder> {
  _$CartVendorGroup? _$v;

  CartVendorRefBuilder? _vendor;
  CartVendorRefBuilder get vendor => _$this._vendor ??= CartVendorRefBuilder();
  set vendor(CartVendorRefBuilder? vendor) => _$this._vendor = vendor;

  CartVendorGroupFulfillmentMethodEnum? _fulfillmentMethod;
  CartVendorGroupFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          CartVendorGroupFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ListBuilder<CartVendorGroupFulfillmentOptionsEnum>? _fulfillmentOptions;
  ListBuilder<CartVendorGroupFulfillmentOptionsEnum> get fulfillmentOptions =>
      _$this._fulfillmentOptions ??=
          ListBuilder<CartVendorGroupFulfillmentOptionsEnum>();
  set fulfillmentOptions(
          ListBuilder<CartVendorGroupFulfillmentOptionsEnum>?
              fulfillmentOptions) =>
      _$this._fulfillmentOptions = fulfillmentOptions;

  ListBuilder<CartLine>? _lines;
  ListBuilder<CartLine> get lines => _$this._lines ??= ListBuilder<CartLine>();
  set lines(ListBuilder<CartLine>? lines) => _$this._lines = lines;

  int? _materialsSubtotalCentavos;
  int? get materialsSubtotalCentavos => _$this._materialsSubtotalCentavos;
  set materialsSubtotalCentavos(int? materialsSubtotalCentavos) =>
      _$this._materialsSubtotalCentavos = materialsSubtotalCentavos;

  CartVendorGroupStatusEnum? _status;
  CartVendorGroupStatusEnum? get status => _$this._status;
  set status(CartVendorGroupStatusEnum? status) => _$this._status = status;

  CartVendorGroupBuilder() {
    CartVendorGroup._defaults(this);
  }

  CartVendorGroupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendor = $v.vendor.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _fulfillmentOptions = $v.fulfillmentOptions.toBuilder();
      _lines = $v.lines.toBuilder();
      _materialsSubtotalCentavos = $v.materialsSubtotalCentavos;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartVendorGroup other) {
    _$v = other as _$CartVendorGroup;
  }

  @override
  void update(void Function(CartVendorGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartVendorGroup build() => _build();

  _$CartVendorGroup _build() {
    _$CartVendorGroup _$result;
    try {
      _$result = _$v ??
          _$CartVendorGroup._(
            vendor: vendor.build(),
            fulfillmentMethod: fulfillmentMethod,
            fulfillmentOptions: fulfillmentOptions.build(),
            lines: lines.build(),
            materialsSubtotalCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsSubtotalCentavos,
                r'CartVendorGroup',
                'materialsSubtotalCentavos'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CartVendorGroup', 'status'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        vendor.build();

        _$failedField = 'fulfillmentOptions';
        fulfillmentOptions.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CartVendorGroup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
