//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_plan_formula.g.dart';

/// DeliveryPlanFormula
///
/// Properties:
/// * [calculationVersion]
/// * [rounding]
/// * [finalFeeRule]
@BuiltValue()
abstract class DeliveryPlanFormula implements Built<DeliveryPlanFormula, DeliveryPlanFormulaBuilder> {
  @BuiltValueField(wireName: r'calculation_version')
  String get calculationVersion;

  @BuiltValueField(wireName: r'rounding')
  String get rounding;

  @BuiltValueField(wireName: r'final_fee_rule')
  String get finalFeeRule;

  DeliveryPlanFormula._();

  factory DeliveryPlanFormula([void updates(DeliveryPlanFormulaBuilder b)]) = _$DeliveryPlanFormula;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPlanFormulaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPlanFormula> get serializer => _$DeliveryPlanFormulaSerializer();
}

class _$DeliveryPlanFormulaSerializer implements PrimitiveSerializer<DeliveryPlanFormula> {
  @override
  final Iterable<Type> types = const [DeliveryPlanFormula, _$DeliveryPlanFormula];

  @override
  final String wireName = r'DeliveryPlanFormula';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPlanFormula object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'calculation_version';
    yield serializers.serialize(
      object.calculationVersion,
      specifiedType: const FullType(String),
    );
    yield r'rounding';
    yield serializers.serialize(
      object.rounding,
      specifiedType: const FullType(String),
    );
    yield r'final_fee_rule';
    yield serializers.serialize(
      object.finalFeeRule,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPlanFormula object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPlanFormulaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'calculation_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calculationVersion = valueDes;
          break;
        case r'rounding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rounding = valueDes;
          break;
        case r'final_fee_rule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.finalFeeRule = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPlanFormula deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPlanFormulaBuilder();
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


