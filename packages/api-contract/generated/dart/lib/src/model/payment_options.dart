//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/payment_channel_option.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/payment_attempt.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_options.g.dart';

/// PaymentOptions
///
/// Properties:
/// * [orderId]
/// * [orderReference]
/// * [paymentDue]
/// * [purpose]
/// * [principalCentavos]
/// * [breakdown]
/// * [channels]
/// * [payBy]
/// * [environment]
/// * [evidenceOrigin]
/// * [providerReady]
/// * [latestAttempt]
/// * [notice]
@BuiltValue()
abstract class PaymentOptions implements Built<PaymentOptions, PaymentOptionsBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'payment_due')
  bool get paymentDue;

  @BuiltValueField(wireName: r'purpose')
  PaymentOptionsPurposeEnum? get purpose;
  // enum purposeEnum {  FULL_ORDER_PAYMENT,  NRPC_ASSURANCE_PAYMENT,  ORDER_BALANCE_PAYMENT,  PLATFORM_FEE_PAYMENT,  };

  @BuiltValueField(wireName: r'principal_centavos')
  int? get principalCentavos;

  @BuiltValueField(wireName: r'breakdown')
  BuiltMap<String, JsonObject?>? get breakdown;

  @BuiltValueField(wireName: r'channels')
  BuiltList<PaymentChannelOption> get channels;

  @BuiltValueField(wireName: r'pay_by')
  DateTime? get payBy;

  @BuiltValueField(wireName: r'environment')
  PaymentOptionsEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  @BuiltValueField(wireName: r'evidence_origin')
  PaymentOptionsEvidenceOriginEnum get evidenceOrigin;
  // enum evidenceOriginEnum {  XENDIT_TEST,  SIMULATED,  };

  @BuiltValueField(wireName: r'provider_ready')
  bool get providerReady;

  @BuiltValueField(wireName: r'latest_attempt')
  PaymentAttempt? get latestAttempt;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  PaymentOptions._();

  factory PaymentOptions([void updates(PaymentOptionsBuilder b)]) = _$PaymentOptions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentOptionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentOptions> get serializer => _$PaymentOptionsSerializer();
}

class _$PaymentOptionsSerializer implements PrimitiveSerializer<PaymentOptions> {
  @override
  final Iterable<Type> types = const [PaymentOptions, _$PaymentOptions];

  @override
  final String wireName = r'PaymentOptions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentOptions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'payment_due';
    yield serializers.serialize(
      object.paymentDue,
      specifiedType: const FullType(bool),
    );
    if (object.purpose != null) {
      yield r'purpose';
      yield serializers.serialize(
        object.purpose,
        specifiedType: const FullType(PaymentOptionsPurposeEnum),
      );
    }
    if (object.principalCentavos != null) {
      yield r'principal_centavos';
      yield serializers.serialize(
        object.principalCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.breakdown != null) {
      yield r'breakdown';
      yield serializers.serialize(
        object.breakdown,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'channels';
    yield serializers.serialize(
      object.channels,
      specifiedType: const FullType(BuiltList, [FullType(PaymentChannelOption)]),
    );
    if (object.payBy != null) {
      yield r'pay_by';
      yield serializers.serialize(
        object.payBy,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(PaymentOptionsEnvironmentEnum),
    );
    yield r'evidence_origin';
    yield serializers.serialize(
      object.evidenceOrigin,
      specifiedType: const FullType(PaymentOptionsEvidenceOriginEnum),
    );
    yield r'provider_ready';
    yield serializers.serialize(
      object.providerReady,
      specifiedType: const FullType(bool),
    );
    if (object.latestAttempt != null) {
      yield r'latest_attempt';
      yield serializers.serialize(
        object.latestAttempt,
        specifiedType: const FullType(PaymentAttempt),
      );
    }
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentOptions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentOptionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'payment_due':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.paymentDue = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PaymentOptionsPurposeEnum),
          ) as PaymentOptionsPurposeEnum?;
          if (valueDes == null) continue;
          result.purpose = valueDes;
          break;
        case r'principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.principalCentavos = valueDes;
          break;
        case r'breakdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.breakdown.replace(valueDes);
          break;
        case r'channels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentChannelOption)]),
          ) as BuiltList<PaymentChannelOption>;
          result.channels.replace(valueDes);
          break;
        case r'pay_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.payBy = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentOptionsEnvironmentEnum),
          ) as PaymentOptionsEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'evidence_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentOptionsEvidenceOriginEnum),
          ) as PaymentOptionsEvidenceOriginEnum;
          result.evidenceOrigin = valueDes;
          break;
        case r'provider_ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.providerReady = valueDes;
          break;
        case r'latest_attempt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PaymentAttempt),
          ) as PaymentAttempt?;
          if (valueDes == null) continue;
          result.latestAttempt.replace(valueDes);
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentOptions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentOptionsBuilder();
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


class PaymentOptionsPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FULL_ORDER_PAYMENT')
  static const PaymentOptionsPurposeEnum FULL_ORDER_PAYMENT = _$paymentOptionsPurposeEnum_FULL_ORDER_PAYMENT;
  @BuiltValueEnumConst(wireName: r'NRPC_ASSURANCE_PAYMENT')
  static const PaymentOptionsPurposeEnum NRPC_ASSURANCE_PAYMENT = _$paymentOptionsPurposeEnum_NRPC_ASSURANCE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'ORDER_BALANCE_PAYMENT')
  static const PaymentOptionsPurposeEnum ORDER_BALANCE_PAYMENT = _$paymentOptionsPurposeEnum_ORDER_BALANCE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PLATFORM_FEE_PAYMENT')
  static const PaymentOptionsPurposeEnum PLATFORM_FEE_PAYMENT = _$paymentOptionsPurposeEnum_PLATFORM_FEE_PAYMENT;

  static Serializer<PaymentOptionsPurposeEnum> get serializer => _$paymentOptionsPurposeEnumSerializer;

  const PaymentOptionsPurposeEnum._(String name): super(name);

  static BuiltSet<PaymentOptionsPurposeEnum> get values => _$paymentOptionsPurposeEnumValues;
  static PaymentOptionsPurposeEnum valueOf(String name) => _$paymentOptionsPurposeEnumValueOf(name);
}

class PaymentOptionsEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const PaymentOptionsEnvironmentEnum TEST = _$paymentOptionsEnvironmentEnum_TEST;

  static Serializer<PaymentOptionsEnvironmentEnum> get serializer => _$paymentOptionsEnvironmentEnumSerializer;

  const PaymentOptionsEnvironmentEnum._(String name): super(name);

  static BuiltSet<PaymentOptionsEnvironmentEnum> get values => _$paymentOptionsEnvironmentEnumValues;
  static PaymentOptionsEnvironmentEnum valueOf(String name) => _$paymentOptionsEnvironmentEnumValueOf(name);
}

class PaymentOptionsEvidenceOriginEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'XENDIT_TEST')
  static const PaymentOptionsEvidenceOriginEnum XENDIT_TEST = _$paymentOptionsEvidenceOriginEnum_XENDIT_TEST;
  @BuiltValueEnumConst(wireName: r'SIMULATED')
  static const PaymentOptionsEvidenceOriginEnum SIMULATED = _$paymentOptionsEvidenceOriginEnum_SIMULATED;

  static Serializer<PaymentOptionsEvidenceOriginEnum> get serializer => _$paymentOptionsEvidenceOriginEnumSerializer;

  const PaymentOptionsEvidenceOriginEnum._(String name): super(name);

  static BuiltSet<PaymentOptionsEvidenceOriginEnum> get values => _$paymentOptionsEvidenceOriginEnumValues;
  static PaymentOptionsEvidenceOriginEnum valueOf(String name) => _$paymentOptionsEvidenceOriginEnumValueOf(name);
}

