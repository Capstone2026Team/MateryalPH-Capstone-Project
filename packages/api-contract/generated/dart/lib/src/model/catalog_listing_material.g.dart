// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_material.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogListingMaterial extends CatalogListingMaterial {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final bool regulated;

  factory _$CatalogListingMaterial(
          [void Function(CatalogListingMaterialBuilder)? updates]) =>
      (CatalogListingMaterialBuilder()..update(updates))._build();

  _$CatalogListingMaterial._(
      {required this.id,
      required this.code,
      required this.name,
      required this.regulated})
      : super._();
  @override
  CatalogListingMaterial rebuild(
          void Function(CatalogListingMaterialBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingMaterialBuilder toBuilder() =>
      CatalogListingMaterialBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingMaterial &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        regulated == other.regulated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, regulated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListingMaterial')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('regulated', regulated))
        .toString();
  }
}

class CatalogListingMaterialBuilder
    implements Builder<CatalogListingMaterial, CatalogListingMaterialBuilder> {
  _$CatalogListingMaterial? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _regulated;
  bool? get regulated => _$this._regulated;
  set regulated(bool? regulated) => _$this._regulated = regulated;

  CatalogListingMaterialBuilder() {
    CatalogListingMaterial._defaults(this);
  }

  CatalogListingMaterialBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _regulated = $v.regulated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListingMaterial other) {
    _$v = other as _$CatalogListingMaterial;
  }

  @override
  void update(void Function(CatalogListingMaterialBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingMaterial build() => _build();

  _$CatalogListingMaterial _build() {
    final _$result = _$v ??
        _$CatalogListingMaterial._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CatalogListingMaterial', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CatalogListingMaterial', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CatalogListingMaterial', 'name'),
          regulated: BuiltValueNullFieldError.checkNotNull(
              regulated, r'CatalogListingMaterial', 'regulated'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
