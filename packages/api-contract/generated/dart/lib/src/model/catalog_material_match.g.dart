// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_material_match.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogMaterialMatchMatchTypeEnum
    _$catalogMaterialMatchMatchTypeEnum_EXACT =
    const CatalogMaterialMatchMatchTypeEnum._('EXACT');
const CatalogMaterialMatchMatchTypeEnum
    _$catalogMaterialMatchMatchTypeEnum_ALIAS =
    const CatalogMaterialMatchMatchTypeEnum._('ALIAS');
const CatalogMaterialMatchMatchTypeEnum
    _$catalogMaterialMatchMatchTypeEnum_FUZZY =
    const CatalogMaterialMatchMatchTypeEnum._('FUZZY');

CatalogMaterialMatchMatchTypeEnum _$catalogMaterialMatchMatchTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'EXACT':
      return _$catalogMaterialMatchMatchTypeEnum_EXACT;
    case 'ALIAS':
      return _$catalogMaterialMatchMatchTypeEnum_ALIAS;
    case 'FUZZY':
      return _$catalogMaterialMatchMatchTypeEnum_FUZZY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogMaterialMatchMatchTypeEnum>
    _$catalogMaterialMatchMatchTypeEnumValues = BuiltSet<
        CatalogMaterialMatchMatchTypeEnum>(const <CatalogMaterialMatchMatchTypeEnum>[
  _$catalogMaterialMatchMatchTypeEnum_EXACT,
  _$catalogMaterialMatchMatchTypeEnum_ALIAS,
  _$catalogMaterialMatchMatchTypeEnum_FUZZY,
]);

Serializer<CatalogMaterialMatchMatchTypeEnum>
    _$catalogMaterialMatchMatchTypeEnumSerializer =
    _$CatalogMaterialMatchMatchTypeEnumSerializer();

class _$CatalogMaterialMatchMatchTypeEnumSerializer
    implements PrimitiveSerializer<CatalogMaterialMatchMatchTypeEnum> {
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
  final Iterable<Type> types = const <Type>[CatalogMaterialMatchMatchTypeEnum];
  @override
  final String wireName = 'CatalogMaterialMatchMatchTypeEnum';

  @override
  Object serialize(
          Serializers serializers, CatalogMaterialMatchMatchTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogMaterialMatchMatchTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogMaterialMatchMatchTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogMaterialMatch extends CatalogMaterialMatch {
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
  final CatalogMaterialMatchMatchTypeEnum matchType;
  @override
  final String matchedText;
  @override
  final num similarity;

  factory _$CatalogMaterialMatch(
          [void Function(CatalogMaterialMatchBuilder)? updates]) =>
      (CatalogMaterialMatchBuilder()..update(updates))._build();

  _$CatalogMaterialMatch._(
      {required this.id,
      required this.code,
      required this.name,
      required this.categoryId,
      required this.categoryName,
      required this.regulated,
      required this.matchType,
      required this.matchedText,
      required this.similarity})
      : super._();
  @override
  CatalogMaterialMatch rebuild(
          void Function(CatalogMaterialMatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogMaterialMatchBuilder toBuilder() =>
      CatalogMaterialMatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogMaterialMatch &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        regulated == other.regulated &&
        matchType == other.matchType &&
        matchedText == other.matchedText &&
        similarity == other.similarity;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogMaterialMatch')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('regulated', regulated)
          ..add('matchType', matchType)
          ..add('matchedText', matchedText)
          ..add('similarity', similarity))
        .toString();
  }
}

class CatalogMaterialMatchBuilder
    implements Builder<CatalogMaterialMatch, CatalogMaterialMatchBuilder> {
  _$CatalogMaterialMatch? _$v;

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

  CatalogMaterialMatchMatchTypeEnum? _matchType;
  CatalogMaterialMatchMatchTypeEnum? get matchType => _$this._matchType;
  set matchType(CatalogMaterialMatchMatchTypeEnum? matchType) =>
      _$this._matchType = matchType;

  String? _matchedText;
  String? get matchedText => _$this._matchedText;
  set matchedText(String? matchedText) => _$this._matchedText = matchedText;

  num? _similarity;
  num? get similarity => _$this._similarity;
  set similarity(num? similarity) => _$this._similarity = similarity;

  CatalogMaterialMatchBuilder() {
    CatalogMaterialMatch._defaults(this);
  }

  CatalogMaterialMatchBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogMaterialMatch other) {
    _$v = other as _$CatalogMaterialMatch;
  }

  @override
  void update(void Function(CatalogMaterialMatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogMaterialMatch build() => _build();

  _$CatalogMaterialMatch _build() {
    final _$result = _$v ??
        _$CatalogMaterialMatch._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CatalogMaterialMatch', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CatalogMaterialMatch', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CatalogMaterialMatch', 'name'),
          categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId, r'CatalogMaterialMatch', 'categoryId'),
          categoryName: BuiltValueNullFieldError.checkNotNull(
              categoryName, r'CatalogMaterialMatch', 'categoryName'),
          regulated: BuiltValueNullFieldError.checkNotNull(
              regulated, r'CatalogMaterialMatch', 'regulated'),
          matchType: BuiltValueNullFieldError.checkNotNull(
              matchType, r'CatalogMaterialMatch', 'matchType'),
          matchedText: BuiltValueNullFieldError.checkNotNull(
              matchedText, r'CatalogMaterialMatch', 'matchedText'),
          similarity: BuiltValueNullFieldError.checkNotNull(
              similarity, r'CatalogMaterialMatch', 'similarity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
