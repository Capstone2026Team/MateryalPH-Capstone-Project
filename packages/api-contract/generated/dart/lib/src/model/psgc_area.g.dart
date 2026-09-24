// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psgc_area.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PsgcArea extends PsgcArea {
  @override
  final String code;
  @override
  final String name;
  @override
  final String level;

  factory _$PsgcArea([void Function(PsgcAreaBuilder)? updates]) =>
      (PsgcAreaBuilder()..update(updates))._build();

  _$PsgcArea._({required this.code, required this.name, required this.level})
      : super._();
  @override
  PsgcArea rebuild(void Function(PsgcAreaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PsgcAreaBuilder toBuilder() => PsgcAreaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PsgcArea &&
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
    return (newBuiltValueToStringHelper(r'PsgcArea')
          ..add('code', code)
          ..add('name', name)
          ..add('level', level))
        .toString();
  }
}

class PsgcAreaBuilder implements Builder<PsgcArea, PsgcAreaBuilder> {
  _$PsgcArea? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _level;
  String? get level => _$this._level;
  set level(String? level) => _$this._level = level;

  PsgcAreaBuilder() {
    PsgcArea._defaults(this);
  }

  PsgcAreaBuilder get _$this {
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
  void replace(PsgcArea other) {
    _$v = other as _$PsgcArea;
  }

  @override
  void update(void Function(PsgcAreaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PsgcArea build() => _build();

  _$PsgcArea _build() {
    final _$result = _$v ??
        _$PsgcArea._(
          code:
              BuiltValueNullFieldError.checkNotNull(code, r'PsgcArea', 'code'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'PsgcArea', 'name'),
          level: BuiltValueNullFieldError.checkNotNull(
              level, r'PsgcArea', 'level'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
