//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'web_resend_bot_challenge_request.g.dart';

/// WebResendBotChallengeRequest
///
/// Properties:
/// * [email]
/// * [portal] - Must match the server-issued challenge. Omission selects VENDOR for compatibility.
@BuiltValue()
abstract class WebResendBotChallengeRequest implements Built<WebResendBotChallengeRequest, WebResendBotChallengeRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  /// Must match the server-issued challenge. Omission selects VENDOR for compatibility.
  @BuiltValueField(wireName: r'portal')
  WebResendBotChallengeRequestPortalEnum? get portal;
  // enum portalEnum {  VENDOR,  ADMIN,  };

  WebResendBotChallengeRequest._();

  factory WebResendBotChallengeRequest([void updates(WebResendBotChallengeRequestBuilder b)]) = _$WebResendBotChallengeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WebResendBotChallengeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WebResendBotChallengeRequest> get serializer => _$WebResendBotChallengeRequestSerializer();
}

class _$WebResendBotChallengeRequestSerializer implements PrimitiveSerializer<WebResendBotChallengeRequest> {
  @override
  final Iterable<Type> types = const [WebResendBotChallengeRequest, _$WebResendBotChallengeRequest];

  @override
  final String wireName = r'WebResendBotChallengeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WebResendBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    if (object.portal != null) {
      yield r'portal';
      yield serializers.serialize(
        object.portal,
        specifiedType: const FullType(WebResendBotChallengeRequestPortalEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WebResendBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WebResendBotChallengeRequestBuilder result,
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
            specifiedType: const FullType.nullable(WebResendBotChallengeRequestPortalEnum),
          ) as WebResendBotChallengeRequestPortalEnum?;
          if (valueDes == null) continue;
          result.portal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WebResendBotChallengeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WebResendBotChallengeRequestBuilder();
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


/// Must match the server-issued challenge. Omission selects VENDOR for compatibility.
class WebResendBotChallengeRequestPortalEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const WebResendBotChallengeRequestPortalEnum VENDOR = _$webResendBotChallengeRequestPortalEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const WebResendBotChallengeRequestPortalEnum ADMIN = _$webResendBotChallengeRequestPortalEnum_ADMIN;

  static Serializer<WebResendBotChallengeRequestPortalEnum> get serializer => _$webResendBotChallengeRequestPortalEnumSerializer;

  const WebResendBotChallengeRequestPortalEnum._(String name): super(name);

  static BuiltSet<WebResendBotChallengeRequestPortalEnum> get values => _$webResendBotChallengeRequestPortalEnumValues;
  static WebResendBotChallengeRequestPortalEnum valueOf(String name) => _$webResendBotChallengeRequestPortalEnumValueOf(name);
}

