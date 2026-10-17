//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'web_verify_bot_challenge_request.g.dart';

/// WebVerifyBotChallengeRequest
///
/// Properties:
/// * [email]
/// * [code]
/// * [portal] - Must match the server-issued challenge. Omission selects VENDOR for compatibility.
@BuiltValue()
abstract class WebVerifyBotChallengeRequest implements Built<WebVerifyBotChallengeRequest, WebVerifyBotChallengeRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'code')
  String get code;

  /// Must match the server-issued challenge. Omission selects VENDOR for compatibility.
  @BuiltValueField(wireName: r'portal')
  WebVerifyBotChallengeRequestPortalEnum? get portal;
  // enum portalEnum {  VENDOR,  ADMIN,  };

  WebVerifyBotChallengeRequest._();

  factory WebVerifyBotChallengeRequest([void updates(WebVerifyBotChallengeRequestBuilder b)]) = _$WebVerifyBotChallengeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WebVerifyBotChallengeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WebVerifyBotChallengeRequest> get serializer => _$WebVerifyBotChallengeRequestSerializer();
}

class _$WebVerifyBotChallengeRequestSerializer implements PrimitiveSerializer<WebVerifyBotChallengeRequest> {
  @override
  final Iterable<Type> types = const [WebVerifyBotChallengeRequest, _$WebVerifyBotChallengeRequest];

  @override
  final String wireName = r'WebVerifyBotChallengeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WebVerifyBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    if (object.portal != null) {
      yield r'portal';
      yield serializers.serialize(
        object.portal,
        specifiedType: const FullType(WebVerifyBotChallengeRequestPortalEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WebVerifyBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WebVerifyBotChallengeRequestBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'portal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WebVerifyBotChallengeRequestPortalEnum),
          ) as WebVerifyBotChallengeRequestPortalEnum?;
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
  WebVerifyBotChallengeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WebVerifyBotChallengeRequestBuilder();
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
class WebVerifyBotChallengeRequestPortalEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const WebVerifyBotChallengeRequestPortalEnum VENDOR = _$webVerifyBotChallengeRequestPortalEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const WebVerifyBotChallengeRequestPortalEnum ADMIN = _$webVerifyBotChallengeRequestPortalEnum_ADMIN;

  static Serializer<WebVerifyBotChallengeRequestPortalEnum> get serializer => _$webVerifyBotChallengeRequestPortalEnumSerializer;

  const WebVerifyBotChallengeRequestPortalEnum._(String name): super(name);

  static BuiltSet<WebVerifyBotChallengeRequestPortalEnum> get values => _$webVerifyBotChallengeRequestPortalEnumValues;
  static WebVerifyBotChallengeRequestPortalEnum valueOf(String name) => _$webVerifyBotChallengeRequestPortalEnumValueOf(name);
}

