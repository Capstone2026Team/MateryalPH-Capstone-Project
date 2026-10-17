// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_marketplace_forecast.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardMarketplaceForecast
    extends AdminDashboardMarketplaceForecast {
  @override
  final int horizonDays;
  @override
  final DashboardForecast grossGmv;
  @override
  final DashboardForecast orderVolume;

  factory _$AdminDashboardMarketplaceForecast(
          [void Function(AdminDashboardMarketplaceForecastBuilder)? updates]) =>
      (AdminDashboardMarketplaceForecastBuilder()..update(updates))._build();

  _$AdminDashboardMarketplaceForecast._(
      {required this.horizonDays,
      required this.grossGmv,
      required this.orderVolume})
      : super._();
  @override
  AdminDashboardMarketplaceForecast rebuild(
          void Function(AdminDashboardMarketplaceForecastBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardMarketplaceForecastBuilder toBuilder() =>
      AdminDashboardMarketplaceForecastBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardMarketplaceForecast &&
        horizonDays == other.horizonDays &&
        grossGmv == other.grossGmv &&
        orderVolume == other.orderVolume;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, horizonDays.hashCode);
    _$hash = $jc(_$hash, grossGmv.hashCode);
    _$hash = $jc(_$hash, orderVolume.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardMarketplaceForecast')
          ..add('horizonDays', horizonDays)
          ..add('grossGmv', grossGmv)
          ..add('orderVolume', orderVolume))
        .toString();
  }
}

class AdminDashboardMarketplaceForecastBuilder
    implements
        Builder<AdminDashboardMarketplaceForecast,
            AdminDashboardMarketplaceForecastBuilder> {
  _$AdminDashboardMarketplaceForecast? _$v;

  int? _horizonDays;
  int? get horizonDays => _$this._horizonDays;
  set horizonDays(int? horizonDays) => _$this._horizonDays = horizonDays;

  DashboardForecastBuilder? _grossGmv;
  DashboardForecastBuilder get grossGmv =>
      _$this._grossGmv ??= DashboardForecastBuilder();
  set grossGmv(DashboardForecastBuilder? grossGmv) =>
      _$this._grossGmv = grossGmv;

  DashboardForecastBuilder? _orderVolume;
  DashboardForecastBuilder get orderVolume =>
      _$this._orderVolume ??= DashboardForecastBuilder();
  set orderVolume(DashboardForecastBuilder? orderVolume) =>
      _$this._orderVolume = orderVolume;

  AdminDashboardMarketplaceForecastBuilder() {
    AdminDashboardMarketplaceForecast._defaults(this);
  }

  AdminDashboardMarketplaceForecastBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _horizonDays = $v.horizonDays;
      _grossGmv = $v.grossGmv.toBuilder();
      _orderVolume = $v.orderVolume.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardMarketplaceForecast other) {
    _$v = other as _$AdminDashboardMarketplaceForecast;
  }

  @override
  void update(
      void Function(AdminDashboardMarketplaceForecastBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardMarketplaceForecast build() => _build();

  _$AdminDashboardMarketplaceForecast _build() {
    _$AdminDashboardMarketplaceForecast _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardMarketplaceForecast._(
            horizonDays: BuiltValueNullFieldError.checkNotNull(horizonDays,
                r'AdminDashboardMarketplaceForecast', 'horizonDays'),
            grossGmv: grossGmv.build(),
            orderVolume: orderVolume.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'grossGmv';
        grossGmv.build();
        _$failedField = 'orderVolume';
        orderVolume.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardMarketplaceForecast', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
