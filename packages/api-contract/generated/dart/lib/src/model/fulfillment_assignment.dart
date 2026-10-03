//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_assignment.g.dart';

/// FulfillmentAssignment
///
/// Properties:
/// * [displayName]
/// * [role]
/// * [assignedAt]
/// * [userId]
@BuiltValue()
abstract class FulfillmentAssignment implements Built<FulfillmentAssignment, FulfillmentAssignmentBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'role')
  FulfillmentAssignmentRoleEnum get role;
  // enum roleEnum {  FULFILLMENT,  };

  @BuiltValueField(wireName: r'assigned_at')
  DateTime? get assignedAt;

  @BuiltValueField(wireName: r'user_id')
  int? get userId;

  FulfillmentAssignment._();

  factory FulfillmentAssignment([void updates(FulfillmentAssignmentBuilder b)]) = _$FulfillmentAssignment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentAssignmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentAssignment> get serializer => _$FulfillmentAssignmentSerializer();
}

class _$FulfillmentAssignmentSerializer implements PrimitiveSerializer<FulfillmentAssignment> {
  @override
  final Iterable<Type> types = const [FulfillmentAssignment, _$FulfillmentAssignment];

  @override
  final String wireName = r'FulfillmentAssignment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(FulfillmentAssignmentRoleEnum),
    );
    if (object.assignedAt != null) {
      yield r'assigned_at';
      yield serializers.serialize(
        object.assignedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.userId != null) {
      yield r'user_id';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentAssignmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentAssignmentRoleEnum),
          ) as FulfillmentAssignmentRoleEnum;
          result.role = valueDes;
          break;
        case r'assigned_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.assignedAt = valueDes;
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentAssignment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentAssignmentBuilder();
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


class FulfillmentAssignmentRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const FulfillmentAssignmentRoleEnum FULFILLMENT = _$fulfillmentAssignmentRoleEnum_FULFILLMENT;

  static Serializer<FulfillmentAssignmentRoleEnum> get serializer => _$fulfillmentAssignmentRoleEnumSerializer;

  const FulfillmentAssignmentRoleEnum._(String name): super(name);

  static BuiltSet<FulfillmentAssignmentRoleEnum> get values => _$fulfillmentAssignmentRoleEnumValues;
  static FulfillmentAssignmentRoleEnum valueOf(String name) => _$fulfillmentAssignmentRoleEnumValueOf(name);
}

