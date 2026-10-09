// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_kpis_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceKpisPeriod extends FinanceKpisPeriod {
  @override
  final Date from;
  @override
  final Date to;

  factory _$FinanceKpisPeriod(
          [void Function(FinanceKpisPeriodBuilder)? updates]) =>
      (FinanceKpisPeriodBuilder()..update(updates))._build();

  _$FinanceKpisPeriod._({required this.from, required this.to}) : super._();
  @override
  FinanceKpisPeriod rebuild(void Function(FinanceKpisPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceKpisPeriodBuilder toBuilder() =>
      FinanceKpisPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceKpisPeriod && from == other.from && to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinanceKpisPeriod')
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class FinanceKpisPeriodBuilder
    implements Builder<FinanceKpisPeriod, FinanceKpisPeriodBuilder> {
  _$FinanceKpisPeriod? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  FinanceKpisPeriodBuilder() {
    FinanceKpisPeriod._defaults(this);
  }

  FinanceKpisPeriodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceKpisPeriod other) {
    _$v = other as _$FinanceKpisPeriod;
  }

  @override
  void update(void Function(FinanceKpisPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceKpisPeriod build() => _build();

  _$FinanceKpisPeriod _build() {
    final _$result = _$v ??
        _$FinanceKpisPeriod._(
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'FinanceKpisPeriod', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'FinanceKpisPeriod', 'to'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
