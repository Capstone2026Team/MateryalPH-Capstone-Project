// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psgc_area_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PsgcAreaOption extends PsgcAreaOption {
  @override
  final String code;
  @override
  final String name;
  @override
  final String level;

  factory _$PsgcAreaOption([void Function(PsgcAreaOptionBuilder)? updates]) =>
      (PsgcAreaOptionBuilder()..update(updates))._build();

  _$PsgcAreaOption._(
      {required this.code, required this.name, required this.level})
      : super._();
  @override
  PsgcAreaOption rebuild(void Function(PsgcAreaOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PsgcAreaOptionBuilder toBuilder() => PsgcAreaOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PsgcAreaOption &&
        code == other.code &&
        name == other.name &&
        level == other.level;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PsgcAreaOption')
          ..add('code', code)
          ..add('name', name)
          ..add('level', level))
        .toString();
  }
}

class PsgcAreaOptionBuilder
    implements Builder<PsgcAreaOption, PsgcAreaOptionBuilder> {
  _$PsgcAreaOption? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _level;
  String? get level => _$this._level;
  set level(String? level) => _$this._level = level;

  PsgcAreaOptionBuilder() {
    PsgcAreaOption._defaults(this);
  }

  PsgcAreaOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _level = $v.level;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PsgcAreaOption other) {
    _$v = other as _$PsgcAreaOption;
  }

  @override
  void update(void Function(PsgcAreaOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PsgcAreaOption build() => _build();

  _$PsgcAreaOption _build() {
    final _$result = _$v ??
        _$PsgcAreaOption._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PsgcAreaOption', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PsgcAreaOption', 'name'),
          level: BuiltValueNullFieldError.checkNotNull(
              level, r'PsgcAreaOption', 'level'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
