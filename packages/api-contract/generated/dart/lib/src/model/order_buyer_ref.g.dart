// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_buyer_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderBuyerRef extends OrderBuyerRef {
  @override
  final String displayName;
  @override
  final String? mobileE164;
  @override
  final String? avatarPath;

  factory _$OrderBuyerRef([void Function(OrderBuyerRefBuilder)? updates]) =>
      (OrderBuyerRefBuilder()..update(updates))._build();

  _$OrderBuyerRef._(
      {required this.displayName, this.mobileE164, this.avatarPath})
      : super._();
  @override
  OrderBuyerRef rebuild(void Function(OrderBuyerRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderBuyerRefBuilder toBuilder() => OrderBuyerRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderBuyerRef &&
        displayName == other.displayName &&
        mobileE164 == other.mobileE164 &&
        avatarPath == other.avatarPath;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, mobileE164.hashCode);
    _$hash = $jc(_$hash, avatarPath.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderBuyerRef')
          ..add('displayName', displayName)
          ..add('mobileE164', mobileE164)
          ..add('avatarPath', avatarPath))
        .toString();
  }
}

class OrderBuyerRefBuilder
    implements Builder<OrderBuyerRef, OrderBuyerRefBuilder> {
  _$OrderBuyerRef? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _mobileE164;
  String? get mobileE164 => _$this._mobileE164;
  set mobileE164(String? mobileE164) => _$this._mobileE164 = mobileE164;

  String? _avatarPath;
  String? get avatarPath => _$this._avatarPath;
  set avatarPath(String? avatarPath) => _$this._avatarPath = avatarPath;

  OrderBuyerRefBuilder() {
    OrderBuyerRef._defaults(this);
  }

  OrderBuyerRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _mobileE164 = $v.mobileE164;
      _avatarPath = $v.avatarPath;
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
          mobileE164: mobileE164,
          avatarPath: avatarPath,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
