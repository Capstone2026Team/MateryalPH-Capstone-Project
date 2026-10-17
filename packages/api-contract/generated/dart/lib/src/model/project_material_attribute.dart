//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_material_attribute.g.dart';

/// ProjectMaterialAttribute
///
/// Properties:
/// * [code]
/// * [label]
/// * [valueType]
/// * [allowedValues]
/// * [unitCode]
/// * [offeredValues] - Values currently eligible, in-stock products of this material are listed with (public listing facts, at most 12, numbers ascending).
@BuiltValue()
abstract class ProjectMaterialAttribute implements Built<ProjectMaterialAttribute, ProjectMaterialAttributeBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'value_type')
  ProjectMaterialAttributeValueTypeEnum get valueType;
  // enum valueTypeEnum {  TEXT,  NUMBER,  ENUM,  };

  @BuiltValueField(wireName: r'allowed_values')
  BuiltList<String>? get allowedValues;

  @BuiltValueField(wireName: r'unit_code')
  String? get unitCode;

  /// Values currently eligible, in-stock products of this material are listed with (public listing facts, at most 12, numbers ascending).
  @BuiltValueField(wireName: r'offered_values')
  BuiltList<String>? get offeredValues;

  ProjectMaterialAttribute._();

  factory ProjectMaterialAttribute([void updates(ProjectMaterialAttributeBuilder b)]) = _$ProjectMaterialAttribute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectMaterialAttributeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectMaterialAttribute> get serializer => _$ProjectMaterialAttributeSerializer();
}

class _$ProjectMaterialAttributeSerializer implements PrimitiveSerializer<ProjectMaterialAttribute> {
  @override
  final Iterable<Type> types = const [ProjectMaterialAttribute, _$ProjectMaterialAttribute];

  @override
  final String wireName = r'ProjectMaterialAttribute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectMaterialAttribute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'value_type';
    yield serializers.serialize(
      object.valueType,
      specifiedType: const FullType(ProjectMaterialAttributeValueTypeEnum),
    );
    if (object.allowedValues != null) {
      yield r'allowed_values';
      yield serializers.serialize(
        object.allowedValues,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.unitCode != null) {
      yield r'unit_code';
      yield serializers.serialize(
        object.unitCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.offeredValues != null) {
      yield r'offered_values';
      yield serializers.serialize(
        object.offeredValues,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectMaterialAttribute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectMaterialAttributeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'value_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectMaterialAttributeValueTypeEnum),
          ) as ProjectMaterialAttributeValueTypeEnum;
          result.valueType = valueDes;
          break;
        case r'allowed_values':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.allowedValues.replace(valueDes);
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unitCode = valueDes;
          break;
        case r'offered_values':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.offeredValues.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectMaterialAttribute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectMaterialAttributeBuilder();
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


class ProjectMaterialAttributeValueTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEXT')
  static const ProjectMaterialAttributeValueTypeEnum TEXT = _$projectMaterialAttributeValueTypeEnum_TEXT;
  @BuiltValueEnumConst(wireName: r'NUMBER')
  static const ProjectMaterialAttributeValueTypeEnum NUMBER = _$projectMaterialAttributeValueTypeEnum_NUMBER;
  @BuiltValueEnumConst(wireName: r'ENUM')
  static const ProjectMaterialAttributeValueTypeEnum ENUM = _$projectMaterialAttributeValueTypeEnum_ENUM;

  static Serializer<ProjectMaterialAttributeValueTypeEnum> get serializer => _$projectMaterialAttributeValueTypeEnumSerializer;

  const ProjectMaterialAttributeValueTypeEnum._(String name): super(name);

  static BuiltSet<ProjectMaterialAttributeValueTypeEnum> get values => _$projectMaterialAttributeValueTypeEnumValues;
  static ProjectMaterialAttributeValueTypeEnum valueOf(String name) => _$projectMaterialAttributeValueTypeEnumValueOf(name);
}

