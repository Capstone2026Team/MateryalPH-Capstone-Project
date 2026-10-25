//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/web_password_recovery_portal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'complete_web_password_recovery_request.g.dart';

/// Vendor passwords require at least 12 characters; Admin passwords require at least 14. Both require mixed case and a number.
///
/// Properties:
/// * [email]
/// * [portal]
/// * [password]
/// * [passwordConfirmation]
@BuiltValue()
abstract class CompleteWebPasswordRecoveryRequest implements Built<CompleteWebPasswordRecoveryRequest, CompleteWebPasswordRecoveryRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'portal')
  WebPasswordRecoveryPortal get portal;
  // enum portalEnum {  VENDOR,  ADMIN,  };

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'password_confirmation')
  String get passwordConfirmation;

  CompleteWebPasswordRecoveryRequest._();

  factory CompleteWebPasswordRecoveryRequest([void updates(CompleteWebPasswordRecoveryRequestBuilder b)]) = _$CompleteWebPasswordRecoveryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompleteWebPasswordRecoveryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompleteWebPasswordRecoveryRequest> get serializer => _$CompleteWebPasswordRecoveryRequestSerializer();
}

class _$CompleteWebPasswordRecoveryRequestSerializer implements PrimitiveSerializer<CompleteWebPasswordRecoveryRequest> {
  @override
  final Iterable<Type> types = const [CompleteWebPasswordRecoveryRequest, _$CompleteWebPasswordRecoveryRequest];

  @override
  final String wireName = r'CompleteWebPasswordRecoveryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompleteWebPasswordRecoveryRequest object, {
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
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'password_confirmation';
    yield serializers.serialize(
      object.passwordConfirmation,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompleteWebPasswordRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompleteWebPasswordRecoveryRequestBuilder result,
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
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'password_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passwordConfirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompleteWebPasswordRecoveryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompleteWebPasswordRecoveryRequestBuilder();
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


