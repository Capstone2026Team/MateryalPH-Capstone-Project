// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_trend_comparison.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsTrendComparison extends VendorEarningsTrendComparison {
  @override
  final Date from;
  @override
  final Date to;
  @override
  final VendorEarningsTrendFigures totals;
  @override
  final VendorEarningsTrendChange changePercent;

  factory _$VendorEarningsTrendComparison(
          [void Function(VendorEarningsTrendComparisonBuilder)? updates]) =>
      (VendorEarningsTrendComparisonBuilder()..update(updates))._build();

  _$VendorEarningsTrendComparison._(
      {required this.from,
      required this.to,
      required this.totals,
      required this.changePercent})
      : super._();
  @override
  VendorEarningsTrendComparison rebuild(
          void Function(VendorEarningsTrendComparisonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsTrendComparisonBuilder toBuilder() =>
      VendorEarningsTrendComparisonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsTrendComparison &&
        from == other.from &&
        to == other.to &&
        totals == other.totals &&
        changePercent == other.changePercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, changePercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsTrendComparison')
          ..add('from', from)
          ..add('to', to)
          ..add('totals', totals)
          ..add('changePercent', changePercent))
        .toString();
  }
}

class VendorEarningsTrendComparisonBuilder
    implements
        Builder<VendorEarningsTrendComparison,
            VendorEarningsTrendComparisonBuilder> {
  _$VendorEarningsTrendComparison? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  VendorEarningsTrendFiguresBuilder? _totals;
  VendorEarningsTrendFiguresBuilder get totals =>
      _$this._totals ??= VendorEarningsTrendFiguresBuilder();
  set totals(VendorEarningsTrendFiguresBuilder? totals) =>
      _$this._totals = totals;

  VendorEarningsTrendChangeBuilder? _changePercent;
  VendorEarningsTrendChangeBuilder get changePercent =>
      _$this._changePercent ??= VendorEarningsTrendChangeBuilder();
  set changePercent(VendorEarningsTrendChangeBuilder? changePercent) =>
      _$this._changePercent = changePercent;

  VendorEarningsTrendComparisonBuilder() {
    VendorEarningsTrendComparison._defaults(this);
  }

  VendorEarningsTrendComparisonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _totals = $v.totals.toBuilder();
      _changePercent = $v.changePercent.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsTrendComparison other) {
    _$v = other as _$VendorEarningsTrendComparison;
  }

  @override
  void update(void Function(VendorEarningsTrendComparisonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsTrendComparison build() => _build();

  _$VendorEarningsTrendComparison _build() {
    _$VendorEarningsTrendComparison _$result;
    try {
      _$result = _$v ??
          _$VendorEarningsTrendComparison._(
            from: BuiltValueNullFieldError.checkNotNull(
                from, r'VendorEarningsTrendComparison', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(
                to, r'VendorEarningsTrendComparison', 'to'),
            totals: totals.build(),
            changePercent: changePercent.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'totals';
        totals.build();
        _$failedField = 'changePercent';
        changePercent.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorEarningsTrendComparison', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
