//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_payment_method.g.dart';

/// FinancePaymentMethod
///
/// Properties:
/// * [method] - Xendit channel code, CASH_ON_DELIVERY or IN_STORE.
/// * [label]
/// * [kind]
/// * [payments] - Verified captures, or recorded cash collections.
/// * [amountCentavos]
@BuiltValue()
abstract class FinancePaymentMethod implements Built<FinancePaymentMethod, FinancePaymentMethodBuilder> {
  /// Xendit channel code, CASH_ON_DELIVERY or IN_STORE.
  @BuiltValueField(wireName: r'method')
  String get method;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'kind')
  FinancePaymentMethodKindEnum get kind;
  // enum kindEnum {  ONLINE,  PHYSICAL,  };

  /// Verified captures, or recorded cash collections.
  @BuiltValueField(wireName: r'payments')
  int get payments;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  FinancePaymentMethod._();

  factory FinancePaymentMethod([void updates(FinancePaymentMethodBuilder b)]) = _$FinancePaymentMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinancePaymentMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinancePaymentMethod> get serializer => _$FinancePaymentMethodSerializer();
}

class _$FinancePaymentMethodSerializer implements PrimitiveSerializer<FinancePaymentMethod> {
  @override
  final Iterable<Type> types = const [FinancePaymentMethod, _$FinancePaymentMethod];

  @override
  final String wireName = r'FinancePaymentMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinancePaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(FinancePaymentMethodKindEnum),
    );
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(int),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinancePaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinancePaymentMethodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.method = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinancePaymentMethodKindEnum),
          ) as FinancePaymentMethodKindEnum;
          result.kind = valueDes;
          break;
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payments = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinancePaymentMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinancePaymentMethodBuilder();
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


class FinancePaymentMethodKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const FinancePaymentMethodKindEnum ONLINE = _$financePaymentMethodKindEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'PHYSICAL')
  static const FinancePaymentMethodKindEnum PHYSICAL = _$financePaymentMethodKindEnum_PHYSICAL;

  static Serializer<FinancePaymentMethodKindEnum> get serializer => _$financePaymentMethodKindEnumSerializer;

  const FinancePaymentMethodKindEnum._(String name): super(name);

  static BuiltSet<FinancePaymentMethodKindEnum> get values => _$financePaymentMethodKindEnumValues;
  static FinancePaymentMethodKindEnum valueOf(String name) => _$financePaymentMethodKindEnumValueOf(name);
}

