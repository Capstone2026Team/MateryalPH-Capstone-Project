// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_material_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectMaterialPage extends ProjectMaterialPage {
  @override
  final BuiltList<ProjectMaterial> items;
  @override
  final BuiltList<ProjectMaterialUnit> units;

  factory _$ProjectMaterialPage(
          [void Function(ProjectMaterialPageBuilder)? updates]) =>
      (ProjectMaterialPageBuilder()..update(updates))._build();

  _$ProjectMaterialPage._({required this.items, required this.units})
      : super._();
  @override
  ProjectMaterialPage rebuild(
          void Function(ProjectMaterialPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectMaterialPageBuilder toBuilder() =>
      ProjectMaterialPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectMaterialPage &&
        items == other.items &&
        units == other.units;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, units.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectMaterialPage')
          ..add('items', items)
          ..add('units', units))
        .toString();
  }
}

class ProjectMaterialPageBuilder
    implements Builder<ProjectMaterialPage, ProjectMaterialPageBuilder> {
  _$ProjectMaterialPage? _$v;

  ListBuilder<ProjectMaterial>? _items;
  ListBuilder<ProjectMaterial> get items =>
      _$this._items ??= ListBuilder<ProjectMaterial>();
  set items(ListBuilder<ProjectMaterial>? items) => _$this._items = items;

  ListBuilder<ProjectMaterialUnit>? _units;
  ListBuilder<ProjectMaterialUnit> get units =>
      _$this._units ??= ListBuilder<ProjectMaterialUnit>();
  set units(ListBuilder<ProjectMaterialUnit>? units) => _$this._units = units;

  ProjectMaterialPageBuilder() {
    ProjectMaterialPage._defaults(this);
  }

  ProjectMaterialPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _units = $v.units.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectMaterialPage other) {
    _$v = other as _$ProjectMaterialPage;
  }

  @override
  void update(void Function(ProjectMaterialPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectMaterialPage build() => _build();

  _$ProjectMaterialPage _build() {
    _$ProjectMaterialPage _$result;
    try {
      _$result = _$v ??
          _$ProjectMaterialPage._(
            items: items.build(),
            units: units.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
        _$failedField = 'units';
        units.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectMaterialPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
