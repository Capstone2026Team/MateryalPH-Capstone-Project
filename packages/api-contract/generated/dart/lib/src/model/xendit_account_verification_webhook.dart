//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/xendit_account_verification_webhook_data.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'xendit_account_verification_webhook.g.dart';

/// XenditAccountVerificationWebhook
///
/// Properties:
/// * [event]
/// * [created]
/// * [data]
@BuiltValue()
abstract class XenditAccountVerificationWebhook implements Built<XenditAccountVerificationWebhook, XenditAccountVerificationWebhookBuilder> {
  @BuiltValueField(wireName: r'event')
  XenditAccountVerificationWebhookEventEnum get event;
  // enum eventEnum {  account.registered,  account.activated,  };

  @BuiltValueField(wireName: r'created')
  DateTime get created;

  @BuiltValueField(wireName: r'data')
  XenditAccountVerificationWebhookData get data;

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
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(XenditAccountVerificationWebhookEventEnum),
    );
    yield r'created';
    yield serializers.serialize(
      object.created,
      specifiedType: const FullType(DateTime),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(XenditAccountVerificationWebhookData),
    );
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
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(XenditAccountVerificationWebhookEventEnum),
          ) as XenditAccountVerificationWebhookEventEnum;
          result.event = valueDes;
          break;
        case r'created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.created = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(XenditAccountVerificationWebhookData),
          ) as XenditAccountVerificationWebhookData;
          result.data.replace(valueDes);
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


class XenditAccountVerificationWebhookEventEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'account.registered')
  static const XenditAccountVerificationWebhookEventEnum accountPeriodRegistered = _$xenditAccountVerificationWebhookEventEnum_accountPeriodRegistered;
  @BuiltValueEnumConst(wireName: r'account.activated')
  static const XenditAccountVerificationWebhookEventEnum accountPeriodActivated = _$xenditAccountVerificationWebhookEventEnum_accountPeriodActivated;

  static Serializer<XenditAccountVerificationWebhookEventEnum> get serializer => _$xenditAccountVerificationWebhookEventEnumSerializer;

  const XenditAccountVerificationWebhookEventEnum._(String name): super(name);

  static BuiltSet<XenditAccountVerificationWebhookEventEnum> get values => _$xenditAccountVerificationWebhookEventEnumValues;
  static XenditAccountVerificationWebhookEventEnum valueOf(String name) => _$xenditAccountVerificationWebhookEventEnumValueOf(name);
}

