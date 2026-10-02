//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_attempt.g.dart';

/// Client view of one payment attempt. Everything before a verified provider capture reads PENDING; a redirect never yields PAID. The hosted checkout link is returned only to its payer while open.
///
/// Properties:
/// * [id]
/// * [purpose]
/// * [status]
/// * [attemptNumber]
/// * [orderId]
/// * [statementId]
/// * [channelCode]
/// * [channelName]
/// * [principalCentavos]
/// * [processingFeeCentavos]
/// * [totalCentavos]
/// * [feeBearer]
/// * [expiresAt]
/// * [paidAt]
/// * [createdAt]
/// * [environment]
/// * [evidenceOrigin]
/// * [checkoutUrl]
/// * [canCheckStatus]
/// * [message]
@BuiltValue()
abstract class PaymentAttempt implements Built<PaymentAttempt, PaymentAttemptBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'purpose')
  PaymentAttemptPurposeEnum get purpose;
  // enum purposeEnum {  FULL_ORDER_PAYMENT,  NRPC_ASSURANCE_PAYMENT,  ORDER_BALANCE_PAYMENT,  PLATFORM_FEE_PAYMENT,  };

  @BuiltValueField(wireName: r'status')
  PaymentAttemptStatusEnum get status;
  // enum statusEnum {  PENDING,  PAID,  FAILED,  EXPIRED,  CAPTURED_LATE_REFUND_PENDING,  };

  @BuiltValueField(wireName: r'attempt_number')
  int get attemptNumber;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'statement_id')
  String? get statementId;

  @BuiltValueField(wireName: r'channel_code')
  String? get channelCode;

  @BuiltValueField(wireName: r'channel_name')
  String? get channelName;

  @BuiltValueField(wireName: r'principal_centavos')
  int get principalCentavos;

  @BuiltValueField(wireName: r'processing_fee_centavos')
  int get processingFeeCentavos;

  @BuiltValueField(wireName: r'total_centavos')
  int get totalCentavos;

  @BuiltValueField(wireName: r'fee_bearer')
  PaymentAttemptFeeBearerEnum get feeBearer;
  // enum feeBearerEnum {  BUYER,  PLATFORM,  };

  @BuiltValueField(wireName: r'expires_at')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'paid_at')
  DateTime? get paidAt;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'environment')
  PaymentAttemptEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  @BuiltValueField(wireName: r'evidence_origin')
  PaymentAttemptEvidenceOriginEnum get evidenceOrigin;
  // enum evidenceOriginEnum {  XENDIT_TEST,  SIMULATED,  };

  @BuiltValueField(wireName: r'checkout_url')
  String? get checkoutUrl;

  @BuiltValueField(wireName: r'can_check_status')
  bool get canCheckStatus;

  @BuiltValueField(wireName: r'message')
  String get message;

  PaymentAttempt._();

  factory PaymentAttempt([void updates(PaymentAttemptBuilder b)]) = _$PaymentAttempt;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentAttemptBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentAttempt> get serializer => _$PaymentAttemptSerializer();
}

class _$PaymentAttemptSerializer implements PrimitiveSerializer<PaymentAttempt> {
  @override
  final Iterable<Type> types = const [PaymentAttempt, _$PaymentAttempt];

  @override
  final String wireName = r'PaymentAttempt';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentAttempt object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(PaymentAttemptPurposeEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PaymentAttemptStatusEnum),
    );
    yield r'attempt_number';
    yield serializers.serialize(
      object.attemptNumber,
      specifiedType: const FullType(int),
    );
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.statementId != null) {
      yield r'statement_id';
      yield serializers.serialize(
        object.statementId,
        specifiedType: const FullType(String),
      );
    }
    if (object.channelCode != null) {
      yield r'channel_code';
      yield serializers.serialize(
        object.channelCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.channelName != null) {
      yield r'channel_name';
      yield serializers.serialize(
        object.channelName,
        specifiedType: const FullType(String),
      );
    }
    yield r'principal_centavos';
    yield serializers.serialize(
      object.principalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'processing_fee_centavos';
    yield serializers.serialize(
      object.processingFeeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'total_centavos';
    yield serializers.serialize(
      object.totalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fee_bearer';
    yield serializers.serialize(
      object.feeBearer,
      specifiedType: const FullType(PaymentAttemptFeeBearerEnum),
    );
    if (object.expiresAt != null) {
      yield r'expires_at';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.paidAt != null) {
      yield r'paid_at';
      yield serializers.serialize(
        object.paidAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(PaymentAttemptEnvironmentEnum),
    );
    yield r'evidence_origin';
    yield serializers.serialize(
      object.evidenceOrigin,
      specifiedType: const FullType(PaymentAttemptEvidenceOriginEnum),
    );
    if (object.checkoutUrl != null) {
      yield r'checkout_url';
      yield serializers.serialize(
        object.checkoutUrl,
        specifiedType: const FullType(String),
      );
    }
    yield r'can_check_status';
    yield serializers.serialize(
      object.canCheckStatus,
      specifiedType: const FullType(bool),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentAttempt object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentAttemptBuilder result,
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
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentAttemptPurposeEnum),
          ) as PaymentAttemptPurposeEnum;
          result.purpose = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentAttemptStatusEnum),
          ) as PaymentAttemptStatusEnum;
          result.status = valueDes;
          break;
        case r'attempt_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attemptNumber = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'statement_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.statementId = valueDes;
          break;
        case r'channel_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.channelCode = valueDes;
          break;
        case r'channel_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.channelName = valueDes;
          break;
        case r'principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.principalCentavos = valueDes;
          break;
        case r'processing_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.processingFeeCentavos = valueDes;
          break;
        case r'total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCentavos = valueDes;
          break;
        case r'fee_bearer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentAttemptFeeBearerEnum),
          ) as PaymentAttemptFeeBearerEnum;
          result.feeBearer = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'paid_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.paidAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentAttemptEnvironmentEnum),
          ) as PaymentAttemptEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'evidence_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentAttemptEvidenceOriginEnum),
          ) as PaymentAttemptEvidenceOriginEnum;
          result.evidenceOrigin = valueDes;
          break;
        case r'checkout_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checkoutUrl = valueDes;
          break;
        case r'can_check_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canCheckStatus = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentAttempt deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentAttemptBuilder();
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


class PaymentAttemptPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FULL_ORDER_PAYMENT')
  static const PaymentAttemptPurposeEnum FULL_ORDER_PAYMENT = _$paymentAttemptPurposeEnum_FULL_ORDER_PAYMENT;
  @BuiltValueEnumConst(wireName: r'NRPC_ASSURANCE_PAYMENT')
  static const PaymentAttemptPurposeEnum NRPC_ASSURANCE_PAYMENT = _$paymentAttemptPurposeEnum_NRPC_ASSURANCE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'ORDER_BALANCE_PAYMENT')
  static const PaymentAttemptPurposeEnum ORDER_BALANCE_PAYMENT = _$paymentAttemptPurposeEnum_ORDER_BALANCE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PLATFORM_FEE_PAYMENT')
  static const PaymentAttemptPurposeEnum PLATFORM_FEE_PAYMENT = _$paymentAttemptPurposeEnum_PLATFORM_FEE_PAYMENT;

  static Serializer<PaymentAttemptPurposeEnum> get serializer => _$paymentAttemptPurposeEnumSerializer;

  const PaymentAttemptPurposeEnum._(String name): super(name);

  static BuiltSet<PaymentAttemptPurposeEnum> get values => _$paymentAttemptPurposeEnumValues;
  static PaymentAttemptPurposeEnum valueOf(String name) => _$paymentAttemptPurposeEnumValueOf(name);
}

class PaymentAttemptStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const PaymentAttemptStatusEnum PENDING = _$paymentAttemptStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const PaymentAttemptStatusEnum PAID = _$paymentAttemptStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const PaymentAttemptStatusEnum FAILED = _$paymentAttemptStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const PaymentAttemptStatusEnum EXPIRED = _$paymentAttemptStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CAPTURED_LATE_REFUND_PENDING')
  static const PaymentAttemptStatusEnum CAPTURED_LATE_REFUND_PENDING = _$paymentAttemptStatusEnum_CAPTURED_LATE_REFUND_PENDING;

  static Serializer<PaymentAttemptStatusEnum> get serializer => _$paymentAttemptStatusEnumSerializer;

  const PaymentAttemptStatusEnum._(String name): super(name);

  static BuiltSet<PaymentAttemptStatusEnum> get values => _$paymentAttemptStatusEnumValues;
  static PaymentAttemptStatusEnum valueOf(String name) => _$paymentAttemptStatusEnumValueOf(name);
}

class PaymentAttemptFeeBearerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const PaymentAttemptFeeBearerEnum BUYER = _$paymentAttemptFeeBearerEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const PaymentAttemptFeeBearerEnum PLATFORM = _$paymentAttemptFeeBearerEnum_PLATFORM;

  static Serializer<PaymentAttemptFeeBearerEnum> get serializer => _$paymentAttemptFeeBearerEnumSerializer;

  const PaymentAttemptFeeBearerEnum._(String name): super(name);

  static BuiltSet<PaymentAttemptFeeBearerEnum> get values => _$paymentAttemptFeeBearerEnumValues;
  static PaymentAttemptFeeBearerEnum valueOf(String name) => _$paymentAttemptFeeBearerEnumValueOf(name);
}

class PaymentAttemptEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const PaymentAttemptEnvironmentEnum TEST = _$paymentAttemptEnvironmentEnum_TEST;

  static Serializer<PaymentAttemptEnvironmentEnum> get serializer => _$paymentAttemptEnvironmentEnumSerializer;

  const PaymentAttemptEnvironmentEnum._(String name): super(name);

  static BuiltSet<PaymentAttemptEnvironmentEnum> get values => _$paymentAttemptEnvironmentEnumValues;
  static PaymentAttemptEnvironmentEnum valueOf(String name) => _$paymentAttemptEnvironmentEnumValueOf(name);
}

class PaymentAttemptEvidenceOriginEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'XENDIT_TEST')
  static const PaymentAttemptEvidenceOriginEnum XENDIT_TEST = _$paymentAttemptEvidenceOriginEnum_XENDIT_TEST;
  @BuiltValueEnumConst(wireName: r'SIMULATED')
  static const PaymentAttemptEvidenceOriginEnum SIMULATED = _$paymentAttemptEvidenceOriginEnum_SIMULATED;

  static Serializer<PaymentAttemptEvidenceOriginEnum> get serializer => _$paymentAttemptEvidenceOriginEnumSerializer;

  const PaymentAttemptEvidenceOriginEnum._(String name): super(name);

  static BuiltSet<PaymentAttemptEvidenceOriginEnum> get values => _$paymentAttemptEvidenceOriginEnumValues;
  static PaymentAttemptEvidenceOriginEnum valueOf(String name) => _$paymentAttemptEvidenceOriginEnumValueOf(name);
}

