// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_selection_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectSelectionPreview extends ProjectSelectionPreview {
  @override
  final BuiltList<ProjectSpecificationSelection>? selections;

  factory _$ProjectSelectionPreview(
          [void Function(ProjectSelectionPreviewBuilder)? updates]) =>
      (ProjectSelectionPreviewBuilder()..update(updates))._build();

  _$ProjectSelectionPreview._({this.selections}) : super._();
  @override
  ProjectSelectionPreview rebuild(
          void Function(ProjectSelectionPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectSelectionPreviewBuilder toBuilder() =>
      ProjectSelectionPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectSelectionPreview && selections == other.selections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, selections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectSelectionPreview')
          ..add('selections', selections))
        .toString();
  }
}

class ProjectSelectionPreviewBuilder
    implements
        Builder<ProjectSelectionPreview, ProjectSelectionPreviewBuilder> {
  _$ProjectSelectionPreview? _$v;

  ListBuilder<ProjectSpecificationSelection>? _selections;
  ListBuilder<ProjectSpecificationSelection> get selections =>
      _$this._selections ??= ListBuilder<ProjectSpecificationSelection>();
  set selections(ListBuilder<ProjectSpecificationSelection>? selections) =>
      _$this._selections = selections;

  ProjectSelectionPreviewBuilder() {
    ProjectSelectionPreview._defaults(this);
  }

  ProjectSelectionPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _selections = $v.selections?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectSelectionPreview other) {
    _$v = other as _$ProjectSelectionPreview;
  }

  @override
  void update(void Function(ProjectSelectionPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectSelectionPreview build() => _build();

  _$ProjectSelectionPreview _build() {
    _$ProjectSelectionPreview _$result;
    try {
      _$result = _$v ??
          _$ProjectSelectionPreview._(
            selections: _selections?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selections';
        _selections?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectSelectionPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
