// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_preference_reset.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectPreferenceReset extends ProjectPreferenceReset {
  @override
  final int version;

  factory _$ProjectPreferenceReset(
          [void Function(ProjectPreferenceResetBuilder)? updates]) =>
      (ProjectPreferenceResetBuilder()..update(updates))._build();

  _$ProjectPreferenceReset._({required this.version}) : super._();
  @override
  ProjectPreferenceReset rebuild(
          void Function(ProjectPreferenceResetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectPreferenceResetBuilder toBuilder() =>
      ProjectPreferenceResetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectPreferenceReset && version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectPreferenceReset')
          ..add('version', version))
        .toString();
  }
}

class ProjectPreferenceResetBuilder
    implements Builder<ProjectPreferenceReset, ProjectPreferenceResetBuilder> {
  _$ProjectPreferenceReset? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  ProjectPreferenceResetBuilder() {
    ProjectPreferenceReset._defaults(this);
  }

  ProjectPreferenceResetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectPreferenceReset other) {
    _$v = other as _$ProjectPreferenceReset;
  }

  @override
  void update(void Function(ProjectPreferenceResetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectPreferenceReset build() => _build();

  _$ProjectPreferenceReset _build() {
    final _$result = _$v ??
        _$ProjectPreferenceReset._(
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'ProjectPreferenceReset', 'version'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
