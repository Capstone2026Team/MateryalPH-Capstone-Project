// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_series_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardSeriesPoint extends AdminDashboardSeriesPoint {
  @override
  final Date date;
  @override
  final int? grossGmvCentavos;
  @override
  final int? netGmvCentavos;
  @override
  final int? orderVolume;
  @override
  final bool suppressed;
  @override
  final int? grossAverageCentavos;
  @override
  final num? volumeAverage;

  factory _$AdminDashboardSeriesPoint(
          [void Function(AdminDashboardSeriesPointBuilder)? updates]) =>
      (AdminDashboardSeriesPointBuilder()..update(updates))._build();

  _$AdminDashboardSeriesPoint._(
      {required this.date,
      this.grossGmvCentavos,
      this.netGmvCentavos,
      this.orderVolume,
      required this.suppressed,
      this.grossAverageCentavos,
      this.volumeAverage})
      : super._();
  @override
  AdminDashboardSeriesPoint rebuild(
          void Function(AdminDashboardSeriesPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardSeriesPointBuilder toBuilder() =>
      AdminDashboardSeriesPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardSeriesPoint &&
        date == other.date &&
        grossGmvCentavos == other.grossGmvCentavos &&
        netGmvCentavos == other.netGmvCentavos &&
        orderVolume == other.orderVolume &&
        suppressed == other.suppressed &&
        grossAverageCentavos == other.grossAverageCentavos &&
        volumeAverage == other.volumeAverage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, grossGmvCentavos.hashCode);
    _$hash = $jc(_$hash, netGmvCentavos.hashCode);
    _$hash = $jc(_$hash, orderVolume.hashCode);
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jc(_$hash, grossAverageCentavos.hashCode);
    _$hash = $jc(_$hash, volumeAverage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardSeriesPoint')
          ..add('date', date)
          ..add('grossGmvCentavos', grossGmvCentavos)
          ..add('netGmvCentavos', netGmvCentavos)
          ..add('orderVolume', orderVolume)
          ..add('suppressed', suppressed)
          ..add('grossAverageCentavos', grossAverageCentavos)
          ..add('volumeAverage', volumeAverage))
        .toString();
  }
}

class AdminDashboardSeriesPointBuilder
    implements
        Builder<AdminDashboardSeriesPoint, AdminDashboardSeriesPointBuilder> {
  _$AdminDashboardSeriesPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _grossGmvCentavos;
  int? get grossGmvCentavos => _$this._grossGmvCentavos;
  set grossGmvCentavos(int? grossGmvCentavos) =>
      _$this._grossGmvCentavos = grossGmvCentavos;

  int? _netGmvCentavos;
  int? get netGmvCentavos => _$this._netGmvCentavos;
  set netGmvCentavos(int? netGmvCentavos) =>
      _$this._netGmvCentavos = netGmvCentavos;

  int? _orderVolume;
  int? get orderVolume => _$this._orderVolume;
  set orderVolume(int? orderVolume) => _$this._orderVolume = orderVolume;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  int? _grossAverageCentavos;
  int? get grossAverageCentavos => _$this._grossAverageCentavos;
  set grossAverageCentavos(int? grossAverageCentavos) =>
      _$this._grossAverageCentavos = grossAverageCentavos;

  num? _volumeAverage;
  num? get volumeAverage => _$this._volumeAverage;
  set volumeAverage(num? volumeAverage) =>
      _$this._volumeAverage = volumeAverage;

  AdminDashboardSeriesPointBuilder() {
    AdminDashboardSeriesPoint._defaults(this);
  }

  AdminDashboardSeriesPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _grossGmvCentavos = $v.grossGmvCentavos;
      _netGmvCentavos = $v.netGmvCentavos;
      _orderVolume = $v.orderVolume;
      _suppressed = $v.suppressed;
      _grossAverageCentavos = $v.grossAverageCentavos;
      _volumeAverage = $v.volumeAverage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardSeriesPoint other) {
    _$v = other as _$AdminDashboardSeriesPoint;
  }

  @override
  void update(void Function(AdminDashboardSeriesPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardSeriesPoint build() => _build();

  _$AdminDashboardSeriesPoint _build() {
    final _$result = _$v ??
        _$AdminDashboardSeriesPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'AdminDashboardSeriesPoint', 'date'),
          grossGmvCentavos: grossGmvCentavos,
          netGmvCentavos: netGmvCentavos,
          orderVolume: orderVolume,
          suppressed: BuiltValueNullFieldError.checkNotNull(
              suppressed, r'AdminDashboardSeriesPoint', 'suppressed'),
          grossAverageCentavos: grossAverageCentavos,
          volumeAverage: volumeAverage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
