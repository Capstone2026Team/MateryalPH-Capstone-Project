// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_site.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectSite extends ProjectSite {
  @override
  final String id;
  @override
  final String name;
  @override
  final String discoveryOrigin;
  @override
  final BuiltMap<String, JsonObject?> point;

  factory _$ProjectSite([void Function(ProjectSiteBuilder)? updates]) =>
      (ProjectSiteBuilder()..update(updates))._build();

  _$ProjectSite._(
      {required this.id,
      required this.name,
      required this.discoveryOrigin,
      required this.point})
      : super._();
  @override
  ProjectSite rebuild(void Function(ProjectSiteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectSiteBuilder toBuilder() => ProjectSiteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectSite &&
        id == other.id &&
        name == other.name &&
        discoveryOrigin == other.discoveryOrigin &&
        point == other.point;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, discoveryOrigin.hashCode);
    _$hash = $jc(_$hash, point.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectSite')
          ..add('id', id)
          ..add('name', name)
          ..add('discoveryOrigin', discoveryOrigin)
          ..add('point', point))
        .toString();
  }
}

class ProjectSiteBuilder implements Builder<ProjectSite, ProjectSiteBuilder> {
  _$ProjectSite? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _discoveryOrigin;
  String? get discoveryOrigin => _$this._discoveryOrigin;
  set discoveryOrigin(String? discoveryOrigin) =>
      _$this._discoveryOrigin = discoveryOrigin;

  MapBuilder<String, JsonObject?>? _point;
  MapBuilder<String, JsonObject?> get point =>
      _$this._point ??= MapBuilder<String, JsonObject?>();
  set point(MapBuilder<String, JsonObject?>? point) => _$this._point = point;

  ProjectSiteBuilder() {
    ProjectSite._defaults(this);
  }

  ProjectSiteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _discoveryOrigin = $v.discoveryOrigin;
      _point = $v.point.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectSite other) {
    _$v = other as _$ProjectSite;
  }

  @override
  void update(void Function(ProjectSiteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectSite build() => _build();

  _$ProjectSite _build() {
    _$ProjectSite _$result;
    try {
      _$result = _$v ??
          _$ProjectSite._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ProjectSite', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProjectSite', 'name'),
            discoveryOrigin: BuiltValueNullFieldError.checkNotNull(
                discoveryOrigin, r'ProjectSite', 'discoveryOrigin'),
            point: point.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'point';
        point.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectSite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
