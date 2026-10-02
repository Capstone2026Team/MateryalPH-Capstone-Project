// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_preferences.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectPreferences extends ProjectPreferences {
  @override
  final BuiltMap<String, JsonObject?> weights;
  @override
  final BuiltMap<String, JsonObject?> defaultWeights;
  @override
  final bool personalized;
  @override
  final int version;
  @override
  final int defaultsVersion;
  @override
  final String algorithmVersion;

  factory _$ProjectPreferences(
          [void Function(ProjectPreferencesBuilder)? updates]) =>
      (ProjectPreferencesBuilder()..update(updates))._build();

  _$ProjectPreferences._(
      {required this.weights,
      required this.defaultWeights,
      required this.personalized,
      required this.version,
      required this.defaultsVersion,
      required this.algorithmVersion})
      : super._();
  @override
  ProjectPreferences rebuild(
          void Function(ProjectPreferencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectPreferencesBuilder toBuilder() =>
      ProjectPreferencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectPreferences &&
        weights == other.weights &&
        defaultWeights == other.defaultWeights &&
        personalized == other.personalized &&
        version == other.version &&
        defaultsVersion == other.defaultsVersion &&
        algorithmVersion == other.algorithmVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weights.hashCode);
    _$hash = $jc(_$hash, defaultWeights.hashCode);
    _$hash = $jc(_$hash, personalized.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, defaultsVersion.hashCode);
    _$hash = $jc(_$hash, algorithmVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectPreferences')
          ..add('weights', weights)
          ..add('defaultWeights', defaultWeights)
          ..add('personalized', personalized)
          ..add('version', version)
          ..add('defaultsVersion', defaultsVersion)
          ..add('algorithmVersion', algorithmVersion))
        .toString();
  }
}

class ProjectPreferencesBuilder
    implements Builder<ProjectPreferences, ProjectPreferencesBuilder> {
  _$ProjectPreferences? _$v;

  MapBuilder<String, JsonObject?>? _weights;
  MapBuilder<String, JsonObject?> get weights =>
      _$this._weights ??= MapBuilder<String, JsonObject?>();
  set weights(MapBuilder<String, JsonObject?>? weights) =>
      _$this._weights = weights;

  MapBuilder<String, JsonObject?>? _defaultWeights;
  MapBuilder<String, JsonObject?> get defaultWeights =>
      _$this._defaultWeights ??= MapBuilder<String, JsonObject?>();
  set defaultWeights(MapBuilder<String, JsonObject?>? defaultWeights) =>
      _$this._defaultWeights = defaultWeights;

  bool? _personalized;
  bool? get personalized => _$this._personalized;
  set personalized(bool? personalized) => _$this._personalized = personalized;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  int? _defaultsVersion;
  int? get defaultsVersion => _$this._defaultsVersion;
  set defaultsVersion(int? defaultsVersion) =>
      _$this._defaultsVersion = defaultsVersion;

  String? _algorithmVersion;
  String? get algorithmVersion => _$this._algorithmVersion;
  set algorithmVersion(String? algorithmVersion) =>
      _$this._algorithmVersion = algorithmVersion;

  ProjectPreferencesBuilder() {
    ProjectPreferences._defaults(this);
  }

  ProjectPreferencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weights = $v.weights.toBuilder();
      _defaultWeights = $v.defaultWeights.toBuilder();
      _personalized = $v.personalized;
      _version = $v.version;
      _defaultsVersion = $v.defaultsVersion;
      _algorithmVersion = $v.algorithmVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectPreferences other) {
    _$v = other as _$ProjectPreferences;
  }

  @override
  void update(void Function(ProjectPreferencesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectPreferences build() => _build();

  _$ProjectPreferences _build() {
    _$ProjectPreferences _$result;
    try {
      _$result = _$v ??
          _$ProjectPreferences._(
            weights: weights.build(),
            defaultWeights: defaultWeights.build(),
            personalized: BuiltValueNullFieldError.checkNotNull(
                personalized, r'ProjectPreferences', 'personalized'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ProjectPreferences', 'version'),
            defaultsVersion: BuiltValueNullFieldError.checkNotNull(
                defaultsVersion, r'ProjectPreferences', 'defaultsVersion'),
            algorithmVersion: BuiltValueNullFieldError.checkNotNull(
                algorithmVersion, r'ProjectPreferences', 'algorithmVersion'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weights';
        weights.build();
        _$failedField = 'defaultWeights';
        defaultWeights.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectPreferences', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
