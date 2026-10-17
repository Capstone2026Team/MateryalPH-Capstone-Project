// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_demand_rows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDemandRowsInner extends GeoDemandRowsInner {
  @override
  final String code;
  @override
  final String name;
  @override
  final String level;
  @override
  final BuiltList<GeoDemandCell> cells;

  factory _$GeoDemandRowsInner(
          [void Function(GeoDemandRowsInnerBuilder)? updates]) =>
      (GeoDemandRowsInnerBuilder()..update(updates))._build();

  _$GeoDemandRowsInner._(
      {required this.code,
      required this.name,
      required this.level,
      required this.cells})
      : super._();
  @override
  GeoDemandRowsInner rebuild(
          void Function(GeoDemandRowsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDemandRowsInnerBuilder toBuilder() =>
      GeoDemandRowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDemandRowsInner &&
        code == other.code &&
        name == other.name &&
        level == other.level &&
        cells == other.cells;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jc(_$hash, cells.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDemandRowsInner')
          ..add('code', code)
          ..add('name', name)
          ..add('level', level)
          ..add('cells', cells))
        .toString();
  }
}

class GeoDemandRowsInnerBuilder
    implements Builder<GeoDemandRowsInner, GeoDemandRowsInnerBuilder> {
  _$GeoDemandRowsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _level;
  String? get level => _$this._level;
  set level(String? level) => _$this._level = level;

  ListBuilder<GeoDemandCell>? _cells;
  ListBuilder<GeoDemandCell> get cells =>
      _$this._cells ??= ListBuilder<GeoDemandCell>();
  set cells(ListBuilder<GeoDemandCell>? cells) => _$this._cells = cells;

  GeoDemandRowsInnerBuilder() {
    GeoDemandRowsInner._defaults(this);
  }

  GeoDemandRowsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _level = $v.level;
      _cells = $v.cells.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDemandRowsInner other) {
    _$v = other as _$GeoDemandRowsInner;
  }

  @override
  void update(void Function(GeoDemandRowsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDemandRowsInner build() => _build();

  _$GeoDemandRowsInner _build() {
    _$GeoDemandRowsInner _$result;
    try {
      _$result = _$v ??
          _$GeoDemandRowsInner._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'GeoDemandRowsInner', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GeoDemandRowsInner', 'name'),
            level: BuiltValueNullFieldError.checkNotNull(
                level, r'GeoDemandRowsInner', 'level'),
            cells: cells.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cells';
        cells.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoDemandRowsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
