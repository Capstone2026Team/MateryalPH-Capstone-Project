// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_summaries.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsSummaries
    extends VendorProductAnalyticsSummaries {
  @override
  final ProductAnalyticsPeriod period;
  @override
  final BuiltList<VendorProductAnalyticsSummariesItemsInner> items;

  factory _$VendorProductAnalyticsSummaries(
          [void Function(VendorProductAnalyticsSummariesBuilder)? updates]) =>
      (VendorProductAnalyticsSummariesBuilder()..update(updates))._build();

  _$VendorProductAnalyticsSummaries._(
      {required this.period, required this.items})
      : super._();
  @override
  VendorProductAnalyticsSummaries rebuild(
          void Function(VendorProductAnalyticsSummariesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsSummariesBuilder toBuilder() =>
      VendorProductAnalyticsSummariesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsSummaries &&
        period == other.period &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsSummaries')
          ..add('period', period)
          ..add('items', items))
        .toString();
  }
}

class VendorProductAnalyticsSummariesBuilder
    implements
        Builder<VendorProductAnalyticsSummaries,
            VendorProductAnalyticsSummariesBuilder> {
  _$VendorProductAnalyticsSummaries? _$v;

  ProductAnalyticsPeriodBuilder? _period;
  ProductAnalyticsPeriodBuilder get period =>
      _$this._period ??= ProductAnalyticsPeriodBuilder();
  set period(ProductAnalyticsPeriodBuilder? period) => _$this._period = period;

  ListBuilder<VendorProductAnalyticsSummariesItemsInner>? _items;
  ListBuilder<VendorProductAnalyticsSummariesItemsInner> get items =>
      _$this._items ??=
          ListBuilder<VendorProductAnalyticsSummariesItemsInner>();
  set items(ListBuilder<VendorProductAnalyticsSummariesItemsInner>? items) =>
      _$this._items = items;

  VendorProductAnalyticsSummariesBuilder() {
    VendorProductAnalyticsSummaries._defaults(this);
  }

  VendorProductAnalyticsSummariesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _period = $v.period.toBuilder();
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsSummaries other) {
    _$v = other as _$VendorProductAnalyticsSummaries;
  }

  @override
  void update(void Function(VendorProductAnalyticsSummariesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsSummaries build() => _build();

  _$VendorProductAnalyticsSummaries _build() {
    _$VendorProductAnalyticsSummaries _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsSummaries._(
            period: period.build(),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'period';
        period.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsSummaries', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
