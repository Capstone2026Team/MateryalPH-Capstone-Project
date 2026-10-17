// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_scope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoScope extends GeoScope {
  @override
  final String? code;
  @override
  final String name;
  @override
  final String? level;
  @override
  final String levelLabel;
  @override
  final String label;
  @override
  final BuiltList<GeoBreadcrumb> breadcrumbs;
  @override
  final String childrenLabel;
  @override
  final bool drillable;
  @override
  final GeoScopePsgcVersion? psgcVersion;

  factory _$GeoScope([void Function(GeoScopeBuilder)? updates]) =>
      (GeoScopeBuilder()..update(updates))._build();

  _$GeoScope._(
      {this.code,
      required this.name,
      this.level,
      required this.levelLabel,
      required this.label,
      required this.breadcrumbs,
      required this.childrenLabel,
      required this.drillable,
      this.psgcVersion})
      : super._();
  @override
  GeoScope rebuild(void Function(GeoScopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoScopeBuilder toBuilder() => GeoScopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoScope &&
        code == other.code &&
        name == other.name &&
        level == other.level &&
        levelLabel == other.levelLabel &&
        label == other.label &&
        breadcrumbs == other.breadcrumbs &&
        childrenLabel == other.childrenLabel &&
        drillable == other.drillable &&
        psgcVersion == other.psgcVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jc(_$hash, levelLabel.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, breadcrumbs.hashCode);
    _$hash = $jc(_$hash, childrenLabel.hashCode);
    _$hash = $jc(_$hash, drillable.hashCode);
    _$hash = $jc(_$hash, psgcVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoScope')
          ..add('code', code)
          ..add('name', name)
          ..add('level', level)
          ..add('levelLabel', levelLabel)
          ..add('label', label)
          ..add('breadcrumbs', breadcrumbs)
          ..add('childrenLabel', childrenLabel)
          ..add('drillable', drillable)
          ..add('psgcVersion', psgcVersion))
        .toString();
  }
}

class GeoScopeBuilder implements Builder<GeoScope, GeoScopeBuilder> {
  _$GeoScope? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _level;
  String? get level => _$this._level;
  set level(String? level) => _$this._level = level;

  String? _levelLabel;
  String? get levelLabel => _$this._levelLabel;
  set levelLabel(String? levelLabel) => _$this._levelLabel = levelLabel;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<GeoBreadcrumb>? _breadcrumbs;
  ListBuilder<GeoBreadcrumb> get breadcrumbs =>
      _$this._breadcrumbs ??= ListBuilder<GeoBreadcrumb>();
  set breadcrumbs(ListBuilder<GeoBreadcrumb>? breadcrumbs) =>
      _$this._breadcrumbs = breadcrumbs;

  String? _childrenLabel;
  String? get childrenLabel => _$this._childrenLabel;
  set childrenLabel(String? childrenLabel) =>
      _$this._childrenLabel = childrenLabel;

  bool? _drillable;
  bool? get drillable => _$this._drillable;
  set drillable(bool? drillable) => _$this._drillable = drillable;

  GeoScopePsgcVersionBuilder? _psgcVersion;
  GeoScopePsgcVersionBuilder get psgcVersion =>
      _$this._psgcVersion ??= GeoScopePsgcVersionBuilder();
  set psgcVersion(GeoScopePsgcVersionBuilder? psgcVersion) =>
      _$this._psgcVersion = psgcVersion;

  GeoScopeBuilder() {
    GeoScope._defaults(this);
  }

  GeoScopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _level = $v.level;
      _levelLabel = $v.levelLabel;
      _label = $v.label;
      _breadcrumbs = $v.breadcrumbs.toBuilder();
      _childrenLabel = $v.childrenLabel;
      _drillable = $v.drillable;
      _psgcVersion = $v.psgcVersion?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoScope other) {
    _$v = other as _$GeoScope;
  }

  @override
  void update(void Function(GeoScopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoScope build() => _build();

  _$GeoScope _build() {
    _$GeoScope _$result;
    try {
      _$result = _$v ??
          _$GeoScope._(
            code: code,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GeoScope', 'name'),
            level: level,
            levelLabel: BuiltValueNullFieldError.checkNotNull(
                levelLabel, r'GeoScope', 'levelLabel'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'GeoScope', 'label'),
            breadcrumbs: breadcrumbs.build(),
            childrenLabel: BuiltValueNullFieldError.checkNotNull(
                childrenLabel, r'GeoScope', 'childrenLabel'),
            drillable: BuiltValueNullFieldError.checkNotNull(
                drillable, r'GeoScope', 'drillable'),
            psgcVersion: _psgcVersion?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'breadcrumbs';
        breadcrumbs.build();

        _$failedField = 'psgcVersion';
        _psgcVersion?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoScope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
