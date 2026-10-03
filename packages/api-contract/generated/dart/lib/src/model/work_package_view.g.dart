// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_view.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageViewProjectStatusEnum
    _$workPackageViewProjectStatusEnum_ACTIVE =
    const WorkPackageViewProjectStatusEnum._('ACTIVE');
const WorkPackageViewProjectStatusEnum
    _$workPackageViewProjectStatusEnum_COMPLETED =
    const WorkPackageViewProjectStatusEnum._('COMPLETED');
const WorkPackageViewProjectStatusEnum
    _$workPackageViewProjectStatusEnum_ARCHIVED =
    const WorkPackageViewProjectStatusEnum._('ARCHIVED');

WorkPackageViewProjectStatusEnum _$workPackageViewProjectStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$workPackageViewProjectStatusEnum_ACTIVE;
    case 'COMPLETED':
      return _$workPackageViewProjectStatusEnum_COMPLETED;
    case 'ARCHIVED':
      return _$workPackageViewProjectStatusEnum_ARCHIVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageViewProjectStatusEnum>
    _$workPackageViewProjectStatusEnumValues = BuiltSet<
        WorkPackageViewProjectStatusEnum>(const <WorkPackageViewProjectStatusEnum>[
  _$workPackageViewProjectStatusEnum_ACTIVE,
  _$workPackageViewProjectStatusEnum_COMPLETED,
  _$workPackageViewProjectStatusEnum_ARCHIVED,
]);

Serializer<WorkPackageViewProjectStatusEnum>
    _$workPackageViewProjectStatusEnumSerializer =
    _$WorkPackageViewProjectStatusEnumSerializer();

class _$WorkPackageViewProjectStatusEnumSerializer
    implements PrimitiveSerializer<WorkPackageViewProjectStatusEnum> {
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
  final Iterable<Type> types = const <Type>[WorkPackageViewProjectStatusEnum];
  @override
  final String wireName = 'WorkPackageViewProjectStatusEnum';

  @override
  Object serialize(
          Serializers serializers, WorkPackageViewProjectStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageViewProjectStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageViewProjectStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageView extends WorkPackageView {
  @override
  final String id;
  @override
  final String projectId;
  @override
  final WorkPackageViewProjectStatusEnum projectStatus;
  @override
  final String name;
  @override
  final String status;
  @override
  final int budgetCentavos;
  @override
  final int lockVersion;
  @override
  final String? currentVersionId;
  @override
  final String? selectedVendorId;
  @override
  final String? orderId;
  @override
  final WorkPackageVersion? version;
  @override
  final WorkPackageVersionPage versions;
  @override
  final ProjectBudget budget;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> missingLines;
  @override
  final BuiltMap<String, JsonObject?> document;

  factory _$WorkPackageView([void Function(WorkPackageViewBuilder)? updates]) =>
      (WorkPackageViewBuilder()..update(updates))._build();

  _$WorkPackageView._(
      {required this.id,
      required this.projectId,
      required this.projectStatus,
      required this.name,
      required this.status,
      required this.budgetCentavos,
      required this.lockVersion,
      this.currentVersionId,
      this.selectedVendorId,
      this.orderId,
      this.version,
      required this.versions,
      required this.budget,
      required this.missingLines,
      required this.document})
      : super._();
  @override
  WorkPackageView rebuild(void Function(WorkPackageViewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageViewBuilder toBuilder() => WorkPackageViewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageView &&
        id == other.id &&
        projectId == other.projectId &&
        projectStatus == other.projectStatus &&
        name == other.name &&
        status == other.status &&
        budgetCentavos == other.budgetCentavos &&
        lockVersion == other.lockVersion &&
        currentVersionId == other.currentVersionId &&
        selectedVendorId == other.selectedVendorId &&
        orderId == other.orderId &&
        version == other.version &&
        versions == other.versions &&
        budget == other.budget &&
        missingLines == other.missingLines &&
        document == other.document;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, projectId.hashCode);
    _$hash = $jc(_$hash, projectStatus.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, currentVersionId.hashCode);
    _$hash = $jc(_$hash, selectedVendorId.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jc(_$hash, budget.hashCode);
    _$hash = $jc(_$hash, missingLines.hashCode);
    _$hash = $jc(_$hash, document.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageView')
          ..add('id', id)
          ..add('projectId', projectId)
          ..add('projectStatus', projectStatus)
          ..add('name', name)
          ..add('status', status)
          ..add('budgetCentavos', budgetCentavos)
          ..add('lockVersion', lockVersion)
          ..add('currentVersionId', currentVersionId)
          ..add('selectedVendorId', selectedVendorId)
          ..add('orderId', orderId)
          ..add('version', version)
          ..add('versions', versions)
          ..add('budget', budget)
          ..add('missingLines', missingLines)
          ..add('document', document))
        .toString();
  }
}

class WorkPackageViewBuilder
    implements Builder<WorkPackageView, WorkPackageViewBuilder> {
  _$WorkPackageView? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _projectId;
  String? get projectId => _$this._projectId;
  set projectId(String? projectId) => _$this._projectId = projectId;

  WorkPackageViewProjectStatusEnum? _projectStatus;
  WorkPackageViewProjectStatusEnum? get projectStatus => _$this._projectStatus;
  set projectStatus(WorkPackageViewProjectStatusEnum? projectStatus) =>
      _$this._projectStatus = projectStatus;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  int? _budgetCentavos;
  int? get budgetCentavos => _$this._budgetCentavos;
  set budgetCentavos(int? budgetCentavos) =>
      _$this._budgetCentavos = budgetCentavos;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _currentVersionId;
  String? get currentVersionId => _$this._currentVersionId;
  set currentVersionId(String? currentVersionId) =>
      _$this._currentVersionId = currentVersionId;

  String? _selectedVendorId;
  String? get selectedVendorId => _$this._selectedVendorId;
  set selectedVendorId(String? selectedVendorId) =>
      _$this._selectedVendorId = selectedVendorId;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  WorkPackageVersionBuilder? _version;
  WorkPackageVersionBuilder get version =>
      _$this._version ??= WorkPackageVersionBuilder();
  set version(WorkPackageVersionBuilder? version) => _$this._version = version;

  WorkPackageVersionPageBuilder? _versions;
  WorkPackageVersionPageBuilder get versions =>
      _$this._versions ??= WorkPackageVersionPageBuilder();
  set versions(WorkPackageVersionPageBuilder? versions) =>
      _$this._versions = versions;

  ProjectBudgetBuilder? _budget;
  ProjectBudgetBuilder get budget => _$this._budget ??= ProjectBudgetBuilder();
  set budget(ProjectBudgetBuilder? budget) => _$this._budget = budget;

  ListBuilder<BuiltMap<String, JsonObject?>>? _missingLines;
  ListBuilder<BuiltMap<String, JsonObject?>> get missingLines =>
      _$this._missingLines ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set missingLines(ListBuilder<BuiltMap<String, JsonObject?>>? missingLines) =>
      _$this._missingLines = missingLines;

  MapBuilder<String, JsonObject?>? _document;
  MapBuilder<String, JsonObject?> get document =>
      _$this._document ??= MapBuilder<String, JsonObject?>();
  set document(MapBuilder<String, JsonObject?>? document) =>
      _$this._document = document;

  WorkPackageViewBuilder() {
    WorkPackageView._defaults(this);
  }

  WorkPackageViewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _projectId = $v.projectId;
      _projectStatus = $v.projectStatus;
      _name = $v.name;
      _status = $v.status;
      _budgetCentavos = $v.budgetCentavos;
      _lockVersion = $v.lockVersion;
      _currentVersionId = $v.currentVersionId;
      _selectedVendorId = $v.selectedVendorId;
      _orderId = $v.orderId;
      _version = $v.version?.toBuilder();
      _versions = $v.versions.toBuilder();
      _budget = $v.budget.toBuilder();
      _missingLines = $v.missingLines.toBuilder();
      _document = $v.document.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageView other) {
    _$v = other as _$WorkPackageView;
  }

  @override
  void update(void Function(WorkPackageViewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageView build() => _build();

  _$WorkPackageView _build() {
    _$WorkPackageView _$result;
    try {
      _$result = _$v ??
          _$WorkPackageView._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WorkPackageView', 'id'),
            projectId: BuiltValueNullFieldError.checkNotNull(
                projectId, r'WorkPackageView', 'projectId'),
            projectStatus: BuiltValueNullFieldError.checkNotNull(
                projectStatus, r'WorkPackageView', 'projectStatus'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'WorkPackageView', 'name'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WorkPackageView', 'status'),
            budgetCentavos: BuiltValueNullFieldError.checkNotNull(
                budgetCentavos, r'WorkPackageView', 'budgetCentavos'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'WorkPackageView', 'lockVersion'),
            currentVersionId: currentVersionId,
            selectedVendorId: selectedVendorId,
            orderId: orderId,
            version: _version?.build(),
            versions: versions.build(),
            budget: budget.build(),
            missingLines: missingLines.build(),
            document: document.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'version';
        _version?.build();
        _$failedField = 'versions';
        versions.build();
        _$failedField = 'budget';
        budget.build();
        _$failedField = 'missingLines';
        missingLines.build();
        _$failedField = 'document';
        document.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageView', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
