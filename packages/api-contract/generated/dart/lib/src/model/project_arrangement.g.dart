// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArrangement extends ProjectArrangement {
  @override
  final BuiltMap<String, JsonObject?> fms;
  @override
  final int? rank;
  @override
  final String? proposalToken;
  @override
  final String id;
  @override
  final String sourceCandidateId;
  @override
  final int version;
  @override
  final String workPackageVersionId;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> vendors;
  @override
  final int vendorCount;
  @override
  final BuiltMap<String, JsonObject?> coverage;
  @override
  final int materialsCentavos;
  @override
  final int? deliveryCentavos;
  @override
  final int? totalCentavos;
  @override
  final String budgetLabel;
  @override
  final String fingerprint;
  @override
  final BuiltList<String> issues;
  @override
  final bool submitted;
  @override
  final bool stale;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> previousVendors;

  factory _$ProjectArrangement(
          [void Function(ProjectArrangementBuilder)? updates]) =>
      (ProjectArrangementBuilder()..update(updates))._build();

  _$ProjectArrangement._(
      {required this.fms,
      this.rank,
      this.proposalToken,
      required this.id,
      required this.sourceCandidateId,
      required this.version,
      required this.workPackageVersionId,
      required this.vendors,
      required this.vendorCount,
      required this.coverage,
      required this.materialsCentavos,
      this.deliveryCentavos,
      this.totalCentavos,
      required this.budgetLabel,
      required this.fingerprint,
      required this.issues,
      required this.submitted,
      required this.stale,
      required this.previousVendors})
      : super._();
  @override
  ProjectArrangement rebuild(
          void Function(ProjectArrangementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementBuilder toBuilder() =>
      ProjectArrangementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangement &&
        fms == other.fms &&
        rank == other.rank &&
        proposalToken == other.proposalToken &&
        id == other.id &&
        sourceCandidateId == other.sourceCandidateId &&
        version == other.version &&
        workPackageVersionId == other.workPackageVersionId &&
        vendors == other.vendors &&
        vendorCount == other.vendorCount &&
        coverage == other.coverage &&
        materialsCentavos == other.materialsCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        totalCentavos == other.totalCentavos &&
        budgetLabel == other.budgetLabel &&
        fingerprint == other.fingerprint &&
        issues == other.issues &&
        submitted == other.submitted &&
        stale == other.stale &&
        previousVendors == other.previousVendors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fms.hashCode);
    _$hash = $jc(_$hash, rank.hashCode);
    _$hash = $jc(_$hash, proposalToken.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sourceCandidateId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, workPackageVersionId.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, coverage.hashCode);
    _$hash = $jc(_$hash, materialsCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, totalCentavos.hashCode);
    _$hash = $jc(_$hash, budgetLabel.hashCode);
    _$hash = $jc(_$hash, fingerprint.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jc(_$hash, submitted.hashCode);
    _$hash = $jc(_$hash, stale.hashCode);
    _$hash = $jc(_$hash, previousVendors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArrangement')
          ..add('fms', fms)
          ..add('rank', rank)
          ..add('proposalToken', proposalToken)
          ..add('id', id)
          ..add('sourceCandidateId', sourceCandidateId)
          ..add('version', version)
          ..add('workPackageVersionId', workPackageVersionId)
          ..add('vendors', vendors)
          ..add('vendorCount', vendorCount)
          ..add('coverage', coverage)
          ..add('materialsCentavos', materialsCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('totalCentavos', totalCentavos)
          ..add('budgetLabel', budgetLabel)
          ..add('fingerprint', fingerprint)
          ..add('issues', issues)
          ..add('submitted', submitted)
          ..add('stale', stale)
          ..add('previousVendors', previousVendors))
        .toString();
  }
}

class ProjectArrangementBuilder
    implements Builder<ProjectArrangement, ProjectArrangementBuilder> {
  _$ProjectArrangement? _$v;

  MapBuilder<String, JsonObject?>? _fms;
  MapBuilder<String, JsonObject?> get fms =>
      _$this._fms ??= MapBuilder<String, JsonObject?>();
  set fms(MapBuilder<String, JsonObject?>? fms) => _$this._fms = fms;

  int? _rank;
  int? get rank => _$this._rank;
  set rank(int? rank) => _$this._rank = rank;

  String? _proposalToken;
  String? get proposalToken => _$this._proposalToken;
  set proposalToken(String? proposalToken) =>
      _$this._proposalToken = proposalToken;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _sourceCandidateId;
  String? get sourceCandidateId => _$this._sourceCandidateId;
  set sourceCandidateId(String? sourceCandidateId) =>
      _$this._sourceCandidateId = sourceCandidateId;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _workPackageVersionId;
  String? get workPackageVersionId => _$this._workPackageVersionId;
  set workPackageVersionId(String? workPackageVersionId) =>
      _$this._workPackageVersionId = workPackageVersionId;

  ListBuilder<BuiltMap<String, JsonObject?>>? _vendors;
  ListBuilder<BuiltMap<String, JsonObject?>> get vendors =>
      _$this._vendors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set vendors(ListBuilder<BuiltMap<String, JsonObject?>>? vendors) =>
      _$this._vendors = vendors;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  MapBuilder<String, JsonObject?>? _coverage;
  MapBuilder<String, JsonObject?> get coverage =>
      _$this._coverage ??= MapBuilder<String, JsonObject?>();
  set coverage(MapBuilder<String, JsonObject?>? coverage) =>
      _$this._coverage = coverage;

  int? _materialsCentavos;
  int? get materialsCentavos => _$this._materialsCentavos;
  set materialsCentavos(int? materialsCentavos) =>
      _$this._materialsCentavos = materialsCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _totalCentavos;
  int? get totalCentavos => _$this._totalCentavos;
  set totalCentavos(int? totalCentavos) =>
      _$this._totalCentavos = totalCentavos;

  String? _budgetLabel;
  String? get budgetLabel => _$this._budgetLabel;
  set budgetLabel(String? budgetLabel) => _$this._budgetLabel = budgetLabel;

  String? _fingerprint;
  String? get fingerprint => _$this._fingerprint;
  set fingerprint(String? fingerprint) => _$this._fingerprint = fingerprint;

  ListBuilder<String>? _issues;
  ListBuilder<String> get issues => _$this._issues ??= ListBuilder<String>();
  set issues(ListBuilder<String>? issues) => _$this._issues = issues;

  bool? _submitted;
  bool? get submitted => _$this._submitted;
  set submitted(bool? submitted) => _$this._submitted = submitted;

  bool? _stale;
  bool? get stale => _$this._stale;
  set stale(bool? stale) => _$this._stale = stale;

  ListBuilder<BuiltMap<String, JsonObject?>>? _previousVendors;
  ListBuilder<BuiltMap<String, JsonObject?>> get previousVendors =>
      _$this._previousVendors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set previousVendors(
          ListBuilder<BuiltMap<String, JsonObject?>>? previousVendors) =>
      _$this._previousVendors = previousVendors;

  ProjectArrangementBuilder() {
    ProjectArrangement._defaults(this);
  }

  ProjectArrangementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fms = $v.fms.toBuilder();
      _rank = $v.rank;
      _proposalToken = $v.proposalToken;
      _id = $v.id;
      _sourceCandidateId = $v.sourceCandidateId;
      _version = $v.version;
      _workPackageVersionId = $v.workPackageVersionId;
      _vendors = $v.vendors.toBuilder();
      _vendorCount = $v.vendorCount;
      _coverage = $v.coverage.toBuilder();
      _materialsCentavos = $v.materialsCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _totalCentavos = $v.totalCentavos;
      _budgetLabel = $v.budgetLabel;
      _fingerprint = $v.fingerprint;
      _issues = $v.issues.toBuilder();
      _submitted = $v.submitted;
      _stale = $v.stale;
      _previousVendors = $v.previousVendors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArrangement other) {
    _$v = other as _$ProjectArrangement;
  }

  @override
  void update(void Function(ProjectArrangementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangement build() => _build();

  _$ProjectArrangement _build() {
    _$ProjectArrangement _$result;
    try {
      _$result = _$v ??
          _$ProjectArrangement._(
            fms: fms.build(),
            rank: rank,
            proposalToken: proposalToken,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProjectArrangement', 'id'),
            sourceCandidateId: BuiltValueNullFieldError.checkNotNull(
                sourceCandidateId, r'ProjectArrangement', 'sourceCandidateId'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ProjectArrangement', 'version'),
            workPackageVersionId: BuiltValueNullFieldError.checkNotNull(
                workPackageVersionId,
                r'ProjectArrangement',
                'workPackageVersionId'),
            vendors: vendors.build(),
            vendorCount: BuiltValueNullFieldError.checkNotNull(
                vendorCount, r'ProjectArrangement', 'vendorCount'),
            coverage: coverage.build(),
            materialsCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsCentavos, r'ProjectArrangement', 'materialsCentavos'),
            deliveryCentavos: deliveryCentavos,
            totalCentavos: totalCentavos,
            budgetLabel: BuiltValueNullFieldError.checkNotNull(
                budgetLabel, r'ProjectArrangement', 'budgetLabel'),
            fingerprint: BuiltValueNullFieldError.checkNotNull(
                fingerprint, r'ProjectArrangement', 'fingerprint'),
            issues: issues.build(),
            submitted: BuiltValueNullFieldError.checkNotNull(
                submitted, r'ProjectArrangement', 'submitted'),
            stale: BuiltValueNullFieldError.checkNotNull(
                stale, r'ProjectArrangement', 'stale'),
            previousVendors: previousVendors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fms';
        fms.build();

        _$failedField = 'vendors';
        vendors.build();

        _$failedField = 'coverage';
        coverage.build();

        _$failedField = 'issues';
        issues.build();

        _$failedField = 'previousVendors';
        previousVendors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectArrangement', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
