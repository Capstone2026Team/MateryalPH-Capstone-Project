// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_kpis_products_viewed.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsKpisProductsViewed
    extends VendorProductAnalyticsKpisProductsViewed {
  @override
  final int value;
  @override
  final int total;

  factory _$VendorProductAnalyticsKpisProductsViewed(
          [void Function(VendorProductAnalyticsKpisProductsViewedBuilder)?
              updates]) =>
      (VendorProductAnalyticsKpisProductsViewedBuilder()..update(updates))
          ._build();

  _$VendorProductAnalyticsKpisProductsViewed._(
      {required this.value, required this.total})
      : super._();
  @override
  VendorProductAnalyticsKpisProductsViewed rebuild(
          void Function(VendorProductAnalyticsKpisProductsViewedBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsKpisProductsViewedBuilder toBuilder() =>
      VendorProductAnalyticsKpisProductsViewedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsKpisProductsViewed &&
        value == other.value &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorProductAnalyticsKpisProductsViewed')
          ..add('value', value)
          ..add('total', total))
        .toString();
  }
}

class VendorProductAnalyticsKpisProductsViewedBuilder
    implements
        Builder<VendorProductAnalyticsKpisProductsViewed,
            VendorProductAnalyticsKpisProductsViewedBuilder> {
  _$VendorProductAnalyticsKpisProductsViewed? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  VendorProductAnalyticsKpisProductsViewedBuilder() {
    VendorProductAnalyticsKpisProductsViewed._defaults(this);
  }

  VendorProductAnalyticsKpisProductsViewedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsKpisProductsViewed other) {
    _$v = other as _$VendorProductAnalyticsKpisProductsViewed;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsKpisProductsViewedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsKpisProductsViewed build() => _build();

  _$VendorProductAnalyticsKpisProductsViewed _build() {
    final _$result = _$v ??
        _$VendorProductAnalyticsKpisProductsViewed._(
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'VendorProductAnalyticsKpisProductsViewed', 'value'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'VendorProductAnalyticsKpisProductsViewed', 'total'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
