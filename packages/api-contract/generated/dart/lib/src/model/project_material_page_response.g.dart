// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_material_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectMaterialPageResponse extends ProjectMaterialPageResponse {
  @override
  final ProjectMaterialPage data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectMaterialPageResponse(
          [void Function(ProjectMaterialPageResponseBuilder)? updates]) =>
      (ProjectMaterialPageResponseBuilder()..update(updates))._build();

  _$ProjectMaterialPageResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectMaterialPageResponse rebuild(
          void Function(ProjectMaterialPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectMaterialPageResponseBuilder toBuilder() =>
      ProjectMaterialPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectMaterialPageResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectMaterialPageResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectMaterialPageResponseBuilder
    implements
        Builder<ProjectMaterialPageResponse,
            ProjectMaterialPageResponseBuilder> {
  _$ProjectMaterialPageResponse? _$v;

  ProjectMaterialPageBuilder? _data;
  ProjectMaterialPageBuilder get data =>
      _$this._data ??= ProjectMaterialPageBuilder();
  set data(ProjectMaterialPageBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectMaterialPageResponseBuilder() {
    ProjectMaterialPageResponse._defaults(this);
  }

  ProjectMaterialPageResponseBuilder get _$this {
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
  void replace(ProjectMaterialPageResponse other) {
    _$v = other as _$ProjectMaterialPageResponse;
  }

  @override
  void update(void Function(ProjectMaterialPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectMaterialPageResponse build() => _build();

  _$ProjectMaterialPageResponse _build() {
    _$ProjectMaterialPageResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectMaterialPageResponse._(
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
            r'ProjectMaterialPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
