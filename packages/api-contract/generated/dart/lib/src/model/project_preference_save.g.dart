// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_preference_save.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectPreferenceSave extends ProjectPreferenceSave {
  @override
  final int version;
  @override
  final BuiltMap<String, JsonObject?> weights;

  factory _$ProjectPreferenceSave(
          [void Function(ProjectPreferenceSaveBuilder)? updates]) =>
      (ProjectPreferenceSaveBuilder()..update(updates))._build();

  _$ProjectPreferenceSave._({required this.version, required this.weights})
      : super._();
  @override
  ProjectPreferenceSave rebuild(
          void Function(ProjectPreferenceSaveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectPreferenceSaveBuilder toBuilder() =>
      ProjectPreferenceSaveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectPreferenceSave &&
        version == other.version &&
        weights == other.weights;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, weights.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectPreferenceSave')
          ..add('version', version)
          ..add('weights', weights))
        .toString();
  }
}

class ProjectPreferenceSaveBuilder
    implements Builder<ProjectPreferenceSave, ProjectPreferenceSaveBuilder> {
  _$ProjectPreferenceSave? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  MapBuilder<String, JsonObject?>? _weights;
  MapBuilder<String, JsonObject?> get weights =>
      _$this._weights ??= MapBuilder<String, JsonObject?>();
  set weights(MapBuilder<String, JsonObject?>? weights) =>
      _$this._weights = weights;

  ProjectPreferenceSaveBuilder() {
    ProjectPreferenceSave._defaults(this);
  }

  ProjectPreferenceSaveBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _weights = $v.weights.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectPreferenceSave other) {
    _$v = other as _$ProjectPreferenceSave;
  }

  @override
  void update(void Function(ProjectPreferenceSaveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectPreferenceSave build() => _build();

  _$ProjectPreferenceSave _build() {
    _$ProjectPreferenceSave _$result;
    try {
      _$result = _$v ??
          _$ProjectPreferenceSave._(
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ProjectPreferenceSave', 'version'),
            weights: weights.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weights';
        weights.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectPreferenceSave', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
