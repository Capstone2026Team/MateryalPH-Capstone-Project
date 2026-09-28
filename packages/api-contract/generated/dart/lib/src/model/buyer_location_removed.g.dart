// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_removed.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerLocationRemoved extends BuyerLocationRemoved {
  @override
  final String id;
  @override
  final bool removed;

  factory _$BuyerLocationRemoved(
          [void Function(BuyerLocationRemovedBuilder)? updates]) =>
      (BuyerLocationRemovedBuilder()..update(updates))._build();

  _$BuyerLocationRemoved._({required this.id, required this.removed})
      : super._();
  @override
  BuyerLocationRemoved rebuild(
          void Function(BuyerLocationRemovedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationRemovedBuilder toBuilder() =>
      BuyerLocationRemovedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationRemoved &&
        id == other.id &&
        removed == other.removed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, removed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerLocationRemoved')
          ..add('id', id)
          ..add('removed', removed))
        .toString();
  }
}

class BuyerLocationRemovedBuilder
    implements Builder<BuyerLocationRemoved, BuyerLocationRemovedBuilder> {
  _$BuyerLocationRemoved? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _removed;
  bool? get removed => _$this._removed;
  set removed(bool? removed) => _$this._removed = removed;

  BuyerLocationRemovedBuilder() {
    BuyerLocationRemoved._defaults(this);
  }

  BuyerLocationRemovedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _removed = $v.removed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerLocationRemoved other) {
    _$v = other as _$BuyerLocationRemoved;
  }

  @override
  void update(void Function(BuyerLocationRemovedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationRemoved build() => _build();

  _$BuyerLocationRemoved _build() {
    final _$result = _$v ??
        _$BuyerLocationRemoved._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'BuyerLocationRemoved', 'id'),
          removed: BuiltValueNullFieldError.checkNotNull(
              removed, r'BuyerLocationRemoved', 'removed'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
