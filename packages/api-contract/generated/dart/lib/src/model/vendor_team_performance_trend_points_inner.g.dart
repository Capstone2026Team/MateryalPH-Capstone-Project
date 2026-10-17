// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_performance_trend_points_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamPerformanceTrendPointsInner
    extends VendorTeamPerformanceTrendPointsInner {
  @override
  final String date;
  @override
  final int value;

  factory _$VendorTeamPerformanceTrendPointsInner(
          [void Function(VendorTeamPerformanceTrendPointsInnerBuilder)?
              updates]) =>
      (VendorTeamPerformanceTrendPointsInnerBuilder()..update(updates))
          ._build();

  _$VendorTeamPerformanceTrendPointsInner._(
      {required this.date, required this.value})
      : super._();
  @override
  VendorTeamPerformanceTrendPointsInner rebuild(
          void Function(VendorTeamPerformanceTrendPointsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamPerformanceTrendPointsInnerBuilder toBuilder() =>
      VendorTeamPerformanceTrendPointsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamPerformanceTrendPointsInner &&
        date == other.date &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorTeamPerformanceTrendPointsInner')
          ..add('date', date)
          ..add('value', value))
        .toString();
  }
}

class VendorTeamPerformanceTrendPointsInnerBuilder
    implements
        Builder<VendorTeamPerformanceTrendPointsInner,
            VendorTeamPerformanceTrendPointsInnerBuilder> {
  _$VendorTeamPerformanceTrendPointsInner? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  VendorTeamPerformanceTrendPointsInnerBuilder() {
    VendorTeamPerformanceTrendPointsInner._defaults(this);
  }

  VendorTeamPerformanceTrendPointsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamPerformanceTrendPointsInner other) {
    _$v = other as _$VendorTeamPerformanceTrendPointsInner;
  }

  @override
  void update(
      void Function(VendorTeamPerformanceTrendPointsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamPerformanceTrendPointsInner build() => _build();

  _$VendorTeamPerformanceTrendPointsInner _build() {
    final _$result = _$v ??
        _$VendorTeamPerformanceTrendPointsInner._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'VendorTeamPerformanceTrendPointsInner', 'date'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'VendorTeamPerformanceTrendPointsInner', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
