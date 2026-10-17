// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_specification_selection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectSpecificationSelection extends ProjectSpecificationSelection {
  @override
  final String lineId;
  @override
  final String optionId;

  factory _$ProjectSpecificationSelection(
          [void Function(ProjectSpecificationSelectionBuilder)? updates]) =>
      (ProjectSpecificationSelectionBuilder()..update(updates))._build();

  _$ProjectSpecificationSelection._(
      {required this.lineId, required this.optionId})
      : super._();
  @override
  ProjectSpecificationSelection rebuild(
          void Function(ProjectSpecificationSelectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectSpecificationSelectionBuilder toBuilder() =>
      ProjectSpecificationSelectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectSpecificationSelection &&
        lineId == other.lineId &&
        optionId == other.optionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lineId.hashCode);
    _$hash = $jc(_$hash, optionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectSpecificationSelection')
          ..add('lineId', lineId)
          ..add('optionId', optionId))
        .toString();
  }
}

class ProjectSpecificationSelectionBuilder
    implements
        Builder<ProjectSpecificationSelection,
            ProjectSpecificationSelectionBuilder> {
  _$ProjectSpecificationSelection? _$v;

  String? _lineId;
  String? get lineId => _$this._lineId;
  set lineId(String? lineId) => _$this._lineId = lineId;

  String? _optionId;
  String? get optionId => _$this._optionId;
  set optionId(String? optionId) => _$this._optionId = optionId;

  ProjectSpecificationSelectionBuilder() {
    ProjectSpecificationSelection._defaults(this);
  }

  ProjectSpecificationSelectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lineId = $v.lineId;
      _optionId = $v.optionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectSpecificationSelection other) {
    _$v = other as _$ProjectSpecificationSelection;
  }

  @override
  void update(void Function(ProjectSpecificationSelectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectSpecificationSelection build() => _build();

  _$ProjectSpecificationSelection _build() {
    final _$result = _$v ??
        _$ProjectSpecificationSelection._(
          lineId: BuiltValueNullFieldError.checkNotNull(
              lineId, r'ProjectSpecificationSelection', 'lineId'),
          optionId: BuiltValueNullFieldError.checkNotNull(
              optionId, r'ProjectSpecificationSelection', 'optionId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
