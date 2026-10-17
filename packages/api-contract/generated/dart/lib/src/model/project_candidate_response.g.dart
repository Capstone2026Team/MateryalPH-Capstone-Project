// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_candidate_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectCandidateResponse extends ProjectCandidateResponse {
  @override
  final ProjectCandidate data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectCandidateResponse(
          [void Function(ProjectCandidateResponseBuilder)? updates]) =>
      (ProjectCandidateResponseBuilder()..update(updates))._build();

  _$ProjectCandidateResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectCandidateResponse rebuild(
          void Function(ProjectCandidateResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectCandidateResponseBuilder toBuilder() =>
      ProjectCandidateResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectCandidateResponse &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectCandidateResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectCandidateResponseBuilder
    implements
        Builder<ProjectCandidateResponse, ProjectCandidateResponseBuilder> {
  _$ProjectCandidateResponse? _$v;

  ProjectCandidateBuilder? _data;
  ProjectCandidateBuilder get data =>
      _$this._data ??= ProjectCandidateBuilder();
  set data(ProjectCandidateBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectCandidateResponseBuilder() {
    ProjectCandidateResponse._defaults(this);
  }

  ProjectCandidateResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectCandidateResponse other) {
    _$v = other as _$ProjectCandidateResponse;
  }

  @override
  void update(void Function(ProjectCandidateResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectCandidateResponse build() => _build();

  _$ProjectCandidateResponse _build() {
    _$ProjectCandidateResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectCandidateResponse._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectCandidateResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
