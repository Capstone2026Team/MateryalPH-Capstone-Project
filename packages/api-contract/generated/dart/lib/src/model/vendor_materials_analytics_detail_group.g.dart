// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_materials_analytics_detail_group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorMaterialsAnalyticsDetailGroup
    extends VendorMaterialsAnalyticsDetailGroup {
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
  final VendorAnalyticsPoint startPoint;
  @override
  final VendorAnalyticsPoint endPoint;
  @override
  final AnalyticsTrend trend;
  @override
  final VendorCurrentCompetitors currentCompetitors;
  @override
  final VendorOwnOffer? ownOffer;

  factory _$VendorMaterialsAnalyticsDetailGroup(
          [void Function(VendorMaterialsAnalyticsDetailGroupBuilder)?
              updates]) =>
      (VendorMaterialsAnalyticsDetailGroupBuilder()..update(updates))._build();

  _$VendorMaterialsAnalyticsDetailGroup._(
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
      required this.currentCompetitors,
      this.ownOffer})
      : super._();
  @override
  VendorMaterialsAnalyticsDetailGroup rebuild(
          void Function(VendorMaterialsAnalyticsDetailGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorMaterialsAnalyticsDetailGroupBuilder toBuilder() =>
      VendorMaterialsAnalyticsDetailGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorMaterialsAnalyticsDetailGroup &&
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
        currentCompetitors == other.currentCompetitors &&
        ownOffer == other.ownOffer;
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
    _$hash = $jc(_$hash, currentCompetitors.hashCode);
    _$hash = $jc(_$hash, ownOffer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorMaterialsAnalyticsDetailGroup')
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
          ..add('currentCompetitors', currentCompetitors)
          ..add('ownOffer', ownOffer))
        .toString();
  }
}

class VendorMaterialsAnalyticsDetailGroupBuilder
    implements
        Builder<VendorMaterialsAnalyticsDetailGroup,
            VendorMaterialsAnalyticsDetailGroupBuilder>,
        VendorAnalyticsRowBuilder {
  _$VendorMaterialsAnalyticsDetailGroup? _$v;

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

  VendorAnalyticsPointBuilder? _startPoint;
  VendorAnalyticsPointBuilder get startPoint =>
      _$this._startPoint ??= VendorAnalyticsPointBuilder();
  set startPoint(covariant VendorAnalyticsPointBuilder? startPoint) =>
      _$this._startPoint = startPoint;

  VendorAnalyticsPointBuilder? _endPoint;
  VendorAnalyticsPointBuilder get endPoint =>
      _$this._endPoint ??= VendorAnalyticsPointBuilder();
  set endPoint(covariant VendorAnalyticsPointBuilder? endPoint) =>
      _$this._endPoint = endPoint;

  AnalyticsTrendBuilder? _trend;
  AnalyticsTrendBuilder get trend => _$this._trend ??= AnalyticsTrendBuilder();
  set trend(covariant AnalyticsTrendBuilder? trend) => _$this._trend = trend;

  VendorCurrentCompetitorsBuilder? _currentCompetitors;
  VendorCurrentCompetitorsBuilder get currentCompetitors =>
      _$this._currentCompetitors ??= VendorCurrentCompetitorsBuilder();
  set currentCompetitors(
          covariant VendorCurrentCompetitorsBuilder? currentCompetitors) =>
      _$this._currentCompetitors = currentCompetitors;

  VendorOwnOfferBuilder? _ownOffer;
  VendorOwnOfferBuilder get ownOffer =>
      _$this._ownOffer ??= VendorOwnOfferBuilder();
  set ownOffer(covariant VendorOwnOfferBuilder? ownOffer) =>
      _$this._ownOffer = ownOffer;

  VendorMaterialsAnalyticsDetailGroupBuilder() {
    VendorMaterialsAnalyticsDetailGroup._defaults(this);
  }

  VendorMaterialsAnalyticsDetailGroupBuilder get _$this {
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
      _currentCompetitors = $v.currentCompetitors.toBuilder();
      _ownOffer = $v.ownOffer?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant VendorMaterialsAnalyticsDetailGroup other) {
    _$v = other as _$VendorMaterialsAnalyticsDetailGroup;
  }

  @override
  void update(
      void Function(VendorMaterialsAnalyticsDetailGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorMaterialsAnalyticsDetailGroup build() => _build();

  _$VendorMaterialsAnalyticsDetailGroup _build() {
    _$VendorMaterialsAnalyticsDetailGroup _$result;
    try {
      _$result = _$v ??
          _$VendorMaterialsAnalyticsDetailGroup._(
            description: description,
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'VendorMaterialsAnalyticsDetailGroup', 'groupId'),
            displayName: BuiltValueNullFieldError.checkNotNull(displayName,
                r'VendorMaterialsAnalyticsDetailGroup', 'displayName'),
            material: material.build(),
            category: category.build(),
            specification: specification.build(),
            unit: unit.build(),
            startPoint: startPoint.build(),
            endPoint: endPoint.build(),
            trend: trend.build(),
            currentCompetitors: currentCompetitors.build(),
            ownOffer: _ownOffer?.build(),
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
        _$failedField = 'currentCompetitors';
        currentCompetitors.build();
        _$failedField = 'ownOffer';
        _ownOffer?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'VendorMaterialsAnalyticsDetailGroup',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
