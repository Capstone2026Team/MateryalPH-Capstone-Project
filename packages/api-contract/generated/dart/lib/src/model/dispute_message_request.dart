//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_message_request.g.dart';

/// DisputeMessageRequest
///
/// Properties:
/// * [body]
@BuiltValue()
abstract class DisputeMessageRequest implements Built<DisputeMessageRequest, DisputeMessageRequestBuilder> {
  @BuiltValueField(wireName: r'body')
  String get body;

  DisputeMessageRequest._();

  factory DisputeMessageRequest([void updates(DisputeMessageRequestBuilder b)]) = _$DisputeMessageRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeMessageRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeMessageRequest> get serializer => _$DisputeMessageRequestSerializer();
}

class _$DisputeMessageRequestSerializer implements PrimitiveSerializer<DisputeMessageRequest> {
  @override
  final Iterable<Type> types = const [DisputeMessageRequest, _$DisputeMessageRequest];

  @override
  final String wireName = r'DisputeMessageRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeMessageRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeMessageRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeMessageRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeMessageRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeMessageRequestBuilder();
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


