//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'problem_response_request.g.dart';

/// ProblemResponseRequest
///
/// Properties:
/// * [response]
@BuiltValue()
abstract class ProblemResponseRequest implements Built<ProblemResponseRequest, ProblemResponseRequestBuilder> {
  @BuiltValueField(wireName: r'response')
  String get response;

  ProblemResponseRequest._();

  factory ProblemResponseRequest([void updates(ProblemResponseRequestBuilder b)]) = _$ProblemResponseRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProblemResponseRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProblemResponseRequest> get serializer => _$ProblemResponseRequestSerializer();
}

class _$ProblemResponseRequestSerializer implements PrimitiveSerializer<ProblemResponseRequest> {
  @override
  final Iterable<Type> types = const [ProblemResponseRequest, _$ProblemResponseRequest];

  @override
  final String wireName = r'ProblemResponseRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProblemResponseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'response';
    yield serializers.serialize(
      object.response,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProblemResponseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProblemResponseRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'response':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.response = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProblemResponseRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProblemResponseRequestBuilder();
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


