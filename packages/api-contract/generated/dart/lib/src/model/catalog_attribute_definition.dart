//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_attribute_definition.g.dart';

/// CatalogAttributeDefinition
///
/// Properties:
/// * [id]
/// * [materialCategoryId]
/// * [code]
/// * [label]
/// * [valueType]
/// * [required_]
/// * [allowedValues]
/// * [unitCode]
/// * [comparabilityKey] - Part of the MAT-03 exact comparable-group key.
@BuiltValue()
abstract class CatalogAttributeDefinition implements Built<CatalogAttributeDefinition, CatalogAttributeDefinitionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'material_category_id')
  String get materialCategoryId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'value_type')
  CatalogAttributeDefinitionValueTypeEnum get valueType;
  // enum valueTypeEnum {  TEXT,  NUMBER,  ENUM,  };

  @BuiltValueField(wireName: r'required')
  bool get required_;

  @BuiltValueField(wireName: r'allowed_values')
  BuiltList<String>? get allowedValues;

  @BuiltValueField(wireName: r'unit_code')
  String? get unitCode;

  /// Part of the MAT-03 exact comparable-group key.
  @BuiltValueField(wireName: r'comparability_key')
  bool get comparabilityKey;

  CatalogAttributeDefinition._();

  factory CatalogAttributeDefinition([void updates(CatalogAttributeDefinitionBuilder b)]) = _$CatalogAttributeDefinition;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogAttributeDefinitionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogAttributeDefinition> get serializer => _$CatalogAttributeDefinitionSerializer();
}

class _$CatalogAttributeDefinitionSerializer implements PrimitiveSerializer<CatalogAttributeDefinition> {
  @override
  final Iterable<Type> types = const [CatalogAttributeDefinition, _$CatalogAttributeDefinition];

  @override
  final String wireName = r'CatalogAttributeDefinition';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogAttributeDefinition object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'material_category_id';
    yield serializers.serialize(
      object.materialCategoryId,
      specifiedType: const FullType(String),
    );
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
      specifiedType: const FullType(CatalogAttributeDefinitionValueTypeEnum),
    );
    yield r'required';
    yield serializers.serialize(
      object.required_,
      specifiedType: const FullType(bool),
    );
    if (object.allowedValues != null) {
      yield r'allowed_values';
      yield serializers.serialize(
        object.allowedValues,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.unitCode != null) {
      yield r'unit_code';
      yield serializers.serialize(
        object.unitCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'comparability_key';
    yield serializers.serialize(
      object.comparabilityKey,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogAttributeDefinition object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogAttributeDefinitionBuilder result,
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
        case r'material_category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.materialCategoryId = valueDes;
          break;
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
            specifiedType: const FullType(CatalogAttributeDefinitionValueTypeEnum),
          ) as CatalogAttributeDefinitionValueTypeEnum;
          result.valueType = valueDes;
          break;
        case r'required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.required_ = valueDes;
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
        case r'comparability_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.comparabilityKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogAttributeDefinition deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogAttributeDefinitionBuilder();
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


class CatalogAttributeDefinitionValueTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEXT')
  static const CatalogAttributeDefinitionValueTypeEnum TEXT = _$catalogAttributeDefinitionValueTypeEnum_TEXT;
  @BuiltValueEnumConst(wireName: r'NUMBER')
  static const CatalogAttributeDefinitionValueTypeEnum NUMBER = _$catalogAttributeDefinitionValueTypeEnum_NUMBER;
  @BuiltValueEnumConst(wireName: r'ENUM')
  static const CatalogAttributeDefinitionValueTypeEnum ENUM = _$catalogAttributeDefinitionValueTypeEnum_ENUM;

  static Serializer<CatalogAttributeDefinitionValueTypeEnum> get serializer => _$catalogAttributeDefinitionValueTypeEnumSerializer;

  const CatalogAttributeDefinitionValueTypeEnum._(String name): super(name);

  static BuiltSet<CatalogAttributeDefinitionValueTypeEnum> get values => _$catalogAttributeDefinitionValueTypeEnumValues;
  static CatalogAttributeDefinitionValueTypeEnum valueOf(String name) => _$catalogAttributeDefinitionValueTypeEnumValueOf(name);
}

