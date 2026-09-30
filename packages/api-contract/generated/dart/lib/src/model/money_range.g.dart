// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_range.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MoneyRange extends MoneyRange {
  @override
  final int minCentavos;
  @override
  final int maxCentavos;

  factory _$MoneyRange([void Function(MoneyRangeBuilder)? updates]) =>
      (MoneyRangeBuilder()..update(updates))._build();

  _$MoneyRange._({required this.minCentavos, required this.maxCentavos})
      : super._();
  @override
  MoneyRange rebuild(void Function(MoneyRangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MoneyRangeBuilder toBuilder() => MoneyRangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoneyRange &&
        minCentavos == other.minCentavos &&
        maxCentavos == other.maxCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minCentavos.hashCode);
    _$hash = $jc(_$hash, maxCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MoneyRange')
          ..add('minCentavos', minCentavos)
          ..add('maxCentavos', maxCentavos))
        .toString();
  }
}

class MoneyRangeBuilder implements Builder<MoneyRange, MoneyRangeBuilder> {
  _$MoneyRange? _$v;

  int? _minCentavos;
  int? get minCentavos => _$this._minCentavos;
  set minCentavos(int? minCentavos) => _$this._minCentavos = minCentavos;

  int? _maxCentavos;
  int? get maxCentavos => _$this._maxCentavos;
  set maxCentavos(int? maxCentavos) => _$this._maxCentavos = maxCentavos;

  MoneyRangeBuilder() {
    MoneyRange._defaults(this);
  }

  MoneyRangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minCentavos = $v.minCentavos;
      _maxCentavos = $v.maxCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MoneyRange other) {
    _$v = other as _$MoneyRange;
  }

  @override
  void update(void Function(MoneyRangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MoneyRange build() => _build();

  _$MoneyRange _build() {
    final _$result = _$v ??
        _$MoneyRange._(
          minCentavos: BuiltValueNullFieldError.checkNotNull(
              minCentavos, r'MoneyRange', 'minCentavos'),
          maxCentavos: BuiltValueNullFieldError.checkNotNull(
              maxCentavos, r'MoneyRange', 'maxCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
