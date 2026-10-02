// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectPageResponse extends ProjectPageResponse {
  @override
  final ProjectPage data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectPageResponse(
          [void Function(ProjectPageResponseBuilder)? updates]) =>
      (ProjectPageResponseBuilder()..update(updates))._build();

  _$ProjectPageResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectPageResponse rebuild(
          void Function(ProjectPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectPageResponseBuilder toBuilder() =>
      ProjectPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectPageResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectPageResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectPageResponseBuilder
    implements Builder<ProjectPageResponse, ProjectPageResponseBuilder> {
  _$ProjectPageResponse? _$v;

  ProjectPageBuilder? _data;
  ProjectPageBuilder get data => _$this._data ??= ProjectPageBuilder();
  set data(ProjectPageBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectPageResponseBuilder() {
    ProjectPageResponse._defaults(this);
  }

  ProjectPageResponseBuilder get _$this {
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
  void replace(ProjectPageResponse other) {
    _$v = other as _$ProjectPageResponse;
  }

  @override
  void update(void Function(ProjectPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectPageResponse build() => _build();

  _$ProjectPageResponse _build() {
    _$ProjectPageResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectPageResponse._(
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
            r'ProjectPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
