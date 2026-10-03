// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_checkout_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderCheckoutRef extends OrderCheckoutRef {
  @override
  final String id;
  @override
  final String reference;

  factory _$OrderCheckoutRef(
          [void Function(OrderCheckoutRefBuilder)? updates]) =>
      (OrderCheckoutRefBuilder()..update(updates))._build();

  _$OrderCheckoutRef._({required this.id, required this.reference}) : super._();
  @override
  OrderCheckoutRef rebuild(void Function(OrderCheckoutRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderCheckoutRefBuilder toBuilder() =>
      OrderCheckoutRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderCheckoutRef &&
        id == other.id &&
        reference == other.reference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderCheckoutRef')
          ..add('id', id)
          ..add('reference', reference))
        .toString();
  }
}

class OrderCheckoutRefBuilder
    implements Builder<OrderCheckoutRef, OrderCheckoutRefBuilder> {
  _$OrderCheckoutRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  OrderCheckoutRefBuilder() {
    OrderCheckoutRef._defaults(this);
  }

  OrderCheckoutRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderCheckoutRef other) {
    _$v = other as _$OrderCheckoutRef;
  }

  @override
  void update(void Function(OrderCheckoutRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderCheckoutRef build() => _build();

  _$OrderCheckoutRef _build() {
    final _$result = _$v ??
        _$OrderCheckoutRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'OrderCheckoutRef', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'OrderCheckoutRef', 'reference'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
