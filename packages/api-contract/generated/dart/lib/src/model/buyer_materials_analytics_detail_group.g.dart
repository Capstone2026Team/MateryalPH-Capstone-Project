// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_materials_analytics_detail_group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerMaterialsAnalyticsDetailGroup
    extends BuyerMaterialsAnalyticsDetailGroup {
  @override
  final String? description;
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
  @override
  final BuyerAnalyticsPoint startPoint;
  @override
  final BuyerAnalyticsPoint endPoint;
  @override
  final AnalyticsTrend trend;
  @override
  final AnalyticsCurrentCounts current;

  factory _$BuyerMaterialsAnalyticsDetailGroup(
          [void Function(BuyerMaterialsAnalyticsDetailGroupBuilder)?
              updates]) =>
      (BuyerMaterialsAnalyticsDetailGroupBuilder()..update(updates))._build();

  _$BuyerMaterialsAnalyticsDetailGroup._(
      {this.description,
      required this.groupId,
      required this.displayName,
      required this.material,
      required this.category,
      required this.specification,
      required this.unit,
      required this.startPoint,
      required this.endPoint,
      required this.trend,
      required this.current})
      : super._();
  @override
  BuyerMaterialsAnalyticsDetailGroup rebuild(
          void Function(BuyerMaterialsAnalyticsDetailGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMaterialsAnalyticsDetailGroupBuilder toBuilder() =>
      BuyerMaterialsAnalyticsDetailGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMaterialsAnalyticsDetailGroup &&
        description == other.description &&
        groupId == other.groupId &&
        displayName == other.displayName &&
        material == other.material &&
        category == other.category &&
        specification == other.specification &&
        unit == other.unit &&
        startPoint == other.startPoint &&
        endPoint == other.endPoint &&
        trend == other.trend &&
        current == other.current;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, material.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, specification.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, startPoint.hashCode);
    _$hash = $jc(_$hash, endPoint.hashCode);
    _$hash = $jc(_$hash, trend.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMaterialsAnalyticsDetailGroup')
          ..add('description', description)
          ..add('groupId', groupId)
          ..add('displayName', displayName)
          ..add('material', material)
          ..add('category', category)
          ..add('specification', specification)
          ..add('unit', unit)
          ..add('startPoint', startPoint)
          ..add('endPoint', endPoint)
          ..add('trend', trend)
          ..add('current', current))
        .toString();
  }
}

class BuyerMaterialsAnalyticsDetailGroupBuilder
    implements
        Builder<BuyerMaterialsAnalyticsDetailGroup,
            BuyerMaterialsAnalyticsDetailGroupBuilder>,
        BuyerAnalyticsRowBuilder {
  _$BuyerMaterialsAnalyticsDetailGroup? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(covariant String? description) =>
      _$this._description = description;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(covariant String? groupId) => _$this._groupId = groupId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(covariant String? displayName) =>
      _$this._displayName = displayName;

  AnalyticsMaterialRefBuilder? _material;
  AnalyticsMaterialRefBuilder get material =>
      _$this._material ??= AnalyticsMaterialRefBuilder();
  set material(covariant AnalyticsMaterialRefBuilder? material) =>
      _$this._material = material;

  AnalyticsCategoryRefBuilder? _category;
  AnalyticsCategoryRefBuilder get category =>
      _$this._category ??= AnalyticsCategoryRefBuilder();
  set category(covariant AnalyticsCategoryRefBuilder? category) =>
      _$this._category = category;

  ComparableSpecificationBuilder? _specification;
  ComparableSpecificationBuilder get specification =>
      _$this._specification ??= ComparableSpecificationBuilder();
  set specification(covariant ComparableSpecificationBuilder? specification) =>
      _$this._specification = specification;

  AnalyticsUnitBuilder? _unit;
  AnalyticsUnitBuilder get unit => _$this._unit ??= AnalyticsUnitBuilder();
  set unit(covariant AnalyticsUnitBuilder? unit) => _$this._unit = unit;

  BuyerAnalyticsPointBuilder? _startPoint;
  BuyerAnalyticsPointBuilder get startPoint =>
      _$this._startPoint ??= BuyerAnalyticsPointBuilder();
  set startPoint(covariant BuyerAnalyticsPointBuilder? startPoint) =>
      _$this._startPoint = startPoint;

  BuyerAnalyticsPointBuilder? _endPoint;
  BuyerAnalyticsPointBuilder get endPoint =>
      _$this._endPoint ??= BuyerAnalyticsPointBuilder();
  set endPoint(covariant BuyerAnalyticsPointBuilder? endPoint) =>
      _$this._endPoint = endPoint;

  AnalyticsTrendBuilder? _trend;
  AnalyticsTrendBuilder get trend => _$this._trend ??= AnalyticsTrendBuilder();
  set trend(covariant AnalyticsTrendBuilder? trend) => _$this._trend = trend;

  AnalyticsCurrentCountsBuilder? _current;
  AnalyticsCurrentCountsBuilder get current =>
      _$this._current ??= AnalyticsCurrentCountsBuilder();
  set current(covariant AnalyticsCurrentCountsBuilder? current) =>
      _$this._current = current;

  BuyerMaterialsAnalyticsDetailGroupBuilder() {
    BuyerMaterialsAnalyticsDetailGroup._defaults(this);
  }

  BuyerMaterialsAnalyticsDetailGroupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _groupId = $v.groupId;
      _displayName = $v.displayName;
      _material = $v.material.toBuilder();
      _category = $v.category.toBuilder();
      _specification = $v.specification.toBuilder();
      _unit = $v.unit.toBuilder();
      _startPoint = $v.startPoint.toBuilder();
      _endPoint = $v.endPoint.toBuilder();
      _trend = $v.trend.toBuilder();
      _current = $v.current.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BuyerMaterialsAnalyticsDetailGroup other) {
    _$v = other as _$BuyerMaterialsAnalyticsDetailGroup;
  }

  @override
  void update(
      void Function(BuyerMaterialsAnalyticsDetailGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMaterialsAnalyticsDetailGroup build() => _build();

  _$BuyerMaterialsAnalyticsDetailGroup _build() {
    _$BuyerMaterialsAnalyticsDetailGroup _$result;
    try {
      _$result = _$v ??
          _$BuyerMaterialsAnalyticsDetailGroup._(
            description: description,
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'BuyerMaterialsAnalyticsDetailGroup', 'groupId'),
            displayName: BuiltValueNullFieldError.checkNotNull(displayName,
                r'BuyerMaterialsAnalyticsDetailGroup', 'displayName'),
            material: material.build(),
            category: category.build(),
            specification: specification.build(),
            unit: unit.build(),
            startPoint: startPoint.build(),
            endPoint: endPoint.build(),
            trend: trend.build(),
            current: current.build(),
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
        _$failedField = 'startPoint';
        startPoint.build();
        _$failedField = 'endPoint';
        endPoint.build();
        _$failedField = 'trend';
        trend.build();
        _$failedField = 'current';
        current.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerMaterialsAnalyticsDetailGroup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
