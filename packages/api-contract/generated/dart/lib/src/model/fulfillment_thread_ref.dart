//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_thread_ref.g.dart';

/// FulfillmentThreadRef
///
/// Properties:
/// * [available]
/// * [conversationId]
/// * [readOnly]
/// * [readOnlyReason]
/// * [notice]
@BuiltValue()
abstract class FulfillmentThreadRef implements Built<FulfillmentThreadRef, FulfillmentThreadRefBuilder> {
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'conversation_id')
  String? get conversationId;

  @BuiltValueField(wireName: r'read_only')
  bool get readOnly;

  @BuiltValueField(wireName: r'read_only_reason')
  FulfillmentThreadRefReadOnlyReasonEnum? get readOnlyReason;
  // enum readOnlyReasonEnum {  ORDER_COMPLETED,  ORDER_CANCELLED,  ORDER_NOT_IN_FULFILLMENT,  };

  @BuiltValueField(wireName: r'notice')
  String? get notice;

  FulfillmentThreadRef._();

  factory FulfillmentThreadRef([void updates(FulfillmentThreadRefBuilder b)]) = _$FulfillmentThreadRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentThreadRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentThreadRef> get serializer => _$FulfillmentThreadRefSerializer();
}

class _$FulfillmentThreadRefSerializer implements PrimitiveSerializer<FulfillmentThreadRef> {
  @override
  final Iterable<Type> types = const [FulfillmentThreadRef, _$FulfillmentThreadRef];

  @override
  final String wireName = r'FulfillmentThreadRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentThreadRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    if (object.conversationId != null) {
      yield r'conversation_id';
      yield serializers.serialize(
        object.conversationId,
        specifiedType: const FullType(String),
      );
    }
    yield r'read_only';
    yield serializers.serialize(
      object.readOnly,
      specifiedType: const FullType(bool),
    );
    if (object.readOnlyReason != null) {
      yield r'read_only_reason';
      yield serializers.serialize(
        object.readOnlyReason,
        specifiedType: const FullType(FulfillmentThreadRefReadOnlyReasonEnum),
      );
    }
    if (object.notice != null) {
      yield r'notice';
      yield serializers.serialize(
        object.notice,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentThreadRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentThreadRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'conversation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.conversationId = valueDes;
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
            specifiedType: const FullType.nullable(FulfillmentThreadRefReadOnlyReasonEnum),
          ) as FulfillmentThreadRefReadOnlyReasonEnum?;
          if (valueDes == null) continue;
          result.readOnlyReason = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentThreadRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentThreadRefBuilder();
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


class FulfillmentThreadRefReadOnlyReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER_COMPLETED')
  static const FulfillmentThreadRefReadOnlyReasonEnum ORDER_COMPLETED = _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_COMPLETED;
  @BuiltValueEnumConst(wireName: r'ORDER_CANCELLED')
  static const FulfillmentThreadRefReadOnlyReasonEnum ORDER_CANCELLED = _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_CANCELLED;
  @BuiltValueEnumConst(wireName: r'ORDER_NOT_IN_FULFILLMENT')
  static const FulfillmentThreadRefReadOnlyReasonEnum ORDER_NOT_IN_FULFILLMENT = _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT;

  static Serializer<FulfillmentThreadRefReadOnlyReasonEnum> get serializer => _$fulfillmentThreadRefReadOnlyReasonEnumSerializer;

  const FulfillmentThreadRefReadOnlyReasonEnum._(String name): super(name);

  static BuiltSet<FulfillmentThreadRefReadOnlyReasonEnum> get values => _$fulfillmentThreadRefReadOnlyReasonEnumValues;
  static FulfillmentThreadRefReadOnlyReasonEnum valueOf(String name) => _$fulfillmentThreadRefReadOnlyReasonEnumValueOf(name);
}

