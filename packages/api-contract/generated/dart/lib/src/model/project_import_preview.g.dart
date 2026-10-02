// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_import_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectImportPreview extends ProjectImportPreview {
  @override
  final BuiltList<WorkPackageLineInput> lines;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> validationErrors;
  @override
  final bool valid;

  factory _$ProjectImportPreview(
          [void Function(ProjectImportPreviewBuilder)? updates]) =>
      (ProjectImportPreviewBuilder()..update(updates))._build();

  _$ProjectImportPreview._(
      {required this.lines,
      required this.validationErrors,
      required this.valid})
      : super._();
  @override
  ProjectImportPreview rebuild(
          void Function(ProjectImportPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectImportPreviewBuilder toBuilder() =>
      ProjectImportPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectImportPreview &&
        lines == other.lines &&
        validationErrors == other.validationErrors &&
        valid == other.valid;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, validationErrors.hashCode);
    _$hash = $jc(_$hash, valid.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectImportPreview')
          ..add('lines', lines)
          ..add('validationErrors', validationErrors)
          ..add('valid', valid))
        .toString();
  }
}

class ProjectImportPreviewBuilder
    implements Builder<ProjectImportPreview, ProjectImportPreviewBuilder> {
  _$ProjectImportPreview? _$v;

  ListBuilder<WorkPackageLineInput>? _lines;
  ListBuilder<WorkPackageLineInput> get lines =>
      _$this._lines ??= ListBuilder<WorkPackageLineInput>();
  set lines(ListBuilder<WorkPackageLineInput>? lines) => _$this._lines = lines;

  ListBuilder<BuiltMap<String, JsonObject?>>? _validationErrors;
  ListBuilder<BuiltMap<String, JsonObject?>> get validationErrors =>
      _$this._validationErrors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set validationErrors(
          ListBuilder<BuiltMap<String, JsonObject?>>? validationErrors) =>
      _$this._validationErrors = validationErrors;

  bool? _valid;
  bool? get valid => _$this._valid;
  set valid(bool? valid) => _$this._valid = valid;

  ProjectImportPreviewBuilder() {
    ProjectImportPreview._defaults(this);
  }

  ProjectImportPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _validationErrors = $v.validationErrors.toBuilder();
      _valid = $v.valid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectImportPreview other) {
    _$v = other as _$ProjectImportPreview;
  }

  @override
  void update(void Function(ProjectImportPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectImportPreview build() => _build();

  _$ProjectImportPreview _build() {
    _$ProjectImportPreview _$result;
    try {
      _$result = _$v ??
          _$ProjectImportPreview._(
            lines: lines.build(),
            validationErrors: validationErrors.build(),
            valid: BuiltValueNullFieldError.checkNotNull(
                valid, r'ProjectImportPreview', 'valid'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'validationErrors';
        validationErrors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectImportPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
