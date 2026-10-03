// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectUpdateStatusEnum _$projectUpdateStatusEnum_ACTIVE =
    const ProjectUpdateStatusEnum._('ACTIVE');
const ProjectUpdateStatusEnum _$projectUpdateStatusEnum_COMPLETED =
    const ProjectUpdateStatusEnum._('COMPLETED');
const ProjectUpdateStatusEnum _$projectUpdateStatusEnum_ARCHIVED =
    const ProjectUpdateStatusEnum._('ARCHIVED');

ProjectUpdateStatusEnum _$projectUpdateStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$projectUpdateStatusEnum_ACTIVE;
    case 'COMPLETED':
      return _$projectUpdateStatusEnum_COMPLETED;
    case 'ARCHIVED':
      return _$projectUpdateStatusEnum_ARCHIVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectUpdateStatusEnum> _$projectUpdateStatusEnumValues =
    BuiltSet<ProjectUpdateStatusEnum>(const <ProjectUpdateStatusEnum>[
  _$projectUpdateStatusEnum_ACTIVE,
  _$projectUpdateStatusEnum_COMPLETED,
  _$projectUpdateStatusEnum_ARCHIVED,
]);

Serializer<ProjectUpdateStatusEnum> _$projectUpdateStatusEnumSerializer =
    _$ProjectUpdateStatusEnumSerializer();

class _$ProjectUpdateStatusEnumSerializer
    implements PrimitiveSerializer<ProjectUpdateStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'COMPLETED': 'COMPLETED',
    'ARCHIVED': 'ARCHIVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'COMPLETED': 'COMPLETED',
    'ARCHIVED': 'ARCHIVED',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectUpdateStatusEnum];
  @override
  final String wireName = 'ProjectUpdateStatusEnum';

  @override
  Object serialize(Serializers serializers, ProjectUpdateStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectUpdateStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectUpdateStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectUpdate extends ProjectUpdate {
  @override
  final int lockVersion;
  @override
  final String? name;
  @override
  final int? budgetCentavos;
  @override
  final String? startsOn;
  @override
  final String? endsOn;
  @override
  final String? locationId;
  @override
  final ProjectUpdateStatusEnum? status;

  factory _$ProjectUpdate([void Function(ProjectUpdateBuilder)? updates]) =>
      (ProjectUpdateBuilder()..update(updates))._build();

  _$ProjectUpdate._(
      {required this.lockVersion,
      this.name,
      this.budgetCentavos,
      this.startsOn,
      this.endsOn,
      this.locationId,
      this.status})
      : super._();
  @override
  ProjectUpdate rebuild(void Function(ProjectUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectUpdateBuilder toBuilder() => ProjectUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectUpdate &&
        lockVersion == other.lockVersion &&
        name == other.name &&
        budgetCentavos == other.budgetCentavos &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn &&
        locationId == other.locationId &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectUpdate')
          ..add('lockVersion', lockVersion)
          ..add('name', name)
          ..add('budgetCentavos', budgetCentavos)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn)
          ..add('locationId', locationId)
          ..add('status', status))
        .toString();
  }
}

class ProjectUpdateBuilder
    implements Builder<ProjectUpdate, ProjectUpdateBuilder> {
  _$ProjectUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _budgetCentavos;
  int? get budgetCentavos => _$this._budgetCentavos;
  set budgetCentavos(int? budgetCentavos) =>
      _$this._budgetCentavos = budgetCentavos;

  String? _startsOn;
  String? get startsOn => _$this._startsOn;
  set startsOn(String? startsOn) => _$this._startsOn = startsOn;

  String? _endsOn;
  String? get endsOn => _$this._endsOn;
  set endsOn(String? endsOn) => _$this._endsOn = endsOn;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  ProjectUpdateStatusEnum? _status;
  ProjectUpdateStatusEnum? get status => _$this._status;
  set status(ProjectUpdateStatusEnum? status) => _$this._status = status;

  ProjectUpdateBuilder() {
    ProjectUpdate._defaults(this);
  }

  ProjectUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _name = $v.name;
      _budgetCentavos = $v.budgetCentavos;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _locationId = $v.locationId;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectUpdate other) {
    _$v = other as _$ProjectUpdate;
  }

  @override
  void update(void Function(ProjectUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectUpdate build() => _build();

  _$ProjectUpdate _build() {
    final _$result = _$v ??
        _$ProjectUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProjectUpdate', 'lockVersion'),
          name: name,
          budgetCentavos: budgetCentavos,
          startsOn: startsOn,
          endsOn: endsOn,
          locationId: locationId,
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
