// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_archive_mutation_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArchiveMutationResponse extends ProjectArchiveMutationResponse {
  @override
  final ProjectArchiveMutation data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectArchiveMutationResponse(
          [void Function(ProjectArchiveMutationResponseBuilder)? updates]) =>
      (ProjectArchiveMutationResponseBuilder()..update(updates))._build();

  _$ProjectArchiveMutationResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectArchiveMutationResponse rebuild(
          void Function(ProjectArchiveMutationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArchiveMutationResponseBuilder toBuilder() =>
      ProjectArchiveMutationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArchiveMutationResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectArchiveMutationResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectArchiveMutationResponseBuilder
    implements
        Builder<ProjectArchiveMutationResponse,
            ProjectArchiveMutationResponseBuilder> {
  _$ProjectArchiveMutationResponse? _$v;

  ProjectArchiveMutationBuilder? _data;
  ProjectArchiveMutationBuilder get data =>
      _$this._data ??= ProjectArchiveMutationBuilder();
  set data(ProjectArchiveMutationBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectArchiveMutationResponseBuilder() {
    ProjectArchiveMutationResponse._defaults(this);
  }

  ProjectArchiveMutationResponseBuilder get _$this {
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
  void replace(ProjectArchiveMutationResponse other) {
    _$v = other as _$ProjectArchiveMutationResponse;
  }

  @override
  void update(void Function(ProjectArchiveMutationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArchiveMutationResponse build() => _build();

  _$ProjectArchiveMutationResponse _build() {
    _$ProjectArchiveMutationResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectArchiveMutationResponse._(
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
            r'ProjectArchiveMutationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
