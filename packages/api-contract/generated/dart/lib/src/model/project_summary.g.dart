// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectSummaryStatusEnum _$projectSummaryStatusEnum_ACTIVE =
    const ProjectSummaryStatusEnum._('ACTIVE');
const ProjectSummaryStatusEnum _$projectSummaryStatusEnum_COMPLETED =
    const ProjectSummaryStatusEnum._('COMPLETED');
const ProjectSummaryStatusEnum _$projectSummaryStatusEnum_ARCHIVED =
    const ProjectSummaryStatusEnum._('ARCHIVED');

ProjectSummaryStatusEnum _$projectSummaryStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$projectSummaryStatusEnum_ACTIVE;
    case 'COMPLETED':
      return _$projectSummaryStatusEnum_COMPLETED;
    case 'ARCHIVED':
      return _$projectSummaryStatusEnum_ARCHIVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectSummaryStatusEnum> _$projectSummaryStatusEnumValues =
    BuiltSet<ProjectSummaryStatusEnum>(const <ProjectSummaryStatusEnum>[
  _$projectSummaryStatusEnum_ACTIVE,
  _$projectSummaryStatusEnum_COMPLETED,
  _$projectSummaryStatusEnum_ARCHIVED,
]);

Serializer<ProjectSummaryStatusEnum> _$projectSummaryStatusEnumSerializer =
    _$ProjectSummaryStatusEnumSerializer();

class _$ProjectSummaryStatusEnumSerializer
    implements PrimitiveSerializer<ProjectSummaryStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ProjectSummaryStatusEnum];
  @override
  final String wireName = 'ProjectSummaryStatusEnum';

  @override
  Object serialize(Serializers serializers, ProjectSummaryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectSummaryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectSummaryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectSummary extends ProjectSummary {
  @override
  final String id;
  @override
  final String name;
  @override
  final ProjectSummaryStatusEnum status;
  @override
  final int budgetCentavos;
  @override
  final String? startsOn;
  @override
  final String? endsOn;
  @override
  final int lockVersion;
  @override
  final ProjectBudget budget;

  factory _$ProjectSummary([void Function(ProjectSummaryBuilder)? updates]) =>
      (ProjectSummaryBuilder()..update(updates))._build();

  _$ProjectSummary._(
      {required this.id,
      required this.name,
      required this.status,
      required this.budgetCentavos,
      this.startsOn,
      this.endsOn,
      required this.lockVersion,
      required this.budget})
      : super._();
  @override
  ProjectSummary rebuild(void Function(ProjectSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectSummaryBuilder toBuilder() => ProjectSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectSummary &&
        id == other.id &&
        name == other.name &&
        status == other.status &&
        budgetCentavos == other.budgetCentavos &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn &&
        lockVersion == other.lockVersion &&
        budget == other.budget;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, budget.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectSummary')
          ..add('id', id)
          ..add('name', name)
          ..add('status', status)
          ..add('budgetCentavos', budgetCentavos)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn)
          ..add('lockVersion', lockVersion)
          ..add('budget', budget))
        .toString();
  }
}

class ProjectSummaryBuilder
    implements Builder<ProjectSummary, ProjectSummaryBuilder> {
  _$ProjectSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ProjectSummaryStatusEnum? _status;
  ProjectSummaryStatusEnum? get status => _$this._status;
  set status(ProjectSummaryStatusEnum? status) => _$this._status = status;

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

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ProjectBudgetBuilder? _budget;
  ProjectBudgetBuilder get budget => _$this._budget ??= ProjectBudgetBuilder();
  set budget(ProjectBudgetBuilder? budget) => _$this._budget = budget;

  ProjectSummaryBuilder() {
    ProjectSummary._defaults(this);
  }

  ProjectSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _status = $v.status;
      _budgetCentavos = $v.budgetCentavos;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _lockVersion = $v.lockVersion;
      _budget = $v.budget.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectSummary other) {
    _$v = other as _$ProjectSummary;
  }

  @override
  void update(void Function(ProjectSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectSummary build() => _build();

  _$ProjectSummary _build() {
    _$ProjectSummary _$result;
    try {
      _$result = _$v ??
          _$ProjectSummary._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProjectSummary', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProjectSummary', 'name'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProjectSummary', 'status'),
            budgetCentavos: BuiltValueNullFieldError.checkNotNull(
                budgetCentavos, r'ProjectSummary', 'budgetCentavos'),
            startsOn: startsOn,
            endsOn: endsOn,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'ProjectSummary', 'lockVersion'),
            budget: budget.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'budget';
        budget.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
