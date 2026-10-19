// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArrangementPageResponse extends ProjectArrangementPageResponse {
  @override
  final ProjectArrangementPage data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectArrangementPageResponse(
          [void Function(ProjectArrangementPageResponseBuilder)? updates]) =>
      (ProjectArrangementPageResponseBuilder()..update(updates))._build();

  _$ProjectArrangementPageResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectArrangementPageResponse rebuild(
          void Function(ProjectArrangementPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementPageResponseBuilder toBuilder() =>
      ProjectArrangementPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementPageResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectArrangementPageResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectArrangementPageResponseBuilder
    implements
        Builder<ProjectArrangementPageResponse,
            ProjectArrangementPageResponseBuilder> {
  _$ProjectArrangementPageResponse? _$v;

  ProjectArrangementPageBuilder? _data;
  ProjectArrangementPageBuilder get data =>
      _$this._data ??= ProjectArrangementPageBuilder();
  set data(ProjectArrangementPageBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectArrangementPageResponseBuilder() {
    ProjectArrangementPageResponse._defaults(this);
  }

  ProjectArrangementPageResponseBuilder get _$this {
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
  void replace(ProjectArrangementPageResponse other) {
    _$v = other as _$ProjectArrangementPageResponse;
  }

  @override
  void update(void Function(ProjectArrangementPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementPageResponse build() => _build();

  _$ProjectArrangementPageResponse _build() {
    _$ProjectArrangementPageResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectArrangementPageResponse._(
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
            r'ProjectArrangementPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
