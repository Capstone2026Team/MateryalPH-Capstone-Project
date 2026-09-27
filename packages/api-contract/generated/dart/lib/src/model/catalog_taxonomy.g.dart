// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_taxonomy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogTaxonomy extends CatalogTaxonomy {
  @override
  final BuiltList<CatalogReference> categories;
  @override
  final BuiltList<CatalogUnit> units;
  @override
  final BuiltList<CatalogReference> tags;
  @override
  final BuiltList<CatalogAttributeDefinition> attributeDefinitions;
  @override
  final BuiltList<TaxCategory> taxCategories;
  @override
  final BuiltList<TaxCategory> allowedTaxCategories;
  @override
  final CatalogLimits limits;

  factory _$CatalogTaxonomy([void Function(CatalogTaxonomyBuilder)? updates]) =>
      (CatalogTaxonomyBuilder()..update(updates))._build();

  _$CatalogTaxonomy._(
      {required this.categories,
      required this.units,
      required this.tags,
      required this.attributeDefinitions,
      required this.taxCategories,
      required this.allowedTaxCategories,
      required this.limits})
      : super._();
  @override
  CatalogTaxonomy rebuild(void Function(CatalogTaxonomyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogTaxonomyBuilder toBuilder() => CatalogTaxonomyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogTaxonomy &&
        categories == other.categories &&
        units == other.units &&
        tags == other.tags &&
        attributeDefinitions == other.attributeDefinitions &&
        taxCategories == other.taxCategories &&
        allowedTaxCategories == other.allowedTaxCategories &&
        limits == other.limits;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, units.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, attributeDefinitions.hashCode);
    _$hash = $jc(_$hash, taxCategories.hashCode);
    _$hash = $jc(_$hash, allowedTaxCategories.hashCode);
    _$hash = $jc(_$hash, limits.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogTaxonomy')
          ..add('categories', categories)
          ..add('units', units)
          ..add('tags', tags)
          ..add('attributeDefinitions', attributeDefinitions)
          ..add('taxCategories', taxCategories)
          ..add('allowedTaxCategories', allowedTaxCategories)
          ..add('limits', limits))
        .toString();
  }
}

class CatalogTaxonomyBuilder
    implements Builder<CatalogTaxonomy, CatalogTaxonomyBuilder> {
  _$CatalogTaxonomy? _$v;

  ListBuilder<CatalogReference>? _categories;
  ListBuilder<CatalogReference> get categories =>
      _$this._categories ??= ListBuilder<CatalogReference>();
  set categories(ListBuilder<CatalogReference>? categories) =>
      _$this._categories = categories;

  ListBuilder<CatalogUnit>? _units;
  ListBuilder<CatalogUnit> get units =>
      _$this._units ??= ListBuilder<CatalogUnit>();
  set units(ListBuilder<CatalogUnit>? units) => _$this._units = units;

  ListBuilder<CatalogReference>? _tags;
  ListBuilder<CatalogReference> get tags =>
      _$this._tags ??= ListBuilder<CatalogReference>();
  set tags(ListBuilder<CatalogReference>? tags) => _$this._tags = tags;

  ListBuilder<CatalogAttributeDefinition>? _attributeDefinitions;
  ListBuilder<CatalogAttributeDefinition> get attributeDefinitions =>
      _$this._attributeDefinitions ??=
          ListBuilder<CatalogAttributeDefinition>();
  set attributeDefinitions(
          ListBuilder<CatalogAttributeDefinition>? attributeDefinitions) =>
      _$this._attributeDefinitions = attributeDefinitions;

  ListBuilder<TaxCategory>? _taxCategories;
  ListBuilder<TaxCategory> get taxCategories =>
      _$this._taxCategories ??= ListBuilder<TaxCategory>();
  set taxCategories(ListBuilder<TaxCategory>? taxCategories) =>
      _$this._taxCategories = taxCategories;

  ListBuilder<TaxCategory>? _allowedTaxCategories;
  ListBuilder<TaxCategory> get allowedTaxCategories =>
      _$this._allowedTaxCategories ??= ListBuilder<TaxCategory>();
  set allowedTaxCategories(ListBuilder<TaxCategory>? allowedTaxCategories) =>
      _$this._allowedTaxCategories = allowedTaxCategories;

  CatalogLimitsBuilder? _limits;
  CatalogLimitsBuilder get limits => _$this._limits ??= CatalogLimitsBuilder();
  set limits(CatalogLimitsBuilder? limits) => _$this._limits = limits;

  CatalogTaxonomyBuilder() {
    CatalogTaxonomy._defaults(this);
  }

  CatalogTaxonomyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _units = $v.units.toBuilder();
      _tags = $v.tags.toBuilder();
      _attributeDefinitions = $v.attributeDefinitions.toBuilder();
      _taxCategories = $v.taxCategories.toBuilder();
      _allowedTaxCategories = $v.allowedTaxCategories.toBuilder();
      _limits = $v.limits.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogTaxonomy other) {
    _$v = other as _$CatalogTaxonomy;
  }

  @override
  void update(void Function(CatalogTaxonomyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogTaxonomy build() => _build();

  _$CatalogTaxonomy _build() {
    _$CatalogTaxonomy _$result;
    try {
      _$result = _$v ??
          _$CatalogTaxonomy._(
            categories: categories.build(),
            units: units.build(),
            tags: tags.build(),
            attributeDefinitions: attributeDefinitions.build(),
            taxCategories: taxCategories.build(),
            allowedTaxCategories: allowedTaxCategories.build(),
            limits: limits.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'units';
        units.build();
        _$failedField = 'tags';
        tags.build();
        _$failedField = 'attributeDefinitions';
        attributeDefinitions.build();
        _$failedField = 'taxCategories';
        taxCategories.build();
        _$failedField = 'allowedTaxCategories';
        allowedTaxCategories.build();
        _$failedField = 'limits';
        limits.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogTaxonomy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
