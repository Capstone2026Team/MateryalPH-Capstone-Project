// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_material.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectMaterialMatchTypeEnum _$projectMaterialMatchTypeEnum_EXACT =
    const ProjectMaterialMatchTypeEnum._('EXACT');
const ProjectMaterialMatchTypeEnum _$projectMaterialMatchTypeEnum_ALIAS =
    const ProjectMaterialMatchTypeEnum._('ALIAS');
const ProjectMaterialMatchTypeEnum _$projectMaterialMatchTypeEnum_FUZZY =
    const ProjectMaterialMatchTypeEnum._('FUZZY');

ProjectMaterialMatchTypeEnum _$projectMaterialMatchTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'EXACT':
      return _$projectMaterialMatchTypeEnum_EXACT;
    case 'ALIAS':
      return _$projectMaterialMatchTypeEnum_ALIAS;
    case 'FUZZY':
      return _$projectMaterialMatchTypeEnum_FUZZY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectMaterialMatchTypeEnum>
    _$projectMaterialMatchTypeEnumValues =
    BuiltSet<ProjectMaterialMatchTypeEnum>(const <ProjectMaterialMatchTypeEnum>[
  _$projectMaterialMatchTypeEnum_EXACT,
  _$projectMaterialMatchTypeEnum_ALIAS,
  _$projectMaterialMatchTypeEnum_FUZZY,
]);

Serializer<ProjectMaterialMatchTypeEnum>
    _$projectMaterialMatchTypeEnumSerializer =
    _$ProjectMaterialMatchTypeEnumSerializer();

class _$ProjectMaterialMatchTypeEnumSerializer
    implements PrimitiveSerializer<ProjectMaterialMatchTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EXACT': 'EXACT',
    'ALIAS': 'ALIAS',
    'FUZZY': 'FUZZY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EXACT': 'EXACT',
    'ALIAS': 'ALIAS',
    'FUZZY': 'FUZZY',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectMaterialMatchTypeEnum];
  @override
  final String wireName = 'ProjectMaterialMatchTypeEnum';

  @override
  Object serialize(Serializers serializers, ProjectMaterialMatchTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectMaterialMatchTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectMaterialMatchTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectMaterial extends ProjectMaterial {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final bool regulated;
  @override
  final ProjectMaterialMatchTypeEnum matchType;
  @override
  final String matchedText;
  @override
  final num similarity;
  @override
  final BuiltList<ProjectMaterialUnit> compatibleUnits;
  @override
  final BuiltList<ProjectMaterialAttribute> attributes;

  factory _$ProjectMaterial([void Function(ProjectMaterialBuilder)? updates]) =>
      (ProjectMaterialBuilder()..update(updates))._build();

  _$ProjectMaterial._(
      {required this.id,
      required this.code,
      required this.name,
      required this.categoryId,
      required this.categoryName,
      required this.regulated,
      required this.matchType,
      required this.matchedText,
      required this.similarity,
      required this.compatibleUnits,
      required this.attributes})
      : super._();
  @override
  ProjectMaterial rebuild(void Function(ProjectMaterialBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectMaterialBuilder toBuilder() => ProjectMaterialBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectMaterial &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        regulated == other.regulated &&
        matchType == other.matchType &&
        matchedText == other.matchedText &&
        similarity == other.similarity &&
        compatibleUnits == other.compatibleUnits &&
        attributes == other.attributes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, regulated.hashCode);
    _$hash = $jc(_$hash, matchType.hashCode);
    _$hash = $jc(_$hash, matchedText.hashCode);
    _$hash = $jc(_$hash, similarity.hashCode);
    _$hash = $jc(_$hash, compatibleUnits.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectMaterial')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('regulated', regulated)
          ..add('matchType', matchType)
          ..add('matchedText', matchedText)
          ..add('similarity', similarity)
          ..add('compatibleUnits', compatibleUnits)
          ..add('attributes', attributes))
        .toString();
  }
}

class ProjectMaterialBuilder
    implements Builder<ProjectMaterial, ProjectMaterialBuilder> {
  _$ProjectMaterial? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  bool? _regulated;
  bool? get regulated => _$this._regulated;
  set regulated(bool? regulated) => _$this._regulated = regulated;

  ProjectMaterialMatchTypeEnum? _matchType;
  ProjectMaterialMatchTypeEnum? get matchType => _$this._matchType;
  set matchType(ProjectMaterialMatchTypeEnum? matchType) =>
      _$this._matchType = matchType;

  String? _matchedText;
  String? get matchedText => _$this._matchedText;
  set matchedText(String? matchedText) => _$this._matchedText = matchedText;

  num? _similarity;
  num? get similarity => _$this._similarity;
  set similarity(num? similarity) => _$this._similarity = similarity;

  ListBuilder<ProjectMaterialUnit>? _compatibleUnits;
  ListBuilder<ProjectMaterialUnit> get compatibleUnits =>
      _$this._compatibleUnits ??= ListBuilder<ProjectMaterialUnit>();
  set compatibleUnits(ListBuilder<ProjectMaterialUnit>? compatibleUnits) =>
      _$this._compatibleUnits = compatibleUnits;

  ListBuilder<ProjectMaterialAttribute>? _attributes;
  ListBuilder<ProjectMaterialAttribute> get attributes =>
      _$this._attributes ??= ListBuilder<ProjectMaterialAttribute>();
  set attributes(ListBuilder<ProjectMaterialAttribute>? attributes) =>
      _$this._attributes = attributes;

  ProjectMaterialBuilder() {
    ProjectMaterial._defaults(this);
  }

  ProjectMaterialBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _categoryId = $v.categoryId;
      _categoryName = $v.categoryName;
      _regulated = $v.regulated;
      _matchType = $v.matchType;
      _matchedText = $v.matchedText;
      _similarity = $v.similarity;
      _compatibleUnits = $v.compatibleUnits.toBuilder();
      _attributes = $v.attributes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectMaterial other) {
    _$v = other as _$ProjectMaterial;
  }

  @override
  void update(void Function(ProjectMaterialBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectMaterial build() => _build();

  _$ProjectMaterial _build() {
    _$ProjectMaterial _$result;
    try {
      _$result = _$v ??
          _$ProjectMaterial._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProjectMaterial', 'id'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ProjectMaterial', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProjectMaterial', 'name'),
            categoryId: BuiltValueNullFieldError.checkNotNull(
                categoryId, r'ProjectMaterial', 'categoryId'),
            categoryName: BuiltValueNullFieldError.checkNotNull(
                categoryName, r'ProjectMaterial', 'categoryName'),
            regulated: BuiltValueNullFieldError.checkNotNull(
                regulated, r'ProjectMaterial', 'regulated'),
            matchType: BuiltValueNullFieldError.checkNotNull(
                matchType, r'ProjectMaterial', 'matchType'),
            matchedText: BuiltValueNullFieldError.checkNotNull(
                matchedText, r'ProjectMaterial', 'matchedText'),
            similarity: BuiltValueNullFieldError.checkNotNull(
                similarity, r'ProjectMaterial', 'similarity'),
            compatibleUnits: compatibleUnits.build(),
            attributes: attributes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'compatibleUnits';
        compatibleUnits.build();
        _$failedField = 'attributes';
        attributes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectMaterial', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
