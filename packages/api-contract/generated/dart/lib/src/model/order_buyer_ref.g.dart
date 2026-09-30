// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_buyer_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderBuyerRef extends OrderBuyerRef {
  @override
  final String displayName;

  factory _$OrderBuyerRef([void Function(OrderBuyerRefBuilder)? updates]) =>
      (OrderBuyerRefBuilder()..update(updates))._build();

  _$OrderBuyerRef._({required this.displayName}) : super._();
  @override
  OrderBuyerRef rebuild(void Function(OrderBuyerRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderBuyerRefBuilder toBuilder() => OrderBuyerRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderBuyerRef && displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderBuyerRef')
          ..add('displayName', displayName))
        .toString();
  }
}

class OrderBuyerRefBuilder
    implements Builder<OrderBuyerRef, OrderBuyerRefBuilder> {
  _$OrderBuyerRef? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  OrderBuyerRefBuilder() {
    OrderBuyerRef._defaults(this);
  }

  OrderBuyerRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderBuyerRef other) {
    _$v = other as _$OrderBuyerRef;
  }

  @override
  void update(void Function(OrderBuyerRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderBuyerRef build() => _build();

  _$OrderBuyerRef _build() {
    final _$result = _$v ??
        _$OrderBuyerRef._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'OrderBuyerRef', 'displayName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
