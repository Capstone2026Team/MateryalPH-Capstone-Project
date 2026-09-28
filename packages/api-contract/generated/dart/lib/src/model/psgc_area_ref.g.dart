// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psgc_area_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PsgcAreaRef extends PsgcAreaRef {
  @override
  final String code;
  @override
  final String? name;

  factory _$PsgcAreaRef([void Function(PsgcAreaRefBuilder)? updates]) =>
      (PsgcAreaRefBuilder()..update(updates))._build();

  _$PsgcAreaRef._({required this.code, this.name}) : super._();
  @override
  PsgcAreaRef rebuild(void Function(PsgcAreaRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PsgcAreaRefBuilder toBuilder() => PsgcAreaRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PsgcAreaRef && code == other.code && name == other.name;
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
    return (newBuiltValueToStringHelper(r'PsgcAreaRef')
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class PsgcAreaRefBuilder implements Builder<PsgcAreaRef, PsgcAreaRefBuilder> {
  _$PsgcAreaRef? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PsgcAreaRefBuilder() {
    PsgcAreaRef._defaults(this);
  }

  PsgcAreaRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PsgcAreaRef other) {
    _$v = other as _$PsgcAreaRef;
  }

  @override
  void update(void Function(PsgcAreaRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PsgcAreaRef build() => _build();

  _$PsgcAreaRef _build() {
    final _$result = _$v ??
        _$PsgcAreaRef._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PsgcAreaRef', 'code'),
          name: name,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
