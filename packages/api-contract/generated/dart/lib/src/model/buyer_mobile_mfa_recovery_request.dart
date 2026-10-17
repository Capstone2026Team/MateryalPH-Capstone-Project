//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_mobile_mfa_recovery_request.g.dart';

/// BuyerMobileMfaRecoveryRequest
///
/// Properties:
/// * [challengeToken]
/// * [recoveryCode]
@BuiltValue()
abstract class BuyerMobileMfaRecoveryRequest implements Built<BuyerMobileMfaRecoveryRequest, BuyerMobileMfaRecoveryRequestBuilder> {
  @BuiltValueField(wireName: r'challenge_token')
  String get challengeToken;

  @BuiltValueField(wireName: r'recovery_code')
  String get recoveryCode;

  BuyerMobileMfaRecoveryRequest._();

  factory BuyerMobileMfaRecoveryRequest([void updates(BuyerMobileMfaRecoveryRequestBuilder b)]) = _$BuyerMobileMfaRecoveryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMobileMfaRecoveryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMobileMfaRecoveryRequest> get serializer => _$BuyerMobileMfaRecoveryRequestSerializer();
}

class _$BuyerMobileMfaRecoveryRequestSerializer implements PrimitiveSerializer<BuyerMobileMfaRecoveryRequest> {
  @override
  final Iterable<Type> types = const [BuyerMobileMfaRecoveryRequest, _$BuyerMobileMfaRecoveryRequest];

  @override
  final String wireName = r'BuyerMobileMfaRecoveryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMobileMfaRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'challenge_token';
    yield serializers.serialize(
      object.challengeToken,
      specifiedType: const FullType(String),
    );
    yield r'recovery_code';
    yield serializers.serialize(
      object.recoveryCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMobileMfaRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMobileMfaRecoveryRequestBuilder result,
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
        case r'recovery_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recoveryCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMobileMfaRecoveryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMobileMfaRecoveryRequestBuilder();
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


