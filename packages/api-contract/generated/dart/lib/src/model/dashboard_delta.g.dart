// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_delta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardDelta extends DashboardDelta {
  @override
  final int value;
  @override
  final int previous;
  @override
  final num? changePercent;

  factory _$DashboardDelta([void Function(DashboardDeltaBuilder)? updates]) =>
      (DashboardDeltaBuilder()..update(updates))._build();

  _$DashboardDelta._(
      {required this.value, required this.previous, this.changePercent})
      : super._();
  @override
  DashboardDelta rebuild(void Function(DashboardDeltaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardDeltaBuilder toBuilder() => DashboardDeltaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardDelta &&
        value == other.value &&
        previous == other.previous &&
        changePercent == other.changePercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jc(_$hash, changePercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardDelta')
          ..add('value', value)
          ..add('previous', previous)
          ..add('changePercent', changePercent))
        .toString();
  }
}

class DashboardDeltaBuilder
    implements Builder<DashboardDelta, DashboardDeltaBuilder> {
  _$DashboardDelta? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  int? _previous;
  int? get previous => _$this._previous;
  set previous(int? previous) => _$this._previous = previous;

  num? _changePercent;
  num? get changePercent => _$this._changePercent;
  set changePercent(num? changePercent) =>
      _$this._changePercent = changePercent;

  DashboardDeltaBuilder() {
    DashboardDelta._defaults(this);
  }

  DashboardDeltaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _previous = $v.previous;
      _changePercent = $v.changePercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardDelta other) {
    _$v = other as _$DashboardDelta;
  }

  @override
  void update(void Function(DashboardDeltaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardDelta build() => _build();

  _$DashboardDelta _build() {
    final _$result = _$v ??
        _$DashboardDelta._(
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'DashboardDelta', 'value'),
          previous: BuiltValueNullFieldError.checkNotNull(
              previous, r'DashboardDelta', 'previous'),
          changePercent: changePercent,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
