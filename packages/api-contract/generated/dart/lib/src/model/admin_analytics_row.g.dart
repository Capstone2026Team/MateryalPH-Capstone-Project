// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_analytics_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class AdminAnalyticsRowBuilder {
  void replace(AdminAnalyticsRow other);
  void update(void Function(AdminAnalyticsRowBuilder) updates);
  String? get groupId;
  set groupId(String? groupId);

  String? get displayName;
  set displayName(String? displayName);

  AnalyticsMaterialRefBuilder get material;
  set material(AnalyticsMaterialRefBuilder? material);

  AnalyticsCategoryRefBuilder get category;
  set category(AnalyticsCategoryRefBuilder? category);

  ComparableSpecificationBuilder get specification;
  set specification(ComparableSpecificationBuilder? specification);

  AnalyticsUnitBuilder get unit;
  set unit(AnalyticsUnitBuilder? unit);

  AdminAnalyticsPointBuilder get startPoint;
  set startPoint(AdminAnalyticsPointBuilder? startPoint);

  AdminAnalyticsPointBuilder get endPoint;
  set endPoint(AdminAnalyticsPointBuilder? endPoint);

  AnalyticsTrendBuilder get trend;
  set trend(AnalyticsTrendBuilder? trend);

  AnalyticsCurrentCountsBuilder get current;
  set current(AnalyticsCurrentCountsBuilder? current);

  ListingImageBuilder get image;
  set image(ListingImageBuilder? image);
}

class _$$AdminAnalyticsRow extends $AdminAnalyticsRow {
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
  final AdminAnalyticsPoint startPoint;
  @override
  final AdminAnalyticsPoint endPoint;
  @override
  final AnalyticsTrend trend;
  @override
  final AnalyticsCurrentCounts current;
  @override
  final ListingImage? image;

  factory _$$AdminAnalyticsRow(
          [void Function($AdminAnalyticsRowBuilder)? updates]) =>
      ($AdminAnalyticsRowBuilder()..update(updates))._build();

  _$$AdminAnalyticsRow._(
      {required this.groupId,
      required this.displayName,
      required this.material,
      required this.category,
      required this.specification,
      required this.unit,
      required this.startPoint,
      required this.endPoint,
      required this.trend,
      required this.current,
      this.image})
      : super._();
  @override
  $AdminAnalyticsRow rebuild(
          void Function($AdminAnalyticsRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $AdminAnalyticsRowBuilder toBuilder() =>
      $AdminAnalyticsRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $AdminAnalyticsRow &&
        groupId == other.groupId &&
        displayName == other.displayName &&
        material == other.material &&
        category == other.category &&
        specification == other.specification &&
        unit == other.unit &&
        startPoint == other.startPoint &&
        endPoint == other.endPoint &&
        trend == other.trend &&
        current == other.current &&
        image == other.image;
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
    _$hash = $jc(_$hash, startPoint.hashCode);
    _$hash = $jc(_$hash, endPoint.hashCode);
    _$hash = $jc(_$hash, trend.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$AdminAnalyticsRow')
          ..add('groupId', groupId)
          ..add('displayName', displayName)
          ..add('material', material)
          ..add('category', category)
          ..add('specification', specification)
          ..add('unit', unit)
          ..add('startPoint', startPoint)
          ..add('endPoint', endPoint)
          ..add('trend', trend)
          ..add('current', current)
          ..add('image', image))
        .toString();
  }
}

class $AdminAnalyticsRowBuilder
    implements
        Builder<$AdminAnalyticsRow, $AdminAnalyticsRowBuilder>,
        AdminAnalyticsRowBuilder {
  _$$AdminAnalyticsRow? _$v;

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

  AdminAnalyticsPointBuilder? _startPoint;
  AdminAnalyticsPointBuilder get startPoint =>
      _$this._startPoint ??= AdminAnalyticsPointBuilder();
  set startPoint(covariant AdminAnalyticsPointBuilder? startPoint) =>
      _$this._startPoint = startPoint;

  AdminAnalyticsPointBuilder? _endPoint;
  AdminAnalyticsPointBuilder get endPoint =>
      _$this._endPoint ??= AdminAnalyticsPointBuilder();
  set endPoint(covariant AdminAnalyticsPointBuilder? endPoint) =>
      _$this._endPoint = endPoint;

  AnalyticsTrendBuilder? _trend;
  AnalyticsTrendBuilder get trend => _$this._trend ??= AnalyticsTrendBuilder();
  set trend(covariant AnalyticsTrendBuilder? trend) => _$this._trend = trend;

  AnalyticsCurrentCountsBuilder? _current;
  AnalyticsCurrentCountsBuilder get current =>
      _$this._current ??= AnalyticsCurrentCountsBuilder();
  set current(covariant AnalyticsCurrentCountsBuilder? current) =>
      _$this._current = current;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(covariant ListingImageBuilder? image) => _$this._image = image;

  $AdminAnalyticsRowBuilder() {
    $AdminAnalyticsRow._defaults(this);
  }

  $AdminAnalyticsRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
      _image = $v.image?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $AdminAnalyticsRow other) {
    _$v = other as _$$AdminAnalyticsRow;
  }

  @override
  void update(void Function($AdminAnalyticsRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $AdminAnalyticsRow build() => _build();

  _$$AdminAnalyticsRow _build() {
    _$$AdminAnalyticsRow _$result;
    try {
      _$result = _$v ??
          _$$AdminAnalyticsRow._(
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'$AdminAnalyticsRow', 'groupId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'$AdminAnalyticsRow', 'displayName'),
            material: material.build(),
            category: category.build(),
            specification: specification.build(),
            unit: unit.build(),
            startPoint: startPoint.build(),
            endPoint: endPoint.build(),
            trend: trend.build(),
            current: current.build(),
            image: _image?.build(),
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
        _$failedField = 'image';
        _image?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'$AdminAnalyticsRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
