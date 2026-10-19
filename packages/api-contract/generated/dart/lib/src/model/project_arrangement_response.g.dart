// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArrangementResponse extends ProjectArrangementResponse {
  @override
  final ProjectArrangement data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ProjectArrangementResponse(
          [void Function(ProjectArrangementResponseBuilder)? updates]) =>
      (ProjectArrangementResponseBuilder()..update(updates))._build();

  _$ProjectArrangementResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProjectArrangementResponse rebuild(
          void Function(ProjectArrangementResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementResponseBuilder toBuilder() =>
      ProjectArrangementResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementResponse &&
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
    return (newBuiltValueToStringHelper(r'ProjectArrangementResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProjectArrangementResponseBuilder
    implements
        Builder<ProjectArrangementResponse, ProjectArrangementResponseBuilder> {
  _$ProjectArrangementResponse? _$v;

  ProjectArrangementBuilder? _data;
  ProjectArrangementBuilder get data =>
      _$this._data ??= ProjectArrangementBuilder();
  set data(ProjectArrangementBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ProjectArrangementResponseBuilder() {
    ProjectArrangementResponse._defaults(this);
  }

  ProjectArrangementResponseBuilder get _$this {
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
  void replace(ProjectArrangementResponse other) {
    _$v = other as _$ProjectArrangementResponse;
  }

  @override
  void update(void Function(ProjectArrangementResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementResponse build() => _build();

  _$ProjectArrangementResponse _build() {
    _$ProjectArrangementResponse _$result;
    try {
      _$result = _$v ??
          _$ProjectArrangementResponse._(
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
            r'ProjectArrangementResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
