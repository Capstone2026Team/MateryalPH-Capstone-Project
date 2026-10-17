// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparable_variant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComparableVariant extends ComparableVariant {
  @override
  final String groupId;
  @override
  final String displayName;
  @override
  final AnalyticsMaterialRef material;
  @override
  final AnalyticsCategoryRef category;
  @override
  final ComparableSpecification specification;
  @override
  final AnalyticsUnit unit;

  factory _$ComparableVariant(
          [void Function(ComparableVariantBuilder)? updates]) =>
      (ComparableVariantBuilder()..update(updates))._build();

  _$ComparableVariant._(
      {required this.groupId,
      required this.displayName,
      required this.material,
      required this.category,
      required this.specification,
      required this.unit})
      : super._();
  @override
  ComparableVariant rebuild(void Function(ComparableVariantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComparableVariantBuilder toBuilder() =>
      ComparableVariantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComparableVariant &&
        groupId == other.groupId &&
        displayName == other.displayName &&
        material == other.material &&
        category == other.category &&
        specification == other.specification &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, material.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, specification.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComparableVariant')
          ..add('groupId', groupId)
          ..add('displayName', displayName)
          ..add('material', material)
          ..add('category', category)
          ..add('specification', specification)
          ..add('unit', unit))
        .toString();
  }
}

class ComparableVariantBuilder
    implements Builder<ComparableVariant, ComparableVariantBuilder> {
  _$ComparableVariant? _$v;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  AnalyticsMaterialRefBuilder? _material;
  AnalyticsMaterialRefBuilder get material =>
      _$this._material ??= AnalyticsMaterialRefBuilder();
  set material(AnalyticsMaterialRefBuilder? material) =>
      _$this._material = material;

  AnalyticsCategoryRefBuilder? _category;
  AnalyticsCategoryRefBuilder get category =>
      _$this._category ??= AnalyticsCategoryRefBuilder();
  set category(AnalyticsCategoryRefBuilder? category) =>
      _$this._category = category;

  ComparableSpecificationBuilder? _specification;
  ComparableSpecificationBuilder get specification =>
      _$this._specification ??= ComparableSpecificationBuilder();
  set specification(ComparableSpecificationBuilder? specification) =>
      _$this._specification = specification;

  AnalyticsUnitBuilder? _unit;
  AnalyticsUnitBuilder get unit => _$this._unit ??= AnalyticsUnitBuilder();
  set unit(AnalyticsUnitBuilder? unit) => _$this._unit = unit;

  ComparableVariantBuilder() {
    ComparableVariant._defaults(this);
  }

  ComparableVariantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupId = $v.groupId;
      _displayName = $v.displayName;
      _material = $v.material.toBuilder();
      _category = $v.category.toBuilder();
      _specification = $v.specification.toBuilder();
      _unit = $v.unit.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComparableVariant other) {
    _$v = other as _$ComparableVariant;
  }

  @override
  void update(void Function(ComparableVariantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComparableVariant build() => _build();

  _$ComparableVariant _build() {
    _$ComparableVariant _$result;
    try {
      _$result = _$v ??
          _$ComparableVariant._(
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'ComparableVariant', 'groupId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ComparableVariant', 'displayName'),
            material: material.build(),
            category: category.build(),
            specification: specification.build(),
            unit: unit.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'material';
        material.build();
        _$failedField = 'category';
        category.build();
        _$failedField = 'specification';
        specification.build();
        _$failedField = 'unit';
        unit.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComparableVariant', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
