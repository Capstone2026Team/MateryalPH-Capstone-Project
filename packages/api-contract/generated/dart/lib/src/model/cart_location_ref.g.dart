// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_location_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartLocationRefStatusEnum _$cartLocationRefStatusEnum_ACTIVE =
    const CartLocationRefStatusEnum._('ACTIVE');
const CartLocationRefStatusEnum _$cartLocationRefStatusEnum_UNAVAILABLE =
    const CartLocationRefStatusEnum._('UNAVAILABLE');

CartLocationRefStatusEnum _$cartLocationRefStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$cartLocationRefStatusEnum_ACTIVE;
    case 'UNAVAILABLE':
      return _$cartLocationRefStatusEnum_UNAVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartLocationRefStatusEnum> _$cartLocationRefStatusEnumValues =
    BuiltSet<CartLocationRefStatusEnum>(const <CartLocationRefStatusEnum>[
  _$cartLocationRefStatusEnum_ACTIVE,
  _$cartLocationRefStatusEnum_UNAVAILABLE,
]);

Serializer<CartLocationRefStatusEnum> _$cartLocationRefStatusEnumSerializer =
    _$CartLocationRefStatusEnumSerializer();

class _$CartLocationRefStatusEnumSerializer
    implements PrimitiveSerializer<CartLocationRefStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'UNAVAILABLE': 'UNAVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'UNAVAILABLE': 'UNAVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[CartLocationRefStatusEnum];
  @override
  final String wireName = 'CartLocationRefStatusEnum';

  @override
  Object serialize(Serializers serializers, CartLocationRefStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartLocationRefStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartLocationRefStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartLocationRef extends CartLocationRef {
  @override
  final String locationId;
  @override
  final String? label;
  @override
  final String kind;
  @override
  final String? formattedAddress;
  @override
  final CartLocationRefStatusEnum status;

  factory _$CartLocationRef([void Function(CartLocationRefBuilder)? updates]) =>
      (CartLocationRefBuilder()..update(updates))._build();

  _$CartLocationRef._(
      {required this.locationId,
      this.label,
      required this.kind,
      this.formattedAddress,
      required this.status})
      : super._();
  @override
  CartLocationRef rebuild(void Function(CartLocationRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartLocationRefBuilder toBuilder() => CartLocationRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartLocationRef &&
        locationId == other.locationId &&
        label == other.label &&
        kind == other.kind &&
        formattedAddress == other.formattedAddress &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartLocationRef')
          ..add('locationId', locationId)
          ..add('label', label)
          ..add('kind', kind)
          ..add('formattedAddress', formattedAddress)
          ..add('status', status))
        .toString();
  }
}

class CartLocationRefBuilder
    implements Builder<CartLocationRef, CartLocationRefBuilder> {
  _$CartLocationRef? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  CartLocationRefStatusEnum? _status;
  CartLocationRefStatusEnum? get status => _$this._status;
  set status(CartLocationRefStatusEnum? status) => _$this._status = status;

  CartLocationRefBuilder() {
    CartLocationRef._defaults(this);
  }

  CartLocationRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _label = $v.label;
      _kind = $v.kind;
      _formattedAddress = $v.formattedAddress;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartLocationRef other) {
    _$v = other as _$CartLocationRef;
  }

  @override
  void update(void Function(CartLocationRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartLocationRef build() => _build();

  _$CartLocationRef _build() {
    final _$result = _$v ??
        _$CartLocationRef._(
          locationId: BuiltValueNullFieldError.checkNotNull(
              locationId, r'CartLocationRef', 'locationId'),
          label: label,
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'CartLocationRef', 'kind'),
          formattedAddress: formattedAddress,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CartLocationRef', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
