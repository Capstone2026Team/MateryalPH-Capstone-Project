// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_view.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectView extends ProjectView {
  @override
  final DateTime? archivedAt;
  @override
  final DateTime? deleteAfter;
  @override
  final bool? canArchive;
  @override
  final String? archiveBlocker;
  @override
  final String id;
  @override
  final String name;
  @override
  final String status;
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
  @override
  final BuiltList<ProjectSite> sites;
  @override
  final WorkPackagePage packages;

  factory _$ProjectView([void Function(ProjectViewBuilder)? updates]) =>
      (ProjectViewBuilder()..update(updates))._build();

  _$ProjectView._(
      {this.archivedAt,
      this.deleteAfter,
      this.canArchive,
      this.archiveBlocker,
      required this.id,
      required this.name,
      required this.status,
      required this.budgetCentavos,
      this.startsOn,
      this.endsOn,
      required this.lockVersion,
      required this.budget,
      required this.sites,
      required this.packages})
      : super._();
  @override
  ProjectView rebuild(void Function(ProjectViewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectViewBuilder toBuilder() => ProjectViewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectView &&
        archivedAt == other.archivedAt &&
        deleteAfter == other.deleteAfter &&
        canArchive == other.canArchive &&
        archiveBlocker == other.archiveBlocker &&
        id == other.id &&
        name == other.name &&
        status == other.status &&
        budgetCentavos == other.budgetCentavos &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn &&
        lockVersion == other.lockVersion &&
        budget == other.budget &&
        sites == other.sites &&
        packages == other.packages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, archivedAt.hashCode);
    _$hash = $jc(_$hash, deleteAfter.hashCode);
    _$hash = $jc(_$hash, canArchive.hashCode);
    _$hash = $jc(_$hash, archiveBlocker.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, budget.hashCode);
    _$hash = $jc(_$hash, sites.hashCode);
    _$hash = $jc(_$hash, packages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectView')
          ..add('archivedAt', archivedAt)
          ..add('deleteAfter', deleteAfter)
          ..add('canArchive', canArchive)
          ..add('archiveBlocker', archiveBlocker)
          ..add('id', id)
          ..add('name', name)
          ..add('status', status)
          ..add('budgetCentavos', budgetCentavos)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn)
          ..add('lockVersion', lockVersion)
          ..add('budget', budget)
          ..add('sites', sites)
          ..add('packages', packages))
        .toString();
  }
}

class ProjectViewBuilder implements Builder<ProjectView, ProjectViewBuilder> {
  _$ProjectView? _$v;

  DateTime? _archivedAt;
  DateTime? get archivedAt => _$this._archivedAt;
  set archivedAt(DateTime? archivedAt) => _$this._archivedAt = archivedAt;

  DateTime? _deleteAfter;
  DateTime? get deleteAfter => _$this._deleteAfter;
  set deleteAfter(DateTime? deleteAfter) => _$this._deleteAfter = deleteAfter;

  bool? _canArchive;
  bool? get canArchive => _$this._canArchive;
  set canArchive(bool? canArchive) => _$this._canArchive = canArchive;

  String? _archiveBlocker;
  String? get archiveBlocker => _$this._archiveBlocker;
  set archiveBlocker(String? archiveBlocker) =>
      _$this._archiveBlocker = archiveBlocker;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  ListBuilder<ProjectSite>? _sites;
  ListBuilder<ProjectSite> get sites =>
      _$this._sites ??= ListBuilder<ProjectSite>();
  set sites(ListBuilder<ProjectSite>? sites) => _$this._sites = sites;

  WorkPackagePageBuilder? _packages;
  WorkPackagePageBuilder get packages =>
      _$this._packages ??= WorkPackagePageBuilder();
  set packages(WorkPackagePageBuilder? packages) => _$this._packages = packages;

  ProjectViewBuilder() {
    ProjectView._defaults(this);
  }

  ProjectViewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _archivedAt = $v.archivedAt;
      _deleteAfter = $v.deleteAfter;
      _canArchive = $v.canArchive;
      _archiveBlocker = $v.archiveBlocker;
      _id = $v.id;
      _name = $v.name;
      _status = $v.status;
      _budgetCentavos = $v.budgetCentavos;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _lockVersion = $v.lockVersion;
      _budget = $v.budget.toBuilder();
      _sites = $v.sites.toBuilder();
      _packages = $v.packages.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectView other) {
    _$v = other as _$ProjectView;
  }

  @override
  void update(void Function(ProjectViewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectView build() => _build();

  _$ProjectView _build() {
    _$ProjectView _$result;
    try {
      _$result = _$v ??
          _$ProjectView._(
            archivedAt: archivedAt,
            deleteAfter: deleteAfter,
            canArchive: canArchive,
            archiveBlocker: archiveBlocker,
            id: BuiltValueNullFieldError.checkNotNull(id, r'ProjectView', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProjectView', 'name'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProjectView', 'status'),
            budgetCentavos: BuiltValueNullFieldError.checkNotNull(
                budgetCentavos, r'ProjectView', 'budgetCentavos'),
            startsOn: startsOn,
            endsOn: endsOn,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'ProjectView', 'lockVersion'),
            budget: budget.build(),
            sites: sites.build(),
            packages: packages.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'budget';
        budget.build();
        _$failedField = 'sites';
        sites.build();
        _$failedField = 'packages';
        packages.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectView', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
