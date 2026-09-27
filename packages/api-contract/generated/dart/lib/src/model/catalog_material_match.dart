//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_material_match.g.dart';

/// CatalogMaterialMatch
///
/// Properties:
/// * [id]
/// * [code]
/// * [name]
/// * [categoryId]
/// * [categoryName]
/// * [regulated]
/// * [matchType]
/// * [matchedText]
/// * [similarity]
@BuiltValue()
abstract class CatalogMaterialMatch implements Built<CatalogMaterialMatch, CatalogMaterialMatchBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category_id')
  String get categoryId;

  @BuiltValueField(wireName: r'category_name')
  String get categoryName;

  @BuiltValueField(wireName: r'regulated')
  bool get regulated;

  @BuiltValueField(wireName: r'match_type')
  CatalogMaterialMatchMatchTypeEnum get matchType;
  // enum matchTypeEnum {  EXACT,  ALIAS,  FUZZY,  };

  @BuiltValueField(wireName: r'matched_text')
  String get matchedText;

  @BuiltValueField(wireName: r'similarity')
  num get similarity;

  CatalogMaterialMatch._();

  factory CatalogMaterialMatch([void updates(CatalogMaterialMatchBuilder b)]) = _$CatalogMaterialMatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogMaterialMatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogMaterialMatch> get serializer => _$CatalogMaterialMatchSerializer();
}

class _$CatalogMaterialMatchSerializer implements PrimitiveSerializer<CatalogMaterialMatch> {
  @override
  final Iterable<Type> types = const [CatalogMaterialMatch, _$CatalogMaterialMatch];

  @override
  final String wireName = r'CatalogMaterialMatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogMaterialMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category_id';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'category_name';
    yield serializers.serialize(
      object.categoryName,
      specifiedType: const FullType(String),
    );
    yield r'regulated';
    yield serializers.serialize(
      object.regulated,
      specifiedType: const FullType(bool),
    );
    yield r'match_type';
    yield serializers.serialize(
      object.matchType,
      specifiedType: const FullType(CatalogMaterialMatchMatchTypeEnum),
    );
    yield r'matched_text';
    yield serializers.serialize(
      object.matchedText,
      specifiedType: const FullType(String),
    );
    yield r'similarity';
    yield serializers.serialize(
      object.similarity,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogMaterialMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogMaterialMatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'category_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryName = valueDes;
          break;
        case r'regulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.regulated = valueDes;
          break;
        case r'match_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogMaterialMatchMatchTypeEnum),
          ) as CatalogMaterialMatchMatchTypeEnum;
          result.matchType = valueDes;
          break;
        case r'matched_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matchedText = valueDes;
          break;
        case r'similarity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.similarity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogMaterialMatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogMaterialMatchBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class CatalogMaterialMatchMatchTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EXACT')
  static const CatalogMaterialMatchMatchTypeEnum EXACT = _$catalogMaterialMatchMatchTypeEnum_EXACT;
  @BuiltValueEnumConst(wireName: r'ALIAS')
  static const CatalogMaterialMatchMatchTypeEnum ALIAS = _$catalogMaterialMatchMatchTypeEnum_ALIAS;
  @BuiltValueEnumConst(wireName: r'FUZZY')
  static const CatalogMaterialMatchMatchTypeEnum FUZZY = _$catalogMaterialMatchMatchTypeEnum_FUZZY;

  static Serializer<CatalogMaterialMatchMatchTypeEnum> get serializer => _$catalogMaterialMatchMatchTypeEnumSerializer;

  const CatalogMaterialMatchMatchTypeEnum._(String name): super(name);

  static BuiltSet<CatalogMaterialMatchMatchTypeEnum> get values => _$catalogMaterialMatchMatchTypeEnumValues;
  static CatalogMaterialMatchMatchTypeEnum valueOf(String name) => _$catalogMaterialMatchMatchTypeEnumValueOf(name);
}

