// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_breakdown.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsBreakdown extends VendorEarningsBreakdown {
  @override
  final VendorEarningsBreakdownSales sales;
  @override
  final VendorEarningsBreakdownOnline online;
  @override
  final VendorEarningsBreakdownPhysical physical;

  factory _$VendorEarningsBreakdown(
          [void Function(VendorEarningsBreakdownBuilder)? updates]) =>
      (VendorEarningsBreakdownBuilder()..update(updates))._build();

  _$VendorEarningsBreakdown._(
      {required this.sales, required this.online, required this.physical})
      : super._();
  @override
  VendorEarningsBreakdown rebuild(
          void Function(VendorEarningsBreakdownBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsBreakdownBuilder toBuilder() =>
      VendorEarningsBreakdownBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsBreakdown &&
        sales == other.sales &&
        online == other.online &&
        physical == other.physical;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sales.hashCode);
    _$hash = $jc(_$hash, online.hashCode);
    _$hash = $jc(_$hash, physical.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsBreakdown')
          ..add('sales', sales)
          ..add('online', online)
          ..add('physical', physical))
        .toString();
  }
}

class VendorEarningsBreakdownBuilder
    implements
        Builder<VendorEarningsBreakdown, VendorEarningsBreakdownBuilder> {
  _$VendorEarningsBreakdown? _$v;

  VendorEarningsBreakdownSalesBuilder? _sales;
  VendorEarningsBreakdownSalesBuilder get sales =>
      _$this._sales ??= VendorEarningsBreakdownSalesBuilder();
  set sales(VendorEarningsBreakdownSalesBuilder? sales) =>
      _$this._sales = sales;

  VendorEarningsBreakdownOnlineBuilder? _online;
  VendorEarningsBreakdownOnlineBuilder get online =>
      _$this._online ??= VendorEarningsBreakdownOnlineBuilder();
  set online(VendorEarningsBreakdownOnlineBuilder? online) =>
      _$this._online = online;

  VendorEarningsBreakdownPhysicalBuilder? _physical;
  VendorEarningsBreakdownPhysicalBuilder get physical =>
      _$this._physical ??= VendorEarningsBreakdownPhysicalBuilder();
  set physical(VendorEarningsBreakdownPhysicalBuilder? physical) =>
      _$this._physical = physical;

  VendorEarningsBreakdownBuilder() {
    VendorEarningsBreakdown._defaults(this);
  }

  VendorEarningsBreakdownBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sales = $v.sales.toBuilder();
      _online = $v.online.toBuilder();
      _physical = $v.physical.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsBreakdown other) {
    _$v = other as _$VendorEarningsBreakdown;
  }

  @override
  void update(void Function(VendorEarningsBreakdownBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsBreakdown build() => _build();

  _$VendorEarningsBreakdown _build() {
    _$VendorEarningsBreakdown _$result;
    try {
      _$result = _$v ??
          _$VendorEarningsBreakdown._(
            sales: sales.build(),
            online: online.build(),
            physical: physical.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sales';
        sales.build();
        _$failedField = 'online';
        online.build();
        _$failedField = 'physical';
        physical.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorEarningsBreakdown', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
