//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_cancellation_request_ref.g.dart';

/// VendorCancellationRequestRef
///
/// Properties:
/// * [reasonCode]
/// * [reason]
/// * [requestedAt]
/// * [responseDueAt]
/// * [orderStateAtRequest]
@BuiltValue()
abstract class VendorCancellationRequestRef implements Built<VendorCancellationRequestRef, VendorCancellationRequestRefBuilder> {
  @BuiltValueField(wireName: r'reason_code')
  String get reasonCode;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'requested_at')
  DateTime? get requestedAt;

  @BuiltValueField(wireName: r'response_due_at')
  DateTime? get responseDueAt;

  @BuiltValueField(wireName: r'order_state_at_request')
  String get orderStateAtRequest;

  VendorCancellationRequestRef._();

  factory VendorCancellationRequestRef([void updates(VendorCancellationRequestRefBuilder b)]) = _$VendorCancellationRequestRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCancellationRequestRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCancellationRequestRef> get serializer => _$VendorCancellationRequestRefSerializer();
}

class _$VendorCancellationRequestRefSerializer implements PrimitiveSerializer<VendorCancellationRequestRef> {
  @override
  final Iterable<Type> types = const [VendorCancellationRequestRef, _$VendorCancellationRequestRef];

  @override
  final String wireName = r'VendorCancellationRequestRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCancellationRequestRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(String),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.requestedAt != null) {
      yield r'requested_at';
      yield serializers.serialize(
        object.requestedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.responseDueAt != null) {
      yield r'response_due_at';
      yield serializers.serialize(
        object.responseDueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'order_state_at_request';
    yield serializers.serialize(
      object.orderStateAtRequest,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCancellationRequestRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCancellationRequestRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reasonCode = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.requestedAt = valueDes;
          break;
        case r'response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.responseDueAt = valueDes;
          break;
        case r'order_state_at_request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderStateAtRequest = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorCancellationRequestRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCancellationRequestRefBuilder();
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


