//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_conversation_summary.g.dart';

/// FulfillmentConversationSummary
///
/// Properties:
/// * [conversationId]
/// * [orderId]
/// * [orderReference]
/// * [orderState]
/// * [fulfillmentMethod]
/// * [unreadCount]
/// * [updatedAt]
/// * [readOnly]
/// * [readOnlyReason]
@BuiltValue()
abstract class FulfillmentConversationSummary implements Built<FulfillmentConversationSummary, FulfillmentConversationSummaryBuilder> {
  @BuiltValueField(wireName: r'conversation_id')
  String get conversationId;

  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'order_state')
  String get orderState;

  @BuiltValueField(wireName: r'fulfillment_method')
  FulfillmentConversationSummaryFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  PICKUP,  DELIVERY,  };

  @BuiltValueField(wireName: r'unread_count')
  int get unreadCount;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'read_only')
  bool get readOnly;

  @BuiltValueField(wireName: r'read_only_reason')
  FulfillmentConversationSummaryReadOnlyReasonEnum? get readOnlyReason;
  // enum readOnlyReasonEnum {  ORDER_COMPLETED,  ORDER_CANCELLED,  ORDER_NOT_IN_FULFILLMENT,  };

  FulfillmentConversationSummary._();

  factory FulfillmentConversationSummary([void updates(FulfillmentConversationSummaryBuilder b)]) = _$FulfillmentConversationSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentConversationSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentConversationSummary> get serializer => _$FulfillmentConversationSummarySerializer();
}

class _$FulfillmentConversationSummarySerializer implements PrimitiveSerializer<FulfillmentConversationSummary> {
  @override
  final Iterable<Type> types = const [FulfillmentConversationSummary, _$FulfillmentConversationSummary];

  @override
  final String wireName = r'FulfillmentConversationSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentConversationSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'conversation_id';
    yield serializers.serialize(
      object.conversationId,
      specifiedType: const FullType(String),
    );
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'order_state';
    yield serializers.serialize(
      object.orderState,
      specifiedType: const FullType(String),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(FulfillmentConversationSummaryFulfillmentMethodEnum),
    );
    yield r'unread_count';
    yield serializers.serialize(
      object.unreadCount,
      specifiedType: const FullType(int),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'read_only';
    yield serializers.serialize(
      object.readOnly,
      specifiedType: const FullType(bool),
    );
    if (object.readOnlyReason != null) {
      yield r'read_only_reason';
      yield serializers.serialize(
        object.readOnlyReason,
        specifiedType: const FullType(FulfillmentConversationSummaryReadOnlyReasonEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentConversationSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentConversationSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'conversation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.conversationId = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'order_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderState = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentConversationSummaryFulfillmentMethodEnum),
          ) as FulfillmentConversationSummaryFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'unread_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreadCount = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'read_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.readOnly = valueDes;
          break;
        case r'read_only_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentConversationSummaryReadOnlyReasonEnum),
          ) as FulfillmentConversationSummaryReadOnlyReasonEnum?;
          if (valueDes == null) continue;
          result.readOnlyReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentConversationSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentConversationSummaryBuilder();
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


class FulfillmentConversationSummaryFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const FulfillmentConversationSummaryFulfillmentMethodEnum PICKUP = _$fulfillmentConversationSummaryFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const FulfillmentConversationSummaryFulfillmentMethodEnum DELIVERY = _$fulfillmentConversationSummaryFulfillmentMethodEnum_DELIVERY;

  static Serializer<FulfillmentConversationSummaryFulfillmentMethodEnum> get serializer => _$fulfillmentConversationSummaryFulfillmentMethodEnumSerializer;

  const FulfillmentConversationSummaryFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<FulfillmentConversationSummaryFulfillmentMethodEnum> get values => _$fulfillmentConversationSummaryFulfillmentMethodEnumValues;
  static FulfillmentConversationSummaryFulfillmentMethodEnum valueOf(String name) => _$fulfillmentConversationSummaryFulfillmentMethodEnumValueOf(name);
}

class FulfillmentConversationSummaryReadOnlyReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER_COMPLETED')
  static const FulfillmentConversationSummaryReadOnlyReasonEnum ORDER_COMPLETED = _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_COMPLETED;
  @BuiltValueEnumConst(wireName: r'ORDER_CANCELLED')
  static const FulfillmentConversationSummaryReadOnlyReasonEnum ORDER_CANCELLED = _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_CANCELLED;
  @BuiltValueEnumConst(wireName: r'ORDER_NOT_IN_FULFILLMENT')
  static const FulfillmentConversationSummaryReadOnlyReasonEnum ORDER_NOT_IN_FULFILLMENT = _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT;

  static Serializer<FulfillmentConversationSummaryReadOnlyReasonEnum> get serializer => _$fulfillmentConversationSummaryReadOnlyReasonEnumSerializer;

  const FulfillmentConversationSummaryReadOnlyReasonEnum._(String name): super(name);

  static BuiltSet<FulfillmentConversationSummaryReadOnlyReasonEnum> get values => _$fulfillmentConversationSummaryReadOnlyReasonEnumValues;
  static FulfillmentConversationSummaryReadOnlyReasonEnum valueOf(String name) => _$fulfillmentConversationSummaryReadOnlyReasonEnumValueOf(name);
}

