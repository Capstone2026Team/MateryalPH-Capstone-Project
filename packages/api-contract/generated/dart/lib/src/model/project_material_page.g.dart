// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_material_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectMaterialPage extends ProjectMaterialPage {
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> items;

  factory _$ProjectMaterialPage(
          [void Function(ProjectMaterialPageBuilder)? updates]) =>
      (ProjectMaterialPageBuilder()..update(updates))._build();

  _$ProjectMaterialPage._({required this.items}) : super._();
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
    return other is ProjectMaterialPage && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectMaterialPage')
          ..add('items', items))
        .toString();
  }
}

class ProjectMaterialPageBuilder
    implements Builder<ProjectMaterialPage, ProjectMaterialPageBuilder> {
  _$ProjectMaterialPage? _$v;

  ListBuilder<BuiltMap<String, JsonObject?>>? _items;
  ListBuilder<BuiltMap<String, JsonObject?>> get items =>
      _$this._items ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set items(ListBuilder<BuiltMap<String, JsonObject?>>? items) =>
      _$this._items = items;

  ProjectMaterialPageBuilder() {
    ProjectMaterialPage._defaults(this);
  }

  ProjectMaterialPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
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
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
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
