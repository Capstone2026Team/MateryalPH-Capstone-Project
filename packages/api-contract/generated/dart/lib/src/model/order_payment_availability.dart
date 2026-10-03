//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/payment_attempt.dart';
import 'package:materyalph_api_client/src/model/physical_payment_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_payment_availability.g.dart';

/// Order-specific payment state. Buyers see their attempts; Vendor staff see operational status only. Store-wide finance stays Owner-only in Vendor Finance.
///
/// Properties:
/// * [available]
/// * [reason]
/// * [notice]
/// * [purpose]
/// * [principalCentavos]
/// * [latestAttempt]
/// * [verifiedPayment]
/// * [attempts]
/// * [physical]
/// * [environment]
@BuiltValue()
abstract class OrderPaymentAvailability implements Built<OrderPaymentAvailability, OrderPaymentAvailabilityBuilder> {
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'notice')
  String? get notice;

  @BuiltValueField(wireName: r'purpose')
  OrderPaymentAvailabilityPurposeEnum? get purpose;
  // enum purposeEnum {  FULL_ORDER_PAYMENT,  NRPC_ASSURANCE_PAYMENT,  ORDER_BALANCE_PAYMENT,  ,  };

  @BuiltValueField(wireName: r'principal_centavos')
  int? get principalCentavos;

  @BuiltValueField(wireName: r'latest_attempt')
  PaymentAttempt? get latestAttempt;

  @BuiltValueField(wireName: r'verified_payment')
  PaymentAttempt? get verifiedPayment;

  @BuiltValueField(wireName: r'attempts')
  BuiltList<PaymentAttempt>? get attempts;

  @BuiltValueField(wireName: r'physical')
  PhysicalPaymentSummary? get physical;

  @BuiltValueField(wireName: r'environment')
  OrderPaymentAvailabilityEnvironmentEnum? get environment;
  // enum environmentEnum {  TEST,  };

  OrderPaymentAvailability._();

  factory OrderPaymentAvailability([void updates(OrderPaymentAvailabilityBuilder b)]) = _$OrderPaymentAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderPaymentAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderPaymentAvailability> get serializer => _$OrderPaymentAvailabilitySerializer();
}

class _$OrderPaymentAvailabilitySerializer implements PrimitiveSerializer<OrderPaymentAvailability> {
  @override
  final Iterable<Type> types = const [OrderPaymentAvailability, _$OrderPaymentAvailability];

  @override
  final String wireName = r'OrderPaymentAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderPaymentAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'notice';
    yield object.notice == null ? null : serializers.serialize(
      object.notice,
      specifiedType: const FullType.nullable(String),
    );
    if (object.purpose != null) {
      yield r'purpose';
      yield serializers.serialize(
        object.purpose,
        specifiedType: const FullType.nullable(OrderPaymentAvailabilityPurposeEnum),
      );
    }
    if (object.principalCentavos != null) {
      yield r'principal_centavos';
      yield serializers.serialize(
        object.principalCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.latestAttempt != null) {
      yield r'latest_attempt';
      yield serializers.serialize(
        object.latestAttempt,
        specifiedType: const FullType.nullable(PaymentAttempt),
      );
    }
    if (object.verifiedPayment != null) {
      yield r'verified_payment';
      yield serializers.serialize(
        object.verifiedPayment,
        specifiedType: const FullType.nullable(PaymentAttempt),
      );
    }
    if (object.attempts != null) {
      yield r'attempts';
      yield serializers.serialize(
        object.attempts,
        specifiedType: const FullType(BuiltList, [FullType(PaymentAttempt)]),
      );
    }
    if (object.physical != null) {
      yield r'physical';
      yield serializers.serialize(
        object.physical,
        specifiedType: const FullType(PhysicalPaymentSummary),
      );
    }
    if (object.environment != null) {
      yield r'environment';
      yield serializers.serialize(
        object.environment,
        specifiedType: const FullType(OrderPaymentAvailabilityEnvironmentEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderPaymentAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderPaymentAvailabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notice = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderPaymentAvailabilityPurposeEnum),
          ) as OrderPaymentAvailabilityPurposeEnum?;
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
        case r'latest_attempt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PaymentAttempt),
          ) as PaymentAttempt?;
          if (valueDes == null) continue;
          result.latestAttempt.replace(valueDes);
          break;
        case r'verified_payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PaymentAttempt),
          ) as PaymentAttempt?;
          if (valueDes == null) continue;
          result.verifiedPayment.replace(valueDes);
          break;
        case r'attempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(PaymentAttempt)]),
          ) as BuiltList<PaymentAttempt>?;
          if (valueDes == null) continue;
          result.attempts.replace(valueDes);
          break;
        case r'physical':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PhysicalPaymentSummary),
          ) as PhysicalPaymentSummary?;
          if (valueDes == null) continue;
          result.physical.replace(valueDes);
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderPaymentAvailabilityEnvironmentEnum),
          ) as OrderPaymentAvailabilityEnvironmentEnum?;
          if (valueDes == null) continue;
          result.environment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderPaymentAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderPaymentAvailabilityBuilder();
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


class OrderPaymentAvailabilityPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FULL_ORDER_PAYMENT')
  static const OrderPaymentAvailabilityPurposeEnum FULL_ORDER_PAYMENT = _$orderPaymentAvailabilityPurposeEnum_FULL_ORDER_PAYMENT;
  @BuiltValueEnumConst(wireName: r'NRPC_ASSURANCE_PAYMENT')
  static const OrderPaymentAvailabilityPurposeEnum NRPC_ASSURANCE_PAYMENT = _$orderPaymentAvailabilityPurposeEnum_NRPC_ASSURANCE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'ORDER_BALANCE_PAYMENT')
  static const OrderPaymentAvailabilityPurposeEnum ORDER_BALANCE_PAYMENT = _$orderPaymentAvailabilityPurposeEnum_ORDER_BALANCE_PAYMENT;

  static Serializer<OrderPaymentAvailabilityPurposeEnum> get serializer => _$orderPaymentAvailabilityPurposeEnumSerializer;

  const OrderPaymentAvailabilityPurposeEnum._(String name): super(name);

  static BuiltSet<OrderPaymentAvailabilityPurposeEnum> get values => _$orderPaymentAvailabilityPurposeEnumValues;
  static OrderPaymentAvailabilityPurposeEnum valueOf(String name) => _$orderPaymentAvailabilityPurposeEnumValueOf(name);
}

class OrderPaymentAvailabilityEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const OrderPaymentAvailabilityEnvironmentEnum TEST = _$orderPaymentAvailabilityEnvironmentEnum_TEST;

  static Serializer<OrderPaymentAvailabilityEnvironmentEnum> get serializer => _$orderPaymentAvailabilityEnvironmentEnumSerializer;

  const OrderPaymentAvailabilityEnvironmentEnum._(String name): super(name);

  static BuiltSet<OrderPaymentAvailabilityEnvironmentEnum> get values => _$orderPaymentAvailabilityEnvironmentEnumValues;
  static OrderPaymentAvailabilityEnvironmentEnum valueOf(String name) => _$orderPaymentAvailabilityEnvironmentEnumValueOf(name);
}

