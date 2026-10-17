//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_mobile_mfa_challenge_request.g.dart';

/// BuyerMobileMfaChallengeRequest
///
/// Properties:
/// * [challengeToken]
/// * [code]
@BuiltValue()
abstract class BuyerMobileMfaChallengeRequest implements Built<BuyerMobileMfaChallengeRequest, BuyerMobileMfaChallengeRequestBuilder> {
  @BuiltValueField(wireName: r'challenge_token')
  String get challengeToken;

  @BuiltValueField(wireName: r'code')
  String get code;

  BuyerMobileMfaChallengeRequest._();

  factory BuyerMobileMfaChallengeRequest([void updates(BuyerMobileMfaChallengeRequestBuilder b)]) = _$BuyerMobileMfaChallengeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMobileMfaChallengeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMobileMfaChallengeRequest> get serializer => _$BuyerMobileMfaChallengeRequestSerializer();
}

class _$BuyerMobileMfaChallengeRequestSerializer implements PrimitiveSerializer<BuyerMobileMfaChallengeRequest> {
  @override
  final Iterable<Type> types = const [BuyerMobileMfaChallengeRequest, _$BuyerMobileMfaChallengeRequest];

  @override
  final String wireName = r'BuyerMobileMfaChallengeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMobileMfaChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'challenge_token';
    yield serializers.serialize(
      object.challengeToken,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMobileMfaChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMobileMfaChallengeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'challenge_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.challengeToken = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMobileMfaChallengeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMobileMfaChallengeRequestBuilder();
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


