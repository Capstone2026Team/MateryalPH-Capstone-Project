//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_assignee.g.dart';

/// FulfillmentAssignee
///
/// Properties:
/// * [userId]
/// * [displayName]
/// * [assigned]
@BuiltValue()
abstract class FulfillmentAssignee implements Built<FulfillmentAssignee, FulfillmentAssigneeBuilder> {
  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'assigned')
  bool get assigned;

  FulfillmentAssignee._();

  factory FulfillmentAssignee([void updates(FulfillmentAssigneeBuilder b)]) = _$FulfillmentAssignee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentAssigneeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentAssignee> get serializer => _$FulfillmentAssigneeSerializer();
}

class _$FulfillmentAssigneeSerializer implements PrimitiveSerializer<FulfillmentAssignee> {
  @override
  final Iterable<Type> types = const [FulfillmentAssignee, _$FulfillmentAssignee];

  @override
  final String wireName = r'FulfillmentAssignee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentAssignee object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'assigned';
    yield serializers.serialize(
      object.assigned,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentAssignee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentAssigneeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'assigned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.assigned = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentAssignee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentAssigneeBuilder();
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


