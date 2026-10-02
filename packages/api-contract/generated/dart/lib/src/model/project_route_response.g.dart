// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_route_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectRouteResponse extends ProjectRouteResponse {
  @override
  final ProjectRoute data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectRouteResponse(
          [void Function(ProjectRouteResponseBuilder)? updates]) =>
      (ProjectRouteResponseBuilder()..update(updates))._build();

  _$ProjectRouteResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectRouteResponse rebuild(
          void Function(ProjectRouteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectRouteResponseBuilder toBuilder() =>
      ProjectRouteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectRouteResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectRouteResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectRouteResponseBuilder
    implements Builder<ProjectRouteResponse, ProjectRouteResponseBuilder> {
  _$ProjectRouteResponse? _$v;

  ProjectRouteBuilder? _data;
  ProjectRouteBuilder get data => _$this._data ??= ProjectRouteBuilder();
  set data(ProjectRouteBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectRouteResponseBuilder() {
    ProjectRouteResponse._defaults(this);
  }

  ProjectRouteResponseBuilder get _$this {
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
  void replace(ProjectRouteResponse other) {
    _$v = other as _$ProjectRouteResponse;
  }

  @override
  void update(void Function(ProjectRouteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectRouteResponse build() => _build();

  _$ProjectRouteResponse _build() {
    _$ProjectRouteResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectRouteResponse._(
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
            r'ProjectRouteResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
