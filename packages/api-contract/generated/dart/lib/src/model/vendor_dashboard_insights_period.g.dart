// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_insights_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardInsightsPeriod extends VendorDashboardInsightsPeriod {
  @override
  final int days;
  @override
  final Date from;
  @override
  final Date to;
  @override
  final String timezone;

  factory _$VendorDashboardInsightsPeriod(
          [void Function(VendorDashboardInsightsPeriodBuilder)? updates]) =>
      (VendorDashboardInsightsPeriodBuilder()..update(updates))._build();

  _$VendorDashboardInsightsPeriod._(
      {required this.days,
      required this.from,
      required this.to,
      required this.timezone})
      : super._();
  @override
  VendorDashboardInsightsPeriod rebuild(
          void Function(VendorDashboardInsightsPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardInsightsPeriodBuilder toBuilder() =>
      VendorDashboardInsightsPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardInsightsPeriod &&
        days == other.days &&
        from == other.from &&
        to == other.to &&
        timezone == other.timezone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardInsightsPeriod')
          ..add('days', days)
          ..add('from', from)
          ..add('to', to)
          ..add('timezone', timezone))
        .toString();
  }
}

class VendorDashboardInsightsPeriodBuilder
    implements
        Builder<VendorDashboardInsightsPeriod,
            VendorDashboardInsightsPeriodBuilder> {
  _$VendorDashboardInsightsPeriod? _$v;

  int? _days;
  int? get days => _$this._days;
  set days(int? days) => _$this._days = days;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  VendorDashboardInsightsPeriodBuilder() {
    VendorDashboardInsightsPeriod._defaults(this);
  }

  VendorDashboardInsightsPeriodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _days = $v.days;
      _from = $v.from;
      _to = $v.to;
      _timezone = $v.timezone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardInsightsPeriod other) {
    _$v = other as _$VendorDashboardInsightsPeriod;
  }

  @override
  void update(void Function(VendorDashboardInsightsPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardInsightsPeriod build() => _build();

  _$VendorDashboardInsightsPeriod _build() {
    final _$result = _$v ??
        _$VendorDashboardInsightsPeriod._(
          days: BuiltValueNullFieldError.checkNotNull(
              days, r'VendorDashboardInsightsPeriod', 'days'),
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'VendorDashboardInsightsPeriod', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'VendorDashboardInsightsPeriod', 'to'),
          timezone: BuiltValueNullFieldError.checkNotNull(
              timezone, r'VendorDashboardInsightsPeriod', 'timezone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
