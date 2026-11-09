// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_archive_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArchivePageResponse extends ProjectArchivePageResponse {
  @override
  final ProjectArchivePage data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectArchivePageResponse(
          [void Function(ProjectArchivePageResponseBuilder)? updates]) =>
      (ProjectArchivePageResponseBuilder()..update(updates))._build();

  _$ProjectArchivePageResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectArchivePageResponse rebuild(
          void Function(ProjectArchivePageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArchivePageResponseBuilder toBuilder() =>
      ProjectArchivePageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArchivePageResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectArchivePageResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectArchivePageResponseBuilder
    implements
        Builder<ProjectArchivePageResponse, ProjectArchivePageResponseBuilder> {
  _$ProjectArchivePageResponse? _$v;

  ProjectArchivePageBuilder? _data;
  ProjectArchivePageBuilder get data =>
      _$this._data ??= ProjectArchivePageBuilder();
  set data(ProjectArchivePageBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectArchivePageResponseBuilder() {
    ProjectArchivePageResponse._defaults(this);
  }

  ProjectArchivePageResponseBuilder get _$this {
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
  void replace(ProjectArchivePageResponse other) {
    _$v = other as _$ProjectArchivePageResponse;
  }

  @override
  void update(void Function(ProjectArchivePageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArchivePageResponse build() => _build();

  _$ProjectArchivePageResponse _build() {
    _$ProjectArchivePageResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectArchivePageResponse._(
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
            r'ProjectArchivePageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
