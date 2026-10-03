// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_import_preview_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectImportPreviewResponse extends ProjectImportPreviewResponse {
  @override
  final ProjectImportPreview data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectImportPreviewResponse(
          [void Function(ProjectImportPreviewResponseBuilder)? updates]) =>
      (ProjectImportPreviewResponseBuilder()..update(updates))._build();

  _$ProjectImportPreviewResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectImportPreviewResponse rebuild(
          void Function(ProjectImportPreviewResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectImportPreviewResponseBuilder toBuilder() =>
      ProjectImportPreviewResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectImportPreviewResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectImportPreviewResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectImportPreviewResponseBuilder
    implements
        Builder<ProjectImportPreviewResponse,
            ProjectImportPreviewResponseBuilder> {
  _$ProjectImportPreviewResponse? _$v;

  ProjectImportPreviewBuilder? _data;
  ProjectImportPreviewBuilder get data =>
      _$this._data ??= ProjectImportPreviewBuilder();
  set data(ProjectImportPreviewBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectImportPreviewResponseBuilder() {
    ProjectImportPreviewResponse._defaults(this);
  }

  ProjectImportPreviewResponseBuilder get _$this {
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
  void replace(ProjectImportPreviewResponse other) {
    _$v = other as _$ProjectImportPreviewResponse;
  }

  @override
  void update(void Function(ProjectImportPreviewResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectImportPreviewResponse build() => _build();

  _$ProjectImportPreviewResponse _build() {
    _$ProjectImportPreviewResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectImportPreviewResponse._(
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
            r'ProjectImportPreviewResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
