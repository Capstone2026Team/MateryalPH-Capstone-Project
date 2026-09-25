//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'xendit_account_verification_webhook_data_account_info.g.dart';

/// XenditAccountVerificationWebhookDataAccountInfo
///
/// Properties:
/// * [paymentsEnabled] - Never used as proof of TEST registration or live payment permission.
@BuiltValue()
abstract class XenditAccountVerificationWebhookDataAccountInfo implements Built<XenditAccountVerificationWebhookDataAccountInfo, XenditAccountVerificationWebhookDataAccountInfoBuilder> {
  /// Never used as proof of TEST registration or live payment permission.
  @BuiltValueField(wireName: r'payments_enabled')
  bool? get paymentsEnabled;

  XenditAccountVerificationWebhookDataAccountInfo._();

  factory XenditAccountVerificationWebhookDataAccountInfo([void updates(XenditAccountVerificationWebhookDataAccountInfoBuilder b)]) = _$XenditAccountVerificationWebhookDataAccountInfo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(XenditAccountVerificationWebhookDataAccountInfoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<XenditAccountVerificationWebhookDataAccountInfo> get serializer => _$XenditAccountVerificationWebhookDataAccountInfoSerializer();
}

class _$XenditAccountVerificationWebhookDataAccountInfoSerializer implements PrimitiveSerializer<XenditAccountVerificationWebhookDataAccountInfo> {
  @override
  final Iterable<Type> types = const [XenditAccountVerificationWebhookDataAccountInfo, _$XenditAccountVerificationWebhookDataAccountInfo];

  @override
  final String wireName = r'XenditAccountVerificationWebhookDataAccountInfo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    XenditAccountVerificationWebhookDataAccountInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.paymentsEnabled != null) {
      yield r'payments_enabled';
      yield serializers.serialize(
        object.paymentsEnabled,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    XenditAccountVerificationWebhookDataAccountInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required XenditAccountVerificationWebhookDataAccountInfoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payments_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.paymentsEnabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  XenditAccountVerificationWebhookDataAccountInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = XenditAccountVerificationWebhookDataAccountInfoBuilder();
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


