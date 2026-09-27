// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_material.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogMaterial extends CatalogMaterial {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final bool regulated;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String canonicalUnitId;
  @override
  final BuiltList<String> compatibleUnitIds;
  @override
  final BuiltList<String> suggestedTagIds;
  @override
  final RegulatedMaterialRule? regulatedRule;

  factory _$CatalogMaterial([void Function(CatalogMaterialBuilder)? updates]) =>
      (CatalogMaterialBuilder()..update(updates))._build();

  _$CatalogMaterial._(
      {required this.id,
      required this.code,
      required this.name,
      required this.regulated,
      required this.categoryId,
      required this.categoryName,
      required this.canonicalUnitId,
      required this.compatibleUnitIds,
      required this.suggestedTagIds,
      this.regulatedRule})
      : super._();
  @override
  CatalogMaterial rebuild(void Function(CatalogMaterialBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogMaterialBuilder toBuilder() => CatalogMaterialBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogMaterial &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        regulated == other.regulated &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        canonicalUnitId == other.canonicalUnitId &&
        compatibleUnitIds == other.compatibleUnitIds &&
        suggestedTagIds == other.suggestedTagIds &&
        regulatedRule == other.regulatedRule;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, regulated.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, canonicalUnitId.hashCode);
    _$hash = $jc(_$hash, compatibleUnitIds.hashCode);
    _$hash = $jc(_$hash, suggestedTagIds.hashCode);
    _$hash = $jc(_$hash, regulatedRule.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogMaterial')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('regulated', regulated)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('canonicalUnitId', canonicalUnitId)
          ..add('compatibleUnitIds', compatibleUnitIds)
          ..add('suggestedTagIds', suggestedTagIds)
          ..add('regulatedRule', regulatedRule))
        .toString();
  }
}

class CatalogMaterialBuilder
    implements Builder<CatalogMaterial, CatalogMaterialBuilder> {
  _$CatalogMaterial? _$v;

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

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  String? _canonicalUnitId;
  String? get canonicalUnitId => _$this._canonicalUnitId;
  set canonicalUnitId(String? canonicalUnitId) =>
      _$this._canonicalUnitId = canonicalUnitId;

  ListBuilder<String>? _compatibleUnitIds;
  ListBuilder<String> get compatibleUnitIds =>
      _$this._compatibleUnitIds ??= ListBuilder<String>();
  set compatibleUnitIds(ListBuilder<String>? compatibleUnitIds) =>
      _$this._compatibleUnitIds = compatibleUnitIds;

  ListBuilder<String>? _suggestedTagIds;
  ListBuilder<String> get suggestedTagIds =>
      _$this._suggestedTagIds ??= ListBuilder<String>();
  set suggestedTagIds(ListBuilder<String>? suggestedTagIds) =>
      _$this._suggestedTagIds = suggestedTagIds;

  RegulatedMaterialRuleBuilder? _regulatedRule;
  RegulatedMaterialRuleBuilder get regulatedRule =>
      _$this._regulatedRule ??= RegulatedMaterialRuleBuilder();
  set regulatedRule(RegulatedMaterialRuleBuilder? regulatedRule) =>
      _$this._regulatedRule = regulatedRule;

  CatalogMaterialBuilder() {
    CatalogMaterial._defaults(this);
  }

  CatalogMaterialBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _regulated = $v.regulated;
      _categoryId = $v.categoryId;
      _categoryName = $v.categoryName;
      _canonicalUnitId = $v.canonicalUnitId;
      _compatibleUnitIds = $v.compatibleUnitIds.toBuilder();
      _suggestedTagIds = $v.suggestedTagIds.toBuilder();
      _regulatedRule = $v.regulatedRule?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogMaterial other) {
    _$v = other as _$CatalogMaterial;
  }

  @override
  void update(void Function(CatalogMaterialBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogMaterial build() => _build();

  _$CatalogMaterial _build() {
    _$CatalogMaterial _$result;
    try {
      _$result = _$v ??
          _$CatalogMaterial._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CatalogMaterial', 'id'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'CatalogMaterial', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CatalogMaterial', 'name'),
            regulated: BuiltValueNullFieldError.checkNotNull(
                regulated, r'CatalogMaterial', 'regulated'),
            categoryId: BuiltValueNullFieldError.checkNotNull(
                categoryId, r'CatalogMaterial', 'categoryId'),
            categoryName: BuiltValueNullFieldError.checkNotNull(
                categoryName, r'CatalogMaterial', 'categoryName'),
            canonicalUnitId: BuiltValueNullFieldError.checkNotNull(
                canonicalUnitId, r'CatalogMaterial', 'canonicalUnitId'),
            compatibleUnitIds: compatibleUnitIds.build(),
            suggestedTagIds: suggestedTagIds.build(),
            regulatedRule: _regulatedRule?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'compatibleUnitIds';
        compatibleUnitIds.build();
        _$failedField = 'suggestedTagIds';
        suggestedTagIds.build();
        _$failedField = 'regulatedRule';
        _regulatedRule?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogMaterial', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
