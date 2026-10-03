// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_vendor_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderVendorRef extends OrderVendorRef {
  @override
  final String id;
  @override
  final String name;

  factory _$OrderVendorRef([void Function(OrderVendorRefBuilder)? updates]) =>
      (OrderVendorRefBuilder()..update(updates))._build();

  _$OrderVendorRef._({required this.id, required this.name}) : super._();
  @override
  OrderVendorRef rebuild(void Function(OrderVendorRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderVendorRefBuilder toBuilder() => OrderVendorRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderVendorRef && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderVendorRef')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class OrderVendorRefBuilder
    implements Builder<OrderVendorRef, OrderVendorRefBuilder> {
  _$OrderVendorRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  OrderVendorRefBuilder() {
    OrderVendorRef._defaults(this);
  }

  OrderVendorRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderVendorRef other) {
    _$v = other as _$OrderVendorRef;
  }

  @override
  void update(void Function(OrderVendorRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderVendorRef build() => _build();

  _$OrderVendorRef _build() {
    final _$result = _$v ??
        _$OrderVendorRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'OrderVendorRef', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'OrderVendorRef', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
