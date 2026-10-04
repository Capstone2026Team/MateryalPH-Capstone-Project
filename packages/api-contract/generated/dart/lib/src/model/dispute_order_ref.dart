//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_order_ref.g.dart';

/// DisputeOrderRef
///
/// Properties:
/// * [id]
/// * [reference]
/// * [orderState]
/// * [disputeState]
/// * [refundState]
/// * [paymentMethod]
@BuiltValue()
abstract class DisputeOrderRef implements Built<DisputeOrderRef, DisputeOrderRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'order_state')
  String get orderState;

  @BuiltValueField(wireName: r'dispute_state')
  String get disputeState;

  @BuiltValueField(wireName: r'refund_state')
  String get refundState;

  @BuiltValueField(wireName: r'payment_method')
  String get paymentMethod;

  DisputeOrderRef._();

  factory DisputeOrderRef([void updates(DisputeOrderRefBuilder b)]) = _$DisputeOrderRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeOrderRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeOrderRef> get serializer => _$DisputeOrderRefSerializer();
}

class _$DisputeOrderRefSerializer implements PrimitiveSerializer<DisputeOrderRef> {
  @override
  final Iterable<Type> types = const [DisputeOrderRef, _$DisputeOrderRef];

  @override
  final String wireName = r'DisputeOrderRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeOrderRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'order_state';
    yield serializers.serialize(
      object.orderState,
      specifiedType: const FullType(String),
    );
    yield r'dispute_state';
    yield serializers.serialize(
      object.disputeState,
      specifiedType: const FullType(String),
    );
    yield r'refund_state';
    yield serializers.serialize(
      object.refundState,
      specifiedType: const FullType(String),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeOrderRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeOrderRefBuilder result,
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
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'order_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderState = valueDes;
          break;
        case r'dispute_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.disputeState = valueDes;
          break;
        case r'refund_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundState = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeOrderRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeOrderRefBuilder();
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


