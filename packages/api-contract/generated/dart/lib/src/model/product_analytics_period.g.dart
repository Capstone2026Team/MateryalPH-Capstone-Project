// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductAnalyticsPeriod extends ProductAnalyticsPeriod {
  @override
  final int days;
  @override
  final Date from;
  @override
  final Date to;
  @override
  final String timezone;

  factory _$ProductAnalyticsPeriod(
          [void Function(ProductAnalyticsPeriodBuilder)? updates]) =>
      (ProductAnalyticsPeriodBuilder()..update(updates))._build();

  _$ProductAnalyticsPeriod._(
      {required this.days,
      required this.from,
      required this.to,
      required this.timezone})
      : super._();
  @override
  ProductAnalyticsPeriod rebuild(
          void Function(ProductAnalyticsPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsPeriodBuilder toBuilder() =>
      ProductAnalyticsPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsPeriod &&
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
    return (newBuiltValueToStringHelper(r'ProductAnalyticsPeriod')
          ..add('days', days)
          ..add('from', from)
          ..add('to', to)
          ..add('timezone', timezone))
        .toString();
  }
}

class ProductAnalyticsPeriodBuilder
    implements Builder<ProductAnalyticsPeriod, ProductAnalyticsPeriodBuilder> {
  _$ProductAnalyticsPeriod? _$v;

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

  ProductAnalyticsPeriodBuilder() {
    ProductAnalyticsPeriod._defaults(this);
  }

  ProductAnalyticsPeriodBuilder get _$this {
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
  void replace(ProductAnalyticsPeriod other) {
    _$v = other as _$ProductAnalyticsPeriod;
  }

  @override
  void update(void Function(ProductAnalyticsPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsPeriod build() => _build();

  _$ProductAnalyticsPeriod _build() {
    final _$result = _$v ??
        _$ProductAnalyticsPeriod._(
          days: BuiltValueNullFieldError.checkNotNull(
              days, r'ProductAnalyticsPeriod', 'days'),
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'ProductAnalyticsPeriod', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'ProductAnalyticsPeriod', 'to'),
          timezone: BuiltValueNullFieldError.checkNotNull(
              timezone, r'ProductAnalyticsPeriod', 'timezone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
