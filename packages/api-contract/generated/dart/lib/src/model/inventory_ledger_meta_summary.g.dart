// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_ledger_meta_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryLedgerMetaSummary extends InventoryLedgerMetaSummary {
  @override
  final int variants;
  @override
  final int outOfStock;
  @override
  final int limitedStock;
  @override
  final int confirmationDue;
  @override
  final int stale;

  factory _$InventoryLedgerMetaSummary(
          [void Function(InventoryLedgerMetaSummaryBuilder)? updates]) =>
      (InventoryLedgerMetaSummaryBuilder()..update(updates))._build();

  _$InventoryLedgerMetaSummary._(
      {required this.variants,
      required this.outOfStock,
      required this.limitedStock,
      required this.confirmationDue,
      required this.stale})
      : super._();
  @override
  InventoryLedgerMetaSummary rebuild(
          void Function(InventoryLedgerMetaSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryLedgerMetaSummaryBuilder toBuilder() =>
      InventoryLedgerMetaSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryLedgerMetaSummary &&
        variants == other.variants &&
        outOfStock == other.outOfStock &&
        limitedStock == other.limitedStock &&
        confirmationDue == other.confirmationDue &&
        stale == other.stale;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, outOfStock.hashCode);
    _$hash = $jc(_$hash, limitedStock.hashCode);
    _$hash = $jc(_$hash, confirmationDue.hashCode);
    _$hash = $jc(_$hash, stale.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryLedgerMetaSummary')
          ..add('variants', variants)
          ..add('outOfStock', outOfStock)
          ..add('limitedStock', limitedStock)
          ..add('confirmationDue', confirmationDue)
          ..add('stale', stale))
        .toString();
  }
}

class InventoryLedgerMetaSummaryBuilder
    implements
        Builder<InventoryLedgerMetaSummary, InventoryLedgerMetaSummaryBuilder> {
  _$InventoryLedgerMetaSummary? _$v;

  int? _variants;
  int? get variants => _$this._variants;
  set variants(int? variants) => _$this._variants = variants;

  int? _outOfStock;
  int? get outOfStock => _$this._outOfStock;
  set outOfStock(int? outOfStock) => _$this._outOfStock = outOfStock;

  int? _limitedStock;
  int? get limitedStock => _$this._limitedStock;
  set limitedStock(int? limitedStock) => _$this._limitedStock = limitedStock;

  int? _confirmationDue;
  int? get confirmationDue => _$this._confirmationDue;
  set confirmationDue(int? confirmationDue) =>
      _$this._confirmationDue = confirmationDue;

  int? _stale;
  int? get stale => _$this._stale;
  set stale(int? stale) => _$this._stale = stale;

  InventoryLedgerMetaSummaryBuilder() {
    InventoryLedgerMetaSummary._defaults(this);
  }

  InventoryLedgerMetaSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _variants = $v.variants;
      _outOfStock = $v.outOfStock;
      _limitedStock = $v.limitedStock;
      _confirmationDue = $v.confirmationDue;
      _stale = $v.stale;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryLedgerMetaSummary other) {
    _$v = other as _$InventoryLedgerMetaSummary;
  }

  @override
  void update(void Function(InventoryLedgerMetaSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryLedgerMetaSummary build() => _build();

  _$InventoryLedgerMetaSummary _build() {
    final _$result = _$v ??
        _$InventoryLedgerMetaSummary._(
          variants: BuiltValueNullFieldError.checkNotNull(
              variants, r'InventoryLedgerMetaSummary', 'variants'),
          outOfStock: BuiltValueNullFieldError.checkNotNull(
              outOfStock, r'InventoryLedgerMetaSummary', 'outOfStock'),
          limitedStock: BuiltValueNullFieldError.checkNotNull(
              limitedStock, r'InventoryLedgerMetaSummary', 'limitedStock'),
          confirmationDue: BuiltValueNullFieldError.checkNotNull(
              confirmationDue,
              r'InventoryLedgerMetaSummary',
              'confirmationDue'),
          stale: BuiltValueNullFieldError.checkNotNull(
              stale, r'InventoryLedgerMetaSummary', 'stale'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
