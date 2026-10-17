// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_disputes_series_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardDisputesSeriesInner
    extends VendorDashboardDisputesSeriesInner {
  @override
  final Date date;
  @override
  final int cases;

  factory _$VendorDashboardDisputesSeriesInner(
          [void Function(VendorDashboardDisputesSeriesInnerBuilder)?
              updates]) =>
      (VendorDashboardDisputesSeriesInnerBuilder()..update(updates))._build();

  _$VendorDashboardDisputesSeriesInner._(
      {required this.date, required this.cases})
      : super._();
  @override
  VendorDashboardDisputesSeriesInner rebuild(
          void Function(VendorDashboardDisputesSeriesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardDisputesSeriesInnerBuilder toBuilder() =>
      VendorDashboardDisputesSeriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardDisputesSeriesInner &&
        date == other.date &&
        cases == other.cases;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, cases.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardDisputesSeriesInner')
          ..add('date', date)
          ..add('cases', cases))
        .toString();
  }
}

class VendorDashboardDisputesSeriesInnerBuilder
    implements
        Builder<VendorDashboardDisputesSeriesInner,
            VendorDashboardDisputesSeriesInnerBuilder> {
  _$VendorDashboardDisputesSeriesInner? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _cases;
  int? get cases => _$this._cases;
  set cases(int? cases) => _$this._cases = cases;

  VendorDashboardDisputesSeriesInnerBuilder() {
    VendorDashboardDisputesSeriesInner._defaults(this);
  }

  VendorDashboardDisputesSeriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _cases = $v.cases;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardDisputesSeriesInner other) {
    _$v = other as _$VendorDashboardDisputesSeriesInner;
  }

  @override
  void update(
      void Function(VendorDashboardDisputesSeriesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardDisputesSeriesInner build() => _build();

  _$VendorDashboardDisputesSeriesInner _build() {
    final _$result = _$v ??
        _$VendorDashboardDisputesSeriesInner._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'VendorDashboardDisputesSeriesInner', 'date'),
          cases: BuiltValueNullFieldError.checkNotNull(
              cases, r'VendorDashboardDisputesSeriesInner', 'cases'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
