// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_compile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectCompileRadiusKmEnum _$projectCompileRadiusKmEnum_number5 =
    const ProjectCompileRadiusKmEnum._('number5');
const ProjectCompileRadiusKmEnum _$projectCompileRadiusKmEnum_number10 =
    const ProjectCompileRadiusKmEnum._('number10');
const ProjectCompileRadiusKmEnum _$projectCompileRadiusKmEnum_number20 =
    const ProjectCompileRadiusKmEnum._('number20');
const ProjectCompileRadiusKmEnum _$projectCompileRadiusKmEnum_number30 =
    const ProjectCompileRadiusKmEnum._('number30');
const ProjectCompileRadiusKmEnum _$projectCompileRadiusKmEnum_number40 =
    const ProjectCompileRadiusKmEnum._('number40');
const ProjectCompileRadiusKmEnum _$projectCompileRadiusKmEnum_number50 =
    const ProjectCompileRadiusKmEnum._('number50');

ProjectCompileRadiusKmEnum _$projectCompileRadiusKmEnumValueOf(String name) {
  switch (name) {
    case 'number5':
      return _$projectCompileRadiusKmEnum_number5;
    case 'number10':
      return _$projectCompileRadiusKmEnum_number10;
    case 'number20':
      return _$projectCompileRadiusKmEnum_number20;
    case 'number30':
      return _$projectCompileRadiusKmEnum_number30;
    case 'number40':
      return _$projectCompileRadiusKmEnum_number40;
    case 'number50':
      return _$projectCompileRadiusKmEnum_number50;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectCompileRadiusKmEnum> _$projectCompileRadiusKmEnumValues =
    BuiltSet<ProjectCompileRadiusKmEnum>(const <ProjectCompileRadiusKmEnum>[
  _$projectCompileRadiusKmEnum_number5,
  _$projectCompileRadiusKmEnum_number10,
  _$projectCompileRadiusKmEnum_number20,
  _$projectCompileRadiusKmEnum_number30,
  _$projectCompileRadiusKmEnum_number40,
  _$projectCompileRadiusKmEnum_number50,
]);

Serializer<ProjectCompileRadiusKmEnum> _$projectCompileRadiusKmEnumSerializer =
    _$ProjectCompileRadiusKmEnumSerializer();

class _$ProjectCompileRadiusKmEnumSerializer
    implements PrimitiveSerializer<ProjectCompileRadiusKmEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number5': 5,
    'number10': 10,
    'number20': 20,
    'number30': 30,
    'number40': 40,
    'number50': 50,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    5: 'number5',
    10: 'number10',
    20: 'number20',
    30: 'number30',
    40: 'number40',
    50: 'number50',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectCompileRadiusKmEnum];
  @override
  final String wireName = 'ProjectCompileRadiusKmEnum';

  @override
  Object serialize(Serializers serializers, ProjectCompileRadiusKmEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectCompileRadiusKmEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectCompileRadiusKmEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectCompile extends ProjectCompile {
  @override
  final int lockVersion;
  @override
  final ProjectCompileRadiusKmEnum radiusKm;

  factory _$ProjectCompile([void Function(ProjectCompileBuilder)? updates]) =>
      (ProjectCompileBuilder()..update(updates))._build();

  _$ProjectCompile._({required this.lockVersion, required this.radiusKm})
      : super._();
  @override
  ProjectCompile rebuild(void Function(ProjectCompileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectCompileBuilder toBuilder() => ProjectCompileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectCompile &&
        lockVersion == other.lockVersion &&
        radiusKm == other.radiusKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectCompile')
          ..add('lockVersion', lockVersion)
          ..add('radiusKm', radiusKm))
        .toString();
  }
}

class ProjectCompileBuilder
    implements Builder<ProjectCompile, ProjectCompileBuilder> {
  _$ProjectCompile? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ProjectCompileRadiusKmEnum? _radiusKm;
  ProjectCompileRadiusKmEnum? get radiusKm => _$this._radiusKm;
  set radiusKm(ProjectCompileRadiusKmEnum? radiusKm) =>
      _$this._radiusKm = radiusKm;

  ProjectCompileBuilder() {
    ProjectCompile._defaults(this);
  }

  ProjectCompileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _radiusKm = $v.radiusKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectCompile other) {
    _$v = other as _$ProjectCompile;
  }

  @override
  void update(void Function(ProjectCompileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectCompile build() => _build();

  _$ProjectCompile _build() {
    final _$result = _$v ??
        _$ProjectCompile._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProjectCompile', 'lockVersion'),
          radiusKm: BuiltValueNullFieldError.checkNotNull(
              radiusKm, r'ProjectCompile', 'radiusKm'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
