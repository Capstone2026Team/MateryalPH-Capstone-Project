// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_route.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectRouteOriginEnum _$projectRouteOriginEnum_PROJECT_SITE =
    const ProjectRouteOriginEnum._('PROJECT_SITE');

ProjectRouteOriginEnum _$projectRouteOriginEnumValueOf(String name) {
  switch (name) {
    case 'PROJECT_SITE':
      return _$projectRouteOriginEnum_PROJECT_SITE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectRouteOriginEnum> _$projectRouteOriginEnumValues =
    BuiltSet<ProjectRouteOriginEnum>(const <ProjectRouteOriginEnum>[
  _$projectRouteOriginEnum_PROJECT_SITE,
]);

Serializer<ProjectRouteOriginEnum> _$projectRouteOriginEnumSerializer =
    _$ProjectRouteOriginEnumSerializer();

class _$ProjectRouteOriginEnumSerializer
    implements PrimitiveSerializer<ProjectRouteOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PROJECT_SITE': 'PROJECT_SITE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PROJECT_SITE': 'PROJECT_SITE',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectRouteOriginEnum];
  @override
  final String wireName = 'ProjectRouteOriginEnum';

  @override
  Object serialize(Serializers serializers, ProjectRouteOriginEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectRouteOriginEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectRouteOriginEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectRoute extends ProjectRoute {
  @override
  final String candidateId;
  @override
  final String versionId;
  @override
  final ProjectRouteOriginEnum origin;
  @override
  final int distanceMeters;
  @override
  final int durationSeconds;
  @override
  final String encodedPolyline;
  @override
  final String durationBasis;
  @override
  final String computedAt;

  factory _$ProjectRoute([void Function(ProjectRouteBuilder)? updates]) =>
      (ProjectRouteBuilder()..update(updates))._build();

  _$ProjectRoute._(
      {required this.candidateId,
      required this.versionId,
      required this.origin,
      required this.distanceMeters,
      required this.durationSeconds,
      required this.encodedPolyline,
      required this.durationBasis,
      required this.computedAt})
      : super._();
  @override
  ProjectRoute rebuild(void Function(ProjectRouteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectRouteBuilder toBuilder() => ProjectRouteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectRoute &&
        candidateId == other.candidateId &&
        versionId == other.versionId &&
        origin == other.origin &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        encodedPolyline == other.encodedPolyline &&
        durationBasis == other.durationBasis &&
        computedAt == other.computedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, candidateId.hashCode);
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, encodedPolyline.hashCode);
    _$hash = $jc(_$hash, durationBasis.hashCode);
    _$hash = $jc(_$hash, computedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectRoute')
          ..add('candidateId', candidateId)
          ..add('versionId', versionId)
          ..add('origin', origin)
          ..add('distanceMeters', distanceMeters)
          ..add('durationSeconds', durationSeconds)
          ..add('encodedPolyline', encodedPolyline)
          ..add('durationBasis', durationBasis)
          ..add('computedAt', computedAt))
        .toString();
  }
}

class ProjectRouteBuilder
    implements Builder<ProjectRoute, ProjectRouteBuilder> {
  _$ProjectRoute? _$v;

  String? _candidateId;
  String? get candidateId => _$this._candidateId;
  set candidateId(String? candidateId) => _$this._candidateId = candidateId;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  ProjectRouteOriginEnum? _origin;
  ProjectRouteOriginEnum? get origin => _$this._origin;
  set origin(ProjectRouteOriginEnum? origin) => _$this._origin = origin;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  String? _encodedPolyline;
  String? get encodedPolyline => _$this._encodedPolyline;
  set encodedPolyline(String? encodedPolyline) =>
      _$this._encodedPolyline = encodedPolyline;

  String? _durationBasis;
  String? get durationBasis => _$this._durationBasis;
  set durationBasis(String? durationBasis) =>
      _$this._durationBasis = durationBasis;

  String? _computedAt;
  String? get computedAt => _$this._computedAt;
  set computedAt(String? computedAt) => _$this._computedAt = computedAt;

  ProjectRouteBuilder() {
    ProjectRoute._defaults(this);
  }

  ProjectRouteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _candidateId = $v.candidateId;
      _versionId = $v.versionId;
      _origin = $v.origin;
      _distanceMeters = $v.distanceMeters;
      _durationSeconds = $v.durationSeconds;
      _encodedPolyline = $v.encodedPolyline;
      _durationBasis = $v.durationBasis;
      _computedAt = $v.computedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectRoute other) {
    _$v = other as _$ProjectRoute;
  }

  @override
  void update(void Function(ProjectRouteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectRoute build() => _build();

  _$ProjectRoute _build() {
    final _$result = _$v ??
        _$ProjectRoute._(
          candidateId: BuiltValueNullFieldError.checkNotNull(
              candidateId, r'ProjectRoute', 'candidateId'),
          versionId: BuiltValueNullFieldError.checkNotNull(
              versionId, r'ProjectRoute', 'versionId'),
          origin: BuiltValueNullFieldError.checkNotNull(
              origin, r'ProjectRoute', 'origin'),
          distanceMeters: BuiltValueNullFieldError.checkNotNull(
              distanceMeters, r'ProjectRoute', 'distanceMeters'),
          durationSeconds: BuiltValueNullFieldError.checkNotNull(
              durationSeconds, r'ProjectRoute', 'durationSeconds'),
          encodedPolyline: BuiltValueNullFieldError.checkNotNull(
              encodedPolyline, r'ProjectRoute', 'encodedPolyline'),
          durationBasis: BuiltValueNullFieldError.checkNotNull(
              durationBasis, r'ProjectRoute', 'durationBasis'),
          computedAt: BuiltValueNullFieldError.checkNotNull(
              computedAt, r'ProjectRoute', 'computedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
