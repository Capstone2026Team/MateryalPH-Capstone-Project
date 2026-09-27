//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/xendit_account_verification_webhook_data_account_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'xendit_account_verification_webhook_data.g.dart';

/// XenditAccountVerificationWebhookData
///
/// Properties:
/// * [userId]
/// * [accountInfo]
@BuiltValue()
abstract class XenditAccountVerificationWebhookData implements Built<XenditAccountVerificationWebhookData, XenditAccountVerificationWebhookDataBuilder> {
  @BuiltValueField(wireName: r'user_id')
  String get userId;

  @BuiltValueField(wireName: r'account_info')
  XenditAccountVerificationWebhookDataAccountInfo? get accountInfo;

  XenditAccountVerificationWebhookData._();

  factory XenditAccountVerificationWebhookData([void updates(XenditAccountVerificationWebhookDataBuilder b)]) = _$XenditAccountVerificationWebhookData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(XenditAccountVerificationWebhookDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<XenditAccountVerificationWebhookData> get serializer => _$XenditAccountVerificationWebhookDataSerializer();
}

class _$XenditAccountVerificationWebhookDataSerializer implements PrimitiveSerializer<XenditAccountVerificationWebhookData> {
  @override
  final Iterable<Type> types = const [XenditAccountVerificationWebhookData, _$XenditAccountVerificationWebhookData];

  @override
  final String wireName = r'XenditAccountVerificationWebhookData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    XenditAccountVerificationWebhookData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    if (object.accountInfo != null) {
      yield r'account_info';
      yield serializers.serialize(
        object.accountInfo,
        specifiedType: const FullType(XenditAccountVerificationWebhookDataAccountInfo),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    XenditAccountVerificationWebhookData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required XenditAccountVerificationWebhookDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'account_info':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(XenditAccountVerificationWebhookDataAccountInfo),
          ) as XenditAccountVerificationWebhookDataAccountInfo?;
          if (valueDes == null) continue;
          result.accountInfo.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  XenditAccountVerificationWebhookData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = XenditAccountVerificationWebhookDataBuilder();
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


