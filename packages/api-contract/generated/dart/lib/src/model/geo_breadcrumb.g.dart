// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_breadcrumb.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoBreadcrumb extends GeoBreadcrumb {
  @override
  final String? code;
  @override
  final String name;
  @override
  final String? level;

  factory _$GeoBreadcrumb([void Function(GeoBreadcrumbBuilder)? updates]) =>
      (GeoBreadcrumbBuilder()..update(updates))._build();

  _$GeoBreadcrumb._({this.code, required this.name, this.level}) : super._();
  @override
  GeoBreadcrumb rebuild(void Function(GeoBreadcrumbBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoBreadcrumbBuilder toBuilder() => GeoBreadcrumbBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoBreadcrumb &&
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
    return (newBuiltValueToStringHelper(r'GeoBreadcrumb')
          ..add('code', code)
          ..add('name', name)
          ..add('level', level))
        .toString();
  }
}

class GeoBreadcrumbBuilder
    implements Builder<GeoBreadcrumb, GeoBreadcrumbBuilder> {
  _$GeoBreadcrumb? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _level;
  String? get level => _$this._level;
  set level(String? level) => _$this._level = level;

  GeoBreadcrumbBuilder() {
    GeoBreadcrumb._defaults(this);
  }

  GeoBreadcrumbBuilder get _$this {
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
  void replace(GeoBreadcrumb other) {
    _$v = other as _$GeoBreadcrumb;
  }

  @override
  void update(void Function(GeoBreadcrumbBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoBreadcrumb build() => _build();

  _$GeoBreadcrumb _build() {
    final _$result = _$v ??
        _$GeoBreadcrumb._(
          code: code,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GeoBreadcrumb', 'name'),
          level: level,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
