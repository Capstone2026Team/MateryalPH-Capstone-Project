// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_candidate_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectCandidateRequest extends ProjectCandidateRequest {
  @override
  final int lockVersion;
  @override
  final String candidateId;
  @override
  final String? note;
  @override
  final String? budgetOverrideReason;

  factory _$ProjectCandidateRequest(
          [void Function(ProjectCandidateRequestBuilder)? updates]) =>
      (ProjectCandidateRequestBuilder()..update(updates))._build();

  _$ProjectCandidateRequest._(
      {required this.lockVersion,
      required this.candidateId,
      this.note,
      this.budgetOverrideReason})
      : super._();
  @override
  ProjectCandidateRequest rebuild(
          void Function(ProjectCandidateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectCandidateRequestBuilder toBuilder() =>
      ProjectCandidateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectCandidateRequest &&
        lockVersion == other.lockVersion &&
        candidateId == other.candidateId &&
        note == other.note &&
        budgetOverrideReason == other.budgetOverrideReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, candidateId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectCandidateRequest')
          ..add('lockVersion', lockVersion)
          ..add('candidateId', candidateId)
          ..add('note', note)
          ..add('budgetOverrideReason', budgetOverrideReason))
        .toString();
  }
}

class ProjectCandidateRequestBuilder
    implements
        Builder<ProjectCandidateRequest, ProjectCandidateRequestBuilder> {
  _$ProjectCandidateRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _candidateId;
  String? get candidateId => _$this._candidateId;
  set candidateId(String? candidateId) => _$this._candidateId = candidateId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  ProjectCandidateRequestBuilder() {
    ProjectCandidateRequest._defaults(this);
  }

  ProjectCandidateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _candidateId = $v.candidateId;
      _note = $v.note;
      _budgetOverrideReason = $v.budgetOverrideReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectCandidateRequest other) {
    _$v = other as _$ProjectCandidateRequest;
  }

  @override
  void update(void Function(ProjectCandidateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectCandidateRequest build() => _build();

  _$ProjectCandidateRequest _build() {
    final _$result = _$v ??
        _$ProjectCandidateRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProjectCandidateRequest', 'lockVersion'),
          candidateId: BuiltValueNullFieldError.checkNotNull(
              candidateId, r'ProjectCandidateRequest', 'candidateId'),
          note: note,
          budgetOverrideReason: budgetOverrideReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
