// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_forecast.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsForecast extends VendorProductAnalyticsForecast {
  @override
  final int horizonDays;
  @override
  final DashboardForecast views;

  factory _$VendorProductAnalyticsForecast(
          [void Function(VendorProductAnalyticsForecastBuilder)? updates]) =>
      (VendorProductAnalyticsForecastBuilder()..update(updates))._build();

  _$VendorProductAnalyticsForecast._(
      {required this.horizonDays, required this.views})
      : super._();
  @override
  VendorProductAnalyticsForecast rebuild(
          void Function(VendorProductAnalyticsForecastBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsForecastBuilder toBuilder() =>
      VendorProductAnalyticsForecastBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsForecast &&
        horizonDays == other.horizonDays &&
        views == other.views;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, horizonDays.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsForecast')
          ..add('horizonDays', horizonDays)
          ..add('views', views))
        .toString();
  }
}

class VendorProductAnalyticsForecastBuilder
    implements
        Builder<VendorProductAnalyticsForecast,
            VendorProductAnalyticsForecastBuilder> {
  _$VendorProductAnalyticsForecast? _$v;

  int? _horizonDays;
  int? get horizonDays => _$this._horizonDays;
  set horizonDays(int? horizonDays) => _$this._horizonDays = horizonDays;

  DashboardForecastBuilder? _views;
  DashboardForecastBuilder get views =>
      _$this._views ??= DashboardForecastBuilder();
  set views(DashboardForecastBuilder? views) => _$this._views = views;

  VendorProductAnalyticsForecastBuilder() {
    VendorProductAnalyticsForecast._defaults(this);
  }

  VendorProductAnalyticsForecastBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _horizonDays = $v.horizonDays;
      _views = $v.views.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsForecast other) {
    _$v = other as _$VendorProductAnalyticsForecast;
  }

  @override
  void update(void Function(VendorProductAnalyticsForecastBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsForecast build() => _build();

  _$VendorProductAnalyticsForecast _build() {
    _$VendorProductAnalyticsForecast _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsForecast._(
            horizonDays: BuiltValueNullFieldError.checkNotNull(
                horizonDays, r'VendorProductAnalyticsForecast', 'horizonDays'),
            views: views.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'views';
        views.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsForecast', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
