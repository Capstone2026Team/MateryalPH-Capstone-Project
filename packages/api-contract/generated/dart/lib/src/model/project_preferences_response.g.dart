// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_preferences_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectPreferencesResponse extends ProjectPreferencesResponse {
  @override
  final ProjectPreferences data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectPreferencesResponse(
          [void Function(ProjectPreferencesResponseBuilder)? updates]) =>
      (ProjectPreferencesResponseBuilder()..update(updates))._build();

  _$ProjectPreferencesResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectPreferencesResponse rebuild(
          void Function(ProjectPreferencesResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectPreferencesResponseBuilder toBuilder() =>
      ProjectPreferencesResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectPreferencesResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectPreferencesResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectPreferencesResponseBuilder
    implements
        Builder<ProjectPreferencesResponse, ProjectPreferencesResponseBuilder> {
  _$ProjectPreferencesResponse? _$v;

  ProjectPreferencesBuilder? _data;
  ProjectPreferencesBuilder get data =>
      _$this._data ??= ProjectPreferencesBuilder();
  set data(ProjectPreferencesBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectPreferencesResponseBuilder() {
    ProjectPreferencesResponse._defaults(this);
  }

  ProjectPreferencesResponseBuilder get _$this {
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
  void replace(ProjectPreferencesResponse other) {
    _$v = other as _$ProjectPreferencesResponse;
  }

  @override
  void update(void Function(ProjectPreferencesResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectPreferencesResponse build() => _build();

  _$ProjectPreferencesResponse _build() {
    _$ProjectPreferencesResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectPreferencesResponse._(
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
            r'ProjectPreferencesResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
