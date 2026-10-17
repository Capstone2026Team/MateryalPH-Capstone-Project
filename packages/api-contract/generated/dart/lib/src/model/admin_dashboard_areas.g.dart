// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_areas.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDashboardAreasStateEnum _$adminDashboardAreasStateEnum_OK =
    const AdminDashboardAreasStateEnum._('OK');
const AdminDashboardAreasStateEnum
    _$adminDashboardAreasStateEnum_INSUFFICIENT_DATA =
    const AdminDashboardAreasStateEnum._('INSUFFICIENT_DATA');

AdminDashboardAreasStateEnum _$adminDashboardAreasStateEnumValueOf(
    String name) {
  switch (name) {
    case 'OK':
      return _$adminDashboardAreasStateEnum_OK;
    case 'INSUFFICIENT_DATA':
      return _$adminDashboardAreasStateEnum_INSUFFICIENT_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDashboardAreasStateEnum>
    _$adminDashboardAreasStateEnumValues =
    BuiltSet<AdminDashboardAreasStateEnum>(const <AdminDashboardAreasStateEnum>[
  _$adminDashboardAreasStateEnum_OK,
  _$adminDashboardAreasStateEnum_INSUFFICIENT_DATA,
]);

Serializer<AdminDashboardAreasStateEnum>
    _$adminDashboardAreasStateEnumSerializer =
    _$AdminDashboardAreasStateEnumSerializer();

class _$AdminDashboardAreasStateEnumSerializer
    implements PrimitiveSerializer<AdminDashboardAreasStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminDashboardAreasStateEnum];
  @override
  final String wireName = 'AdminDashboardAreasStateEnum';

  @override
  Object serialize(Serializers serializers, AdminDashboardAreasStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDashboardAreasStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDashboardAreasStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDashboardAreas extends AdminDashboardAreas {
  @override
  final String childrenLabel;
  @override
  final int considered;
  @override
  final int excludedSuppressed;
  @override
  final BuiltList<String> features;
  @override
  final AdminDashboardAreasStateEnum state;
  @override
  final String? reason;
  @override
  final int? k;
  @override
  final num? silhouette;
  @override
  final BuiltList<AdminDashboardAreaSegment> segments;
  @override
  final BuiltList<AdminDashboardAreasUnusualInner> unusual;
  @override
  final BuiltList<AdminDashboardAreasRecruitmentInner> recruitment;
  @override
  final BuiltList<AdminDashboardAreasPointsInner> points;

  factory _$AdminDashboardAreas(
          [void Function(AdminDashboardAreasBuilder)? updates]) =>
      (AdminDashboardAreasBuilder()..update(updates))._build();

  _$AdminDashboardAreas._(
      {required this.childrenLabel,
      required this.considered,
      required this.excludedSuppressed,
      required this.features,
      required this.state,
      this.reason,
      this.k,
      this.silhouette,
      required this.segments,
      required this.unusual,
      required this.recruitment,
      required this.points})
      : super._();
  @override
  AdminDashboardAreas rebuild(
          void Function(AdminDashboardAreasBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardAreasBuilder toBuilder() =>
      AdminDashboardAreasBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardAreas &&
        childrenLabel == other.childrenLabel &&
        considered == other.considered &&
        excludedSuppressed == other.excludedSuppressed &&
        features == other.features &&
        state == other.state &&
        reason == other.reason &&
        k == other.k &&
        silhouette == other.silhouette &&
        segments == other.segments &&
        unusual == other.unusual &&
        recruitment == other.recruitment &&
        points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, childrenLabel.hashCode);
    _$hash = $jc(_$hash, considered.hashCode);
    _$hash = $jc(_$hash, excludedSuppressed.hashCode);
    _$hash = $jc(_$hash, features.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, k.hashCode);
    _$hash = $jc(_$hash, silhouette.hashCode);
    _$hash = $jc(_$hash, segments.hashCode);
    _$hash = $jc(_$hash, unusual.hashCode);
    _$hash = $jc(_$hash, recruitment.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardAreas')
          ..add('childrenLabel', childrenLabel)
          ..add('considered', considered)
          ..add('excludedSuppressed', excludedSuppressed)
          ..add('features', features)
          ..add('state', state)
          ..add('reason', reason)
          ..add('k', k)
          ..add('silhouette', silhouette)
          ..add('segments', segments)
          ..add('unusual', unusual)
          ..add('recruitment', recruitment)
          ..add('points', points))
        .toString();
  }
}

class AdminDashboardAreasBuilder
    implements Builder<AdminDashboardAreas, AdminDashboardAreasBuilder> {
  _$AdminDashboardAreas? _$v;

  String? _childrenLabel;
  String? get childrenLabel => _$this._childrenLabel;
  set childrenLabel(String? childrenLabel) =>
      _$this._childrenLabel = childrenLabel;

  int? _considered;
  int? get considered => _$this._considered;
  set considered(int? considered) => _$this._considered = considered;

  int? _excludedSuppressed;
  int? get excludedSuppressed => _$this._excludedSuppressed;
  set excludedSuppressed(int? excludedSuppressed) =>
      _$this._excludedSuppressed = excludedSuppressed;

  ListBuilder<String>? _features;
  ListBuilder<String> get features =>
      _$this._features ??= ListBuilder<String>();
  set features(ListBuilder<String>? features) => _$this._features = features;

  AdminDashboardAreasStateEnum? _state;
  AdminDashboardAreasStateEnum? get state => _$this._state;
  set state(AdminDashboardAreasStateEnum? state) => _$this._state = state;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _k;
  int? get k => _$this._k;
  set k(int? k) => _$this._k = k;

  num? _silhouette;
  num? get silhouette => _$this._silhouette;
  set silhouette(num? silhouette) => _$this._silhouette = silhouette;

  ListBuilder<AdminDashboardAreaSegment>? _segments;
  ListBuilder<AdminDashboardAreaSegment> get segments =>
      _$this._segments ??= ListBuilder<AdminDashboardAreaSegment>();
  set segments(ListBuilder<AdminDashboardAreaSegment>? segments) =>
      _$this._segments = segments;

  ListBuilder<AdminDashboardAreasUnusualInner>? _unusual;
  ListBuilder<AdminDashboardAreasUnusualInner> get unusual =>
      _$this._unusual ??= ListBuilder<AdminDashboardAreasUnusualInner>();
  set unusual(ListBuilder<AdminDashboardAreasUnusualInner>? unusual) =>
      _$this._unusual = unusual;

  ListBuilder<AdminDashboardAreasRecruitmentInner>? _recruitment;
  ListBuilder<AdminDashboardAreasRecruitmentInner> get recruitment =>
      _$this._recruitment ??=
          ListBuilder<AdminDashboardAreasRecruitmentInner>();
  set recruitment(
          ListBuilder<AdminDashboardAreasRecruitmentInner>? recruitment) =>
      _$this._recruitment = recruitment;

  ListBuilder<AdminDashboardAreasPointsInner>? _points;
  ListBuilder<AdminDashboardAreasPointsInner> get points =>
      _$this._points ??= ListBuilder<AdminDashboardAreasPointsInner>();
  set points(ListBuilder<AdminDashboardAreasPointsInner>? points) =>
      _$this._points = points;

  AdminDashboardAreasBuilder() {
    AdminDashboardAreas._defaults(this);
  }

  AdminDashboardAreasBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _childrenLabel = $v.childrenLabel;
      _considered = $v.considered;
      _excludedSuppressed = $v.excludedSuppressed;
      _features = $v.features.toBuilder();
      _state = $v.state;
      _reason = $v.reason;
      _k = $v.k;
      _silhouette = $v.silhouette;
      _segments = $v.segments.toBuilder();
      _unusual = $v.unusual.toBuilder();
      _recruitment = $v.recruitment.toBuilder();
      _points = $v.points.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardAreas other) {
    _$v = other as _$AdminDashboardAreas;
  }

  @override
  void update(void Function(AdminDashboardAreasBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardAreas build() => _build();

  _$AdminDashboardAreas _build() {
    _$AdminDashboardAreas _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardAreas._(
            childrenLabel: BuiltValueNullFieldError.checkNotNull(
                childrenLabel, r'AdminDashboardAreas', 'childrenLabel'),
            considered: BuiltValueNullFieldError.checkNotNull(
                considered, r'AdminDashboardAreas', 'considered'),
            excludedSuppressed: BuiltValueNullFieldError.checkNotNull(
                excludedSuppressed,
                r'AdminDashboardAreas',
                'excludedSuppressed'),
            features: features.build(),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'AdminDashboardAreas', 'state'),
            reason: reason,
            k: k,
            silhouette: silhouette,
            segments: segments.build(),
            unusual: unusual.build(),
            recruitment: recruitment.build(),
            points: points.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'features';
        features.build();

        _$failedField = 'segments';
        segments.build();
        _$failedField = 'unusual';
        unusual.build();
        _$failedField = 'recruitment';
        recruitment.build();
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardAreas', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
