// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_ledger_meta_stale_listings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryLedgerMetaStaleListings
    extends InventoryLedgerMetaStaleListings {
  @override
  final int count;
  @override
  final BuiltList<StaleListing> items;

  factory _$InventoryLedgerMetaStaleListings(
          [void Function(InventoryLedgerMetaStaleListingsBuilder)? updates]) =>
      (InventoryLedgerMetaStaleListingsBuilder()..update(updates))._build();

  _$InventoryLedgerMetaStaleListings._(
      {required this.count, required this.items})
      : super._();
  @override
  InventoryLedgerMetaStaleListings rebuild(
          void Function(InventoryLedgerMetaStaleListingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryLedgerMetaStaleListingsBuilder toBuilder() =>
      InventoryLedgerMetaStaleListingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryLedgerMetaStaleListings &&
        count == other.count &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryLedgerMetaStaleListings')
          ..add('count', count)
          ..add('items', items))
        .toString();
  }
}

class InventoryLedgerMetaStaleListingsBuilder
    implements
        Builder<InventoryLedgerMetaStaleListings,
            InventoryLedgerMetaStaleListingsBuilder> {
  _$InventoryLedgerMetaStaleListings? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  ListBuilder<StaleListing>? _items;
  ListBuilder<StaleListing> get items =>
      _$this._items ??= ListBuilder<StaleListing>();
  set items(ListBuilder<StaleListing>? items) => _$this._items = items;

  InventoryLedgerMetaStaleListingsBuilder() {
    InventoryLedgerMetaStaleListings._defaults(this);
  }

  InventoryLedgerMetaStaleListingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryLedgerMetaStaleListings other) {
    _$v = other as _$InventoryLedgerMetaStaleListings;
  }

  @override
  void update(void Function(InventoryLedgerMetaStaleListingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryLedgerMetaStaleListings build() => _build();

  _$InventoryLedgerMetaStaleListings _build() {
    _$InventoryLedgerMetaStaleListings _$result;
    try {
      _$result = _$v ??
          _$InventoryLedgerMetaStaleListings._(
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'InventoryLedgerMetaStaleListings', 'count'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InventoryLedgerMetaStaleListings', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
