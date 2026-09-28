//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_comparability.g.dart';

/// MAT-03 source version of the current comparable-group mapping.
///
/// Properties:
/// * [status]
/// * [groupVersionId]
/// * [ruleVersion]
@BuiltValue()
abstract class InventoryComparability implements Built<InventoryComparability, InventoryComparabilityBuilder> {
  @BuiltValueField(wireName: r'status')
  InventoryComparabilityStatusEnum get status;
  // enum statusEnum {  COMPARABLE,  NOT_YET_COMPARABLE,  };

  @BuiltValueField(wireName: r'group_version_id')
  String? get groupVersionId;

  @BuiltValueField(wireName: r'rule_version')
  String get ruleVersion;

  InventoryComparability._();

  factory InventoryComparability([void updates(InventoryComparabilityBuilder b)]) = _$InventoryComparability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryComparabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryComparability> get serializer => _$InventoryComparabilitySerializer();
}

class _$InventoryComparabilitySerializer implements PrimitiveSerializer<InventoryComparability> {
  @override
  final Iterable<Type> types = const [InventoryComparability, _$InventoryComparability];

  @override
  final String wireName = r'InventoryComparability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryComparability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(InventoryComparabilityStatusEnum),
    );
    yield r'group_version_id';
    yield object.groupVersionId == null ? null : serializers.serialize(
      object.groupVersionId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'rule_version';
    yield serializers.serialize(
      object.ruleVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryComparability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryComparabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryComparabilityStatusEnum),
          ) as InventoryComparabilityStatusEnum;
          result.status = valueDes;
          break;
        case r'group_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.groupVersionId = valueDes;
          break;
        case r'rule_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ruleVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryComparability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryComparabilityBuilder();
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


class InventoryComparabilityStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPARABLE')
  static const InventoryComparabilityStatusEnum COMPARABLE = _$inventoryComparabilityStatusEnum_COMPARABLE;
  @BuiltValueEnumConst(wireName: r'NOT_YET_COMPARABLE')
  static const InventoryComparabilityStatusEnum NOT_YET_COMPARABLE = _$inventoryComparabilityStatusEnum_NOT_YET_COMPARABLE;

  static Serializer<InventoryComparabilityStatusEnum> get serializer => _$inventoryComparabilityStatusEnumSerializer;

  const InventoryComparabilityStatusEnum._(String name): super(name);

  static BuiltSet<InventoryComparabilityStatusEnum> get values => _$inventoryComparabilityStatusEnumValues;
  static InventoryComparabilityStatusEnum valueOf(String name) => _$inventoryComparabilityStatusEnumValueOf(name);
}

