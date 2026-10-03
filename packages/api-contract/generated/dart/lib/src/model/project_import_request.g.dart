// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_import_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectImportRequest extends ProjectImportRequest {
  @override
  final String csv;

  factory _$ProjectImportRequest(
          [void Function(ProjectImportRequestBuilder)? updates]) =>
      (ProjectImportRequestBuilder()..update(updates))._build();

  _$ProjectImportRequest._({required this.csv}) : super._();
  @override
  ProjectImportRequest rebuild(
          void Function(ProjectImportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectImportRequestBuilder toBuilder() =>
      ProjectImportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectImportRequest && csv == other.csv;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, csv.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectImportRequest')
          ..add('csv', csv))
        .toString();
  }
}

class ProjectImportRequestBuilder
    implements Builder<ProjectImportRequest, ProjectImportRequestBuilder> {
  _$ProjectImportRequest? _$v;

  String? _csv;
  String? get csv => _$this._csv;
  set csv(String? csv) => _$this._csv = csv;

  ProjectImportRequestBuilder() {
    ProjectImportRequest._defaults(this);
  }

  ProjectImportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _csv = $v.csv;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectImportRequest other) {
    _$v = other as _$ProjectImportRequest;
  }

  @override
  void update(void Function(ProjectImportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectImportRequest build() => _build();

  _$ProjectImportRequest _build() {
    final _$result = _$v ??
        _$ProjectImportRequest._(
          csv: BuiltValueNullFieldError.checkNotNull(
              csv, r'ProjectImportRequest', 'csv'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
