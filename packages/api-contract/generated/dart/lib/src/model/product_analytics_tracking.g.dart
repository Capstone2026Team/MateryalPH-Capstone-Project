// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_tracking.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductAnalyticsTracking extends ProductAnalyticsTracking {
  @override
  final Date? viewsSince;

  factory _$ProductAnalyticsTracking(
          [void Function(ProductAnalyticsTrackingBuilder)? updates]) =>
      (ProductAnalyticsTrackingBuilder()..update(updates))._build();

  _$ProductAnalyticsTracking._({this.viewsSince}) : super._();
  @override
  ProductAnalyticsTracking rebuild(
          void Function(ProductAnalyticsTrackingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsTrackingBuilder toBuilder() =>
      ProductAnalyticsTrackingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsTracking && viewsSince == other.viewsSince;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, viewsSince.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductAnalyticsTracking')
          ..add('viewsSince', viewsSince))
        .toString();
  }
}

class ProductAnalyticsTrackingBuilder
    implements
        Builder<ProductAnalyticsTracking, ProductAnalyticsTrackingBuilder> {
  _$ProductAnalyticsTracking? _$v;

  Date? _viewsSince;
  Date? get viewsSince => _$this._viewsSince;
  set viewsSince(Date? viewsSince) => _$this._viewsSince = viewsSince;

  ProductAnalyticsTrackingBuilder() {
    ProductAnalyticsTracking._defaults(this);
  }

  ProductAnalyticsTrackingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _viewsSince = $v.viewsSince;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsTracking other) {
    _$v = other as _$ProductAnalyticsTracking;
  }

  @override
  void update(void Function(ProductAnalyticsTrackingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsTracking build() => _build();

  _$ProductAnalyticsTracking _build() {
    final _$result = _$v ??
        _$ProductAnalyticsTracking._(
          viewsSince: viewsSince,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
