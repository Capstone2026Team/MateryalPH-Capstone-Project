//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_escalate_request.g.dart';

/// DisputeEscalateRequest
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class DisputeEscalateRequest implements Built<DisputeEscalateRequest, DisputeEscalateRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  DisputeEscalateRequest._();

  factory DisputeEscalateRequest([void updates(DisputeEscalateRequestBuilder b)]) = _$DisputeEscalateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeEscalateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeEscalateRequest> get serializer => _$DisputeEscalateRequestSerializer();
}

class _$DisputeEscalateRequestSerializer implements PrimitiveSerializer<DisputeEscalateRequest> {
  @override
  final Iterable<Type> types = const [DisputeEscalateRequest, _$DisputeEscalateRequest];

  @override
  final String wireName = r'DisputeEscalateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeEscalateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeEscalateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeEscalateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeEscalateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeEscalateRequestBuilder();
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


