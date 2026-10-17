// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsUnit extends AnalyticsUnit {
  @override
  final String code;
  @override
  final String name;

  factory _$AnalyticsUnit([void Function(AnalyticsUnitBuilder)? updates]) =>
      (AnalyticsUnitBuilder()..update(updates))._build();

  _$AnalyticsUnit._({required this.code, required this.name}) : super._();
  @override
  AnalyticsUnit rebuild(void Function(AnalyticsUnitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsUnitBuilder toBuilder() => AnalyticsUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsUnit && code == other.code && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsUnit')
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class AnalyticsUnitBuilder
    implements Builder<AnalyticsUnit, AnalyticsUnitBuilder> {
  _$AnalyticsUnit? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AnalyticsUnitBuilder() {
    AnalyticsUnit._defaults(this);
  }

  AnalyticsUnitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsUnit other) {
    _$v = other as _$AnalyticsUnit;
  }

  @override
  void update(void Function(AnalyticsUnitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsUnit build() => _build();

  _$AnalyticsUnit _build() {
    final _$result = _$v ??
        _$AnalyticsUnit._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AnalyticsUnit', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AnalyticsUnit', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
