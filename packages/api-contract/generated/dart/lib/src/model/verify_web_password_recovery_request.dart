//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/web_password_recovery_portal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'verify_web_password_recovery_request.g.dart';

/// VerifyWebPasswordRecoveryRequest
///
/// Properties:
/// * [email]
/// * [portal]
/// * [code]
/// * [recoveryCode]
/// * [challengeId] - Only the matching portal's WEB password-recovery challenge is accepted.
@BuiltValue()
abstract class VerifyWebPasswordRecoveryRequest implements Built<VerifyWebPasswordRecoveryRequest, VerifyWebPasswordRecoveryRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'portal')
  WebPasswordRecoveryPortal get portal;
  // enum portalEnum {  VENDOR,  ADMIN,  };

  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'recovery_code')
  String? get recoveryCode;

  /// Only the matching portal's WEB password-recovery challenge is accepted.
  @BuiltValueField(wireName: r'challenge_id')
  String? get challengeId;

  VerifyWebPasswordRecoveryRequest._();

  factory VerifyWebPasswordRecoveryRequest([void updates(VerifyWebPasswordRecoveryRequestBuilder b)]) = _$VerifyWebPasswordRecoveryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VerifyWebPasswordRecoveryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VerifyWebPasswordRecoveryRequest> get serializer => _$VerifyWebPasswordRecoveryRequestSerializer();
}

class _$VerifyWebPasswordRecoveryRequestSerializer implements PrimitiveSerializer<VerifyWebPasswordRecoveryRequest> {
  @override
  final Iterable<Type> types = const [VerifyWebPasswordRecoveryRequest, _$VerifyWebPasswordRecoveryRequest];

  @override
  final String wireName = r'VerifyWebPasswordRecoveryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VerifyWebPasswordRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'portal';
    yield serializers.serialize(
      object.portal,
      specifiedType: const FullType(WebPasswordRecoveryPortal),
    );
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType(String),
      );
    }
    if (object.recoveryCode != null) {
      yield r'recovery_code';
      yield serializers.serialize(
        object.recoveryCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.challengeId != null) {
      yield r'challenge_id';
      yield serializers.serialize(
        object.challengeId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VerifyWebPasswordRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VerifyWebPasswordRecoveryRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'portal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WebPasswordRecoveryPortal),
          ) as WebPasswordRecoveryPortal;
          result.portal = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'recovery_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recoveryCode = valueDes;
          break;
        case r'challenge_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.challengeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VerifyWebPasswordRecoveryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VerifyWebPasswordRecoveryRequestBuilder();
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


