//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_method_eligibility.g.dart';

/// PaymentMethodEligibility
///
/// Properties:
/// * [method]
/// * [available]
/// * [reason]
@BuiltValue()
abstract class PaymentMethodEligibility implements Built<PaymentMethodEligibility, PaymentMethodEligibilityBuilder> {
  @BuiltValueField(wireName: r'method')
  PaymentMethodEligibilityMethodEnum get method;
  // enum methodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  PaymentMethodEligibility._();

  factory PaymentMethodEligibility([void updates(PaymentMethodEligibilityBuilder b)]) = _$PaymentMethodEligibility;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentMethodEligibilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentMethodEligibility> get serializer => _$PaymentMethodEligibilitySerializer();
}

class _$PaymentMethodEligibilitySerializer implements PrimitiveSerializer<PaymentMethodEligibility> {
  @override
  final Iterable<Type> types = const [PaymentMethodEligibility, _$PaymentMethodEligibility];

  @override
  final String wireName = r'PaymentMethodEligibility';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentMethodEligibility object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(PaymentMethodEligibilityMethodEnum),
    );
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentMethodEligibility object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentMethodEligibilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentMethodEligibilityMethodEnum),
          ) as PaymentMethodEligibilityMethodEnum;
          result.method = valueDes;
          break;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentMethodEligibility deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentMethodEligibilityBuilder();
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


class PaymentMethodEligibilityMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const PaymentMethodEligibilityMethodEnum ONLINE = _$paymentMethodEligibilityMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const PaymentMethodEligibilityMethodEnum CASH_ON_DELIVERY = _$paymentMethodEligibilityMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const PaymentMethodEligibilityMethodEnum IN_STORE = _$paymentMethodEligibilityMethodEnum_IN_STORE;

  static Serializer<PaymentMethodEligibilityMethodEnum> get serializer => _$paymentMethodEligibilityMethodEnumSerializer;

  const PaymentMethodEligibilityMethodEnum._(String name): super(name);

  static BuiltSet<PaymentMethodEligibilityMethodEnum> get values => _$paymentMethodEligibilityMethodEnumValues;
  static PaymentMethodEligibilityMethodEnum valueOf(String name) => _$paymentMethodEligibilityMethodEnumValueOf(name);
}

