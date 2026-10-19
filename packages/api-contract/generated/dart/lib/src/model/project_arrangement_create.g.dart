// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArrangementCreate extends ProjectArrangementCreate {
  @override
  final String? proposalToken;
  @override
  final String sourceCandidateId;

  factory _$ProjectArrangementCreate(
          [void Function(ProjectArrangementCreateBuilder)? updates]) =>
      (ProjectArrangementCreateBuilder()..update(updates))._build();

  _$ProjectArrangementCreate._(
      {this.proposalToken, required this.sourceCandidateId})
      : super._();
  @override
  ProjectArrangementCreate rebuild(
          void Function(ProjectArrangementCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementCreateBuilder toBuilder() =>
      ProjectArrangementCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementCreate &&
        proposalToken == other.proposalToken &&
        sourceCandidateId == other.sourceCandidateId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, proposalToken.hashCode);
    _$hash = $jc(_$hash, sourceCandidateId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArrangementCreate')
          ..add('proposalToken', proposalToken)
          ..add('sourceCandidateId', sourceCandidateId))
        .toString();
  }
}

class ProjectArrangementCreateBuilder
    implements
        Builder<ProjectArrangementCreate, ProjectArrangementCreateBuilder> {
  _$ProjectArrangementCreate? _$v;

  String? _proposalToken;
  String? get proposalToken => _$this._proposalToken;
  set proposalToken(String? proposalToken) =>
      _$this._proposalToken = proposalToken;

  String? _sourceCandidateId;
  String? get sourceCandidateId => _$this._sourceCandidateId;
  set sourceCandidateId(String? sourceCandidateId) =>
      _$this._sourceCandidateId = sourceCandidateId;

  ProjectArrangementCreateBuilder() {
    ProjectArrangementCreate._defaults(this);
  }

  ProjectArrangementCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _proposalToken = $v.proposalToken;
      _sourceCandidateId = $v.sourceCandidateId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArrangementCreate other) {
    _$v = other as _$ProjectArrangementCreate;
  }

  @override
  void update(void Function(ProjectArrangementCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementCreate build() => _build();

  _$ProjectArrangementCreate _build() {
    final _$result = _$v ??
        _$ProjectArrangementCreate._(
          proposalToken: proposalToken,
          sourceCandidateId: BuiltValueNullFieldError.checkNotNull(
              sourceCandidateId,
              r'ProjectArrangementCreate',
              'sourceCandidateId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
