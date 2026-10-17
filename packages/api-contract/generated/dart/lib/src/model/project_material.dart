//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/project_material_unit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_material_attribute.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_material.g.dart';

/// ProjectMaterial
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
/// * [similarity] - 1 for exact or alias matches; pg_trgm similarity for close matches.
/// * [compatibleUnits]
/// * [attributes] - Category technical details the Buyer may state, keyed by code.
@BuiltValue()
abstract class ProjectMaterial implements Built<ProjectMaterial, ProjectMaterialBuilder> {
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
  ProjectMaterialMatchTypeEnum get matchType;
  // enum matchTypeEnum {  EXACT,  ALIAS,  FUZZY,  };

  @BuiltValueField(wireName: r'matched_text')
  String get matchedText;

  /// 1 for exact or alias matches; pg_trgm similarity for close matches.
  @BuiltValueField(wireName: r'similarity')
  num get similarity;

  @BuiltValueField(wireName: r'compatible_units')
  BuiltList<ProjectMaterialUnit> get compatibleUnits;

  /// Category technical details the Buyer may state, keyed by code.
  @BuiltValueField(wireName: r'attributes')
  BuiltList<ProjectMaterialAttribute> get attributes;

  ProjectMaterial._();

  factory ProjectMaterial([void updates(ProjectMaterialBuilder b)]) = _$ProjectMaterial;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectMaterialBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectMaterial> get serializer => _$ProjectMaterialSerializer();
}

class _$ProjectMaterialSerializer implements PrimitiveSerializer<ProjectMaterial> {
  @override
  final Iterable<Type> types = const [ProjectMaterial, _$ProjectMaterial];

  @override
  final String wireName = r'ProjectMaterial';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectMaterial object, {
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
      specifiedType: const FullType(ProjectMaterialMatchTypeEnum),
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
    yield r'compatible_units';
    yield serializers.serialize(
      object.compatibleUnits,
      specifiedType: const FullType(BuiltList, [FullType(ProjectMaterialUnit)]),
    );
    yield r'attributes';
    yield serializers.serialize(
      object.attributes,
      specifiedType: const FullType(BuiltList, [FullType(ProjectMaterialAttribute)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectMaterial object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectMaterialBuilder result,
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
            specifiedType: const FullType(ProjectMaterialMatchTypeEnum),
          ) as ProjectMaterialMatchTypeEnum;
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
        case r'compatible_units':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectMaterialUnit)]),
          ) as BuiltList<ProjectMaterialUnit>;
          result.compatibleUnits.replace(valueDes);
          break;
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectMaterialAttribute)]),
          ) as BuiltList<ProjectMaterialAttribute>;
          result.attributes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectMaterial deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectMaterialBuilder();
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


class ProjectMaterialMatchTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EXACT')
  static const ProjectMaterialMatchTypeEnum EXACT = _$projectMaterialMatchTypeEnum_EXACT;
  @BuiltValueEnumConst(wireName: r'ALIAS')
  static const ProjectMaterialMatchTypeEnum ALIAS = _$projectMaterialMatchTypeEnum_ALIAS;
  @BuiltValueEnumConst(wireName: r'FUZZY')
  static const ProjectMaterialMatchTypeEnum FUZZY = _$projectMaterialMatchTypeEnum_FUZZY;

  static Serializer<ProjectMaterialMatchTypeEnum> get serializer => _$projectMaterialMatchTypeEnumSerializer;

  const ProjectMaterialMatchTypeEnum._(String name): super(name);

  static BuiltSet<ProjectMaterialMatchTypeEnum> get values => _$projectMaterialMatchTypeEnumValues;
  static ProjectMaterialMatchTypeEnum valueOf(String name) => _$projectMaterialMatchTypeEnumValueOf(name);
}

