// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_archive_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectArchiveItemTypeEnum _$projectArchiveItemTypeEnum_PROJECT =
    const ProjectArchiveItemTypeEnum._('PROJECT');
const ProjectArchiveItemTypeEnum _$projectArchiveItemTypeEnum_WORK_PACKAGE =
    const ProjectArchiveItemTypeEnum._('WORK_PACKAGE');

ProjectArchiveItemTypeEnum _$projectArchiveItemTypeEnumValueOf(String name) {
  switch (name) {
    case 'PROJECT':
      return _$projectArchiveItemTypeEnum_PROJECT;
    case 'WORK_PACKAGE':
      return _$projectArchiveItemTypeEnum_WORK_PACKAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectArchiveItemTypeEnum> _$projectArchiveItemTypeEnumValues =
    BuiltSet<ProjectArchiveItemTypeEnum>(const <ProjectArchiveItemTypeEnum>[
  _$projectArchiveItemTypeEnum_PROJECT,
  _$projectArchiveItemTypeEnum_WORK_PACKAGE,
]);

Serializer<ProjectArchiveItemTypeEnum> _$projectArchiveItemTypeEnumSerializer =
    _$ProjectArchiveItemTypeEnumSerializer();

class _$ProjectArchiveItemTypeEnumSerializer
    implements PrimitiveSerializer<ProjectArchiveItemTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PROJECT': 'PROJECT',
    'WORK_PACKAGE': 'WORK_PACKAGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PROJECT': 'PROJECT',
    'WORK_PACKAGE': 'WORK_PACKAGE',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectArchiveItemTypeEnum];
  @override
  final String wireName = 'ProjectArchiveItemTypeEnum';

  @override
  Object serialize(Serializers serializers, ProjectArchiveItemTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectArchiveItemTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectArchiveItemTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectArchiveItem extends ProjectArchiveItem {
  @override
  final String id;
  @override
  final ProjectArchiveItemTypeEnum type;
  @override
  final String name;
  @override
  final int budgetCentavos;
  @override
  final int lockVersion;
  @override
  final String projectId;
  @override
  final String? projectName;
  @override
  final bool parentArchived;
  @override
  final DateTime archivedAt;
  @override
  final DateTime deleteAfter;
  @override
  final int remainingDays;
  @override
  final bool canRestore;
  @override
  final bool canDelete;

  factory _$ProjectArchiveItem(
          [void Function(ProjectArchiveItemBuilder)? updates]) =>
      (ProjectArchiveItemBuilder()..update(updates))._build();

  _$ProjectArchiveItem._(
      {required this.id,
      required this.type,
      required this.name,
      required this.budgetCentavos,
      required this.lockVersion,
      required this.projectId,
      this.projectName,
      required this.parentArchived,
      required this.archivedAt,
      required this.deleteAfter,
      required this.remainingDays,
      required this.canRestore,
      required this.canDelete})
      : super._();
  @override
  ProjectArchiveItem rebuild(
          void Function(ProjectArchiveItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArchiveItemBuilder toBuilder() =>
      ProjectArchiveItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArchiveItem &&
        id == other.id &&
        type == other.type &&
        name == other.name &&
        budgetCentavos == other.budgetCentavos &&
        lockVersion == other.lockVersion &&
        projectId == other.projectId &&
        projectName == other.projectName &&
        parentArchived == other.parentArchived &&
        archivedAt == other.archivedAt &&
        deleteAfter == other.deleteAfter &&
        remainingDays == other.remainingDays &&
        canRestore == other.canRestore &&
        canDelete == other.canDelete;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, projectId.hashCode);
    _$hash = $jc(_$hash, projectName.hashCode);
    _$hash = $jc(_$hash, parentArchived.hashCode);
    _$hash = $jc(_$hash, archivedAt.hashCode);
    _$hash = $jc(_$hash, deleteAfter.hashCode);
    _$hash = $jc(_$hash, remainingDays.hashCode);
    _$hash = $jc(_$hash, canRestore.hashCode);
    _$hash = $jc(_$hash, canDelete.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArchiveItem')
          ..add('id', id)
          ..add('type', type)
          ..add('name', name)
          ..add('budgetCentavos', budgetCentavos)
          ..add('lockVersion', lockVersion)
          ..add('projectId', projectId)
          ..add('projectName', projectName)
          ..add('parentArchived', parentArchived)
          ..add('archivedAt', archivedAt)
          ..add('deleteAfter', deleteAfter)
          ..add('remainingDays', remainingDays)
          ..add('canRestore', canRestore)
          ..add('canDelete', canDelete))
        .toString();
  }
}

class ProjectArchiveItemBuilder
    implements Builder<ProjectArchiveItem, ProjectArchiveItemBuilder> {
  _$ProjectArchiveItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ProjectArchiveItemTypeEnum? _type;
  ProjectArchiveItemTypeEnum? get type => _$this._type;
  set type(ProjectArchiveItemTypeEnum? type) => _$this._type = type;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _budgetCentavos;
  int? get budgetCentavos => _$this._budgetCentavos;
  set budgetCentavos(int? budgetCentavos) =>
      _$this._budgetCentavos = budgetCentavos;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _projectId;
  String? get projectId => _$this._projectId;
  set projectId(String? projectId) => _$this._projectId = projectId;

  String? _projectName;
  String? get projectName => _$this._projectName;
  set projectName(String? projectName) => _$this._projectName = projectName;

  bool? _parentArchived;
  bool? get parentArchived => _$this._parentArchived;
  set parentArchived(bool? parentArchived) =>
      _$this._parentArchived = parentArchived;

  DateTime? _archivedAt;
  DateTime? get archivedAt => _$this._archivedAt;
  set archivedAt(DateTime? archivedAt) => _$this._archivedAt = archivedAt;

  DateTime? _deleteAfter;
  DateTime? get deleteAfter => _$this._deleteAfter;
  set deleteAfter(DateTime? deleteAfter) => _$this._deleteAfter = deleteAfter;

  int? _remainingDays;
  int? get remainingDays => _$this._remainingDays;
  set remainingDays(int? remainingDays) =>
      _$this._remainingDays = remainingDays;

  bool? _canRestore;
  bool? get canRestore => _$this._canRestore;
  set canRestore(bool? canRestore) => _$this._canRestore = canRestore;

  bool? _canDelete;
  bool? get canDelete => _$this._canDelete;
  set canDelete(bool? canDelete) => _$this._canDelete = canDelete;

  ProjectArchiveItemBuilder() {
    ProjectArchiveItem._defaults(this);
  }

  ProjectArchiveItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _name = $v.name;
      _budgetCentavos = $v.budgetCentavos;
      _lockVersion = $v.lockVersion;
      _projectId = $v.projectId;
      _projectName = $v.projectName;
      _parentArchived = $v.parentArchived;
      _archivedAt = $v.archivedAt;
      _deleteAfter = $v.deleteAfter;
      _remainingDays = $v.remainingDays;
      _canRestore = $v.canRestore;
      _canDelete = $v.canDelete;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArchiveItem other) {
    _$v = other as _$ProjectArchiveItem;
  }

  @override
  void update(void Function(ProjectArchiveItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArchiveItem build() => _build();

  _$ProjectArchiveItem _build() {
    final _$result = _$v ??
        _$ProjectArchiveItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProjectArchiveItem', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ProjectArchiveItem', 'type'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProjectArchiveItem', 'name'),
          budgetCentavos: BuiltValueNullFieldError.checkNotNull(
              budgetCentavos, r'ProjectArchiveItem', 'budgetCentavos'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProjectArchiveItem', 'lockVersion'),
          projectId: BuiltValueNullFieldError.checkNotNull(
              projectId, r'ProjectArchiveItem', 'projectId'),
          projectName: projectName,
          parentArchived: BuiltValueNullFieldError.checkNotNull(
              parentArchived, r'ProjectArchiveItem', 'parentArchived'),
          archivedAt: BuiltValueNullFieldError.checkNotNull(
              archivedAt, r'ProjectArchiveItem', 'archivedAt'),
          deleteAfter: BuiltValueNullFieldError.checkNotNull(
              deleteAfter, r'ProjectArchiveItem', 'deleteAfter'),
          remainingDays: BuiltValueNullFieldError.checkNotNull(
              remainingDays, r'ProjectArchiveItem', 'remainingDays'),
          canRestore: BuiltValueNullFieldError.checkNotNull(
              canRestore, r'ProjectArchiveItem', 'canRestore'),
          canDelete: BuiltValueNullFieldError.checkNotNull(
              canDelete, r'ProjectArchiveItem', 'canDelete'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
