//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'xendit_account_verification_webhook.g.dart';

/// XenditAccountVerificationWebhook
///
/// Properties:
/// * [id]
/// * [forUserId]
/// * [accountId]
/// * [subaccountId]
/// * [status]
/// * [verificationStatus]
@BuiltValue()
abstract class XenditAccountVerificationWebhook implements Built<XenditAccountVerificationWebhook, XenditAccountVerificationWebhookBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'for_user_id')
  String? get forUserId;

  @BuiltValueField(wireName: r'account_id')
  String? get accountId;

  @BuiltValueField(wireName: r'subaccount_id')
  String? get subaccountId;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'verification_status')
  String? get verificationStatus;

  XenditAccountVerificationWebhook._();

  factory XenditAccountVerificationWebhook([void updates(XenditAccountVerificationWebhookBuilder b)]) = _$XenditAccountVerificationWebhook;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(XenditAccountVerificationWebhookBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<XenditAccountVerificationWebhook> get serializer => _$XenditAccountVerificationWebhookSerializer();
}

class _$XenditAccountVerificationWebhookSerializer implements PrimitiveSerializer<XenditAccountVerificationWebhook> {
  @override
  final Iterable<Type> types = const [XenditAccountVerificationWebhook, _$XenditAccountVerificationWebhook];

  @override
  final String wireName = r'XenditAccountVerificationWebhook';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    XenditAccountVerificationWebhook object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.forUserId != null) {
      yield r'for_user_id';
      yield serializers.serialize(
        object.forUserId,
        specifiedType: const FullType(String),
      );
    }
    if (object.accountId != null) {
      yield r'account_id';
      yield serializers.serialize(
        object.accountId,
        specifiedType: const FullType(String),
      );
    }
    if (object.subaccountId != null) {
      yield r'subaccount_id';
      yield serializers.serialize(
        object.subaccountId,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.verificationStatus != null) {
      yield r'verification_status';
      yield serializers.serialize(
        object.verificationStatus,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    XenditAccountVerificationWebhook object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required XenditAccountVerificationWebhookBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'for_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.forUserId = valueDes;
          break;
        case r'account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountId = valueDes;
          break;
        case r'subaccount_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subaccountId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'verification_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verificationStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  XenditAccountVerificationWebhook deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = XenditAccountVerificationWebhookBuilder();
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


