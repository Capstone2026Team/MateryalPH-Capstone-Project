// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_archive_mutation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArchiveMutation extends ProjectArchiveMutation {
  @override
  final String id;

  factory _$ProjectArchiveMutation(
          [void Function(ProjectArchiveMutationBuilder)? updates]) =>
      (ProjectArchiveMutationBuilder()..update(updates))._build();

  _$ProjectArchiveMutation._({required this.id}) : super._();
  @override
  ProjectArchiveMutation rebuild(
          void Function(ProjectArchiveMutationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArchiveMutationBuilder toBuilder() =>
      ProjectArchiveMutationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArchiveMutation && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArchiveMutation')
          ..add('id', id))
        .toString();
  }
}

class ProjectArchiveMutationBuilder
    implements Builder<ProjectArchiveMutation, ProjectArchiveMutationBuilder> {
  _$ProjectArchiveMutation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ProjectArchiveMutationBuilder() {
    ProjectArchiveMutation._defaults(this);
  }

  ProjectArchiveMutationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArchiveMutation other) {
    _$v = other as _$ProjectArchiveMutation;
  }

  @override
  void update(void Function(ProjectArchiveMutationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArchiveMutation build() => _build();

  _$ProjectArchiveMutation _build() {
    final _$result = _$v ??
        _$ProjectArchiveMutation._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProjectArchiveMutation', 'id'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
