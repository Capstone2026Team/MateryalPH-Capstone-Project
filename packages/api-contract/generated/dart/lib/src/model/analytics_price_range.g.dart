// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_price_range.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsPriceRange extends AnalyticsPriceRange {
  @override
  final String minPhp;
  @override
  final String medianPhp;
  @override
  final String maxPhp;

  factory _$AnalyticsPriceRange(
          [void Function(AnalyticsPriceRangeBuilder)? updates]) =>
      (AnalyticsPriceRangeBuilder()..update(updates))._build();

  _$AnalyticsPriceRange._(
      {required this.minPhp, required this.medianPhp, required this.maxPhp})
      : super._();
  @override
  AnalyticsPriceRange rebuild(
          void Function(AnalyticsPriceRangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsPriceRangeBuilder toBuilder() =>
      AnalyticsPriceRangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsPriceRange &&
        minPhp == other.minPhp &&
        medianPhp == other.medianPhp &&
        maxPhp == other.maxPhp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minPhp.hashCode);
    _$hash = $jc(_$hash, medianPhp.hashCode);
    _$hash = $jc(_$hash, maxPhp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsPriceRange')
          ..add('minPhp', minPhp)
          ..add('medianPhp', medianPhp)
          ..add('maxPhp', maxPhp))
        .toString();
  }
}

class AnalyticsPriceRangeBuilder
    implements Builder<AnalyticsPriceRange, AnalyticsPriceRangeBuilder> {
  _$AnalyticsPriceRange? _$v;

  String? _minPhp;
  String? get minPhp => _$this._minPhp;
  set minPhp(String? minPhp) => _$this._minPhp = minPhp;

  String? _medianPhp;
  String? get medianPhp => _$this._medianPhp;
  set medianPhp(String? medianPhp) => _$this._medianPhp = medianPhp;

  String? _maxPhp;
  String? get maxPhp => _$this._maxPhp;
  set maxPhp(String? maxPhp) => _$this._maxPhp = maxPhp;

  AnalyticsPriceRangeBuilder() {
    AnalyticsPriceRange._defaults(this);
  }

  AnalyticsPriceRangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minPhp = $v.minPhp;
      _medianPhp = $v.medianPhp;
      _maxPhp = $v.maxPhp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsPriceRange other) {
    _$v = other as _$AnalyticsPriceRange;
  }

  @override
  void update(void Function(AnalyticsPriceRangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsPriceRange build() => _build();

  _$AnalyticsPriceRange _build() {
    final _$result = _$v ??
        _$AnalyticsPriceRange._(
          minPhp: BuiltValueNullFieldError.checkNotNull(
              minPhp, r'AnalyticsPriceRange', 'minPhp'),
          medianPhp: BuiltValueNullFieldError.checkNotNull(
              medianPhp, r'AnalyticsPriceRange', 'medianPhp'),
          maxPhp: BuiltValueNullFieldError.checkNotNull(
              maxPhp, r'AnalyticsPriceRange', 'maxPhp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
