// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogUnit extends CatalogUnit {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String dimension;
  @override
  final int precision;

  factory _$CatalogUnit([void Function(CatalogUnitBuilder)? updates]) =>
      (CatalogUnitBuilder()..update(updates))._build();

  _$CatalogUnit._(
      {required this.id,
      required this.code,
      required this.name,
      required this.dimension,
      required this.precision})
      : super._();
  @override
  CatalogUnit rebuild(void Function(CatalogUnitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogUnitBuilder toBuilder() => CatalogUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogUnit &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        dimension == other.dimension &&
        precision == other.precision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, dimension.hashCode);
    _$hash = $jc(_$hash, precision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogUnit')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('dimension', dimension)
          ..add('precision', precision))
        .toString();
  }
}

class CatalogUnitBuilder implements Builder<CatalogUnit, CatalogUnitBuilder> {
  _$CatalogUnit? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _dimension;
  String? get dimension => _$this._dimension;
  set dimension(String? dimension) => _$this._dimension = dimension;

  int? _precision;
  int? get precision => _$this._precision;
  set precision(int? precision) => _$this._precision = precision;

  CatalogUnitBuilder() {
    CatalogUnit._defaults(this);
  }

  CatalogUnitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _dimension = $v.dimension;
      _precision = $v.precision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogUnit other) {
    _$v = other as _$CatalogUnit;
  }

  @override
  void update(void Function(CatalogUnitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogUnit build() => _build();

  _$CatalogUnit _build() {
    final _$result = _$v ??
        _$CatalogUnit._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CatalogUnit', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CatalogUnit', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CatalogUnit', 'name'),
          dimension: BuiltValueNullFieldError.checkNotNull(
              dimension, r'CatalogUnit', 'dimension'),
          precision: BuiltValueNullFieldError.checkNotNull(
              precision, r'CatalogUnit', 'precision'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
