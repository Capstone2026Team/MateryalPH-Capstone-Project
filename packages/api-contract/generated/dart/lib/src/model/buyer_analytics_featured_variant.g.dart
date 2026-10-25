// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_featured_variant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAnalyticsFeaturedVariant extends BuyerAnalyticsFeaturedVariant {
  @override
  final BuyerMaterialsAnalyticsDetailGroup group;
  @override
  final BuiltList<BuyerAnalyticsPoint> series;

  factory _$BuyerAnalyticsFeaturedVariant(
          [void Function(BuyerAnalyticsFeaturedVariantBuilder)? updates]) =>
      (BuyerAnalyticsFeaturedVariantBuilder()..update(updates))._build();

  _$BuyerAnalyticsFeaturedVariant._({required this.group, required this.series})
      : super._();
  @override
  BuyerAnalyticsFeaturedVariant rebuild(
          void Function(BuyerAnalyticsFeaturedVariantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAnalyticsFeaturedVariantBuilder toBuilder() =>
      BuyerAnalyticsFeaturedVariantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAnalyticsFeaturedVariant &&
        group == other.group &&
        series == other.series;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAnalyticsFeaturedVariant')
          ..add('group', group)
          ..add('series', series))
        .toString();
  }
}

class BuyerAnalyticsFeaturedVariantBuilder
    implements
        Builder<BuyerAnalyticsFeaturedVariant,
            BuyerAnalyticsFeaturedVariantBuilder> {
  _$BuyerAnalyticsFeaturedVariant? _$v;

  BuyerMaterialsAnalyticsDetailGroupBuilder? _group;
  BuyerMaterialsAnalyticsDetailGroupBuilder get group =>
      _$this._group ??= BuyerMaterialsAnalyticsDetailGroupBuilder();
  set group(BuyerMaterialsAnalyticsDetailGroupBuilder? group) =>
      _$this._group = group;

  ListBuilder<BuyerAnalyticsPoint>? _series;
  ListBuilder<BuyerAnalyticsPoint> get series =>
      _$this._series ??= ListBuilder<BuyerAnalyticsPoint>();
  set series(ListBuilder<BuyerAnalyticsPoint>? series) =>
      _$this._series = series;

  BuyerAnalyticsFeaturedVariantBuilder() {
    BuyerAnalyticsFeaturedVariant._defaults(this);
  }

  BuyerAnalyticsFeaturedVariantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _group = $v.group.toBuilder();
      _series = $v.series.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAnalyticsFeaturedVariant other) {
    _$v = other as _$BuyerAnalyticsFeaturedVariant;
  }

  @override
  void update(void Function(BuyerAnalyticsFeaturedVariantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAnalyticsFeaturedVariant build() => _build();

  _$BuyerAnalyticsFeaturedVariant _build() {
    _$BuyerAnalyticsFeaturedVariant _$result;
    try {
      _$result = _$v ??
          _$BuyerAnalyticsFeaturedVariant._(
            group: group.build(),
            series: series.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'group';
        group.build();
        _$failedField = 'series';
        series.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerAnalyticsFeaturedVariant', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
