//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/withholding_payment_calculation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_calculation_breakdown.g.dart';

/// First five POSTED tax assessments from this store in assessment order, plus aggregate-only remainder across the taxpayer-year. Includes original tax assessments even when a later refund removes a payment from the retained-payment list. Preview and remainder reconcile exactly to the recorded annual basis and withholding total.
///
/// Properties:
/// * [payments]
/// * [remainingPayments]
/// * [remainingBasisCentavos]
/// * [remainingWithheldCentavos]
@BuiltValue()
abstract class WithholdingCalculationBreakdown implements Built<WithholdingCalculationBreakdown, WithholdingCalculationBreakdownBuilder> {
  @BuiltValueField(wireName: r'payments')
  BuiltList<WithholdingPaymentCalculation> get payments;

  @BuiltValueField(wireName: r'remaining_payments')
  int get remainingPayments;

  @BuiltValueField(wireName: r'remaining_basis_centavos')
  int get remainingBasisCentavos;

  @BuiltValueField(wireName: r'remaining_withheld_centavos')
  int get remainingWithheldCentavos;

  WithholdingCalculationBreakdown._();

  factory WithholdingCalculationBreakdown([void updates(WithholdingCalculationBreakdownBuilder b)]) = _$WithholdingCalculationBreakdown;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingCalculationBreakdownBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingCalculationBreakdown> get serializer => _$WithholdingCalculationBreakdownSerializer();
}

class _$WithholdingCalculationBreakdownSerializer implements PrimitiveSerializer<WithholdingCalculationBreakdown> {
  @override
  final Iterable<Type> types = const [WithholdingCalculationBreakdown, _$WithholdingCalculationBreakdown];

  @override
  final String wireName = r'WithholdingCalculationBreakdown';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingCalculationBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(BuiltList, [FullType(WithholdingPaymentCalculation)]),
    );
    yield r'remaining_payments';
    yield serializers.serialize(
      object.remainingPayments,
      specifiedType: const FullType(int),
    );
    yield r'remaining_basis_centavos';
    yield serializers.serialize(
      object.remainingBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'remaining_withheld_centavos';
    yield serializers.serialize(
      object.remainingWithheldCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingCalculationBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingCalculationBreakdownBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WithholdingPaymentCalculation)]),
          ) as BuiltList<WithholdingPaymentCalculation>;
          result.payments.replace(valueDes);
          break;
        case r'remaining_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingPayments = valueDes;
          break;
        case r'remaining_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingBasisCentavos = valueDes;
          break;
        case r'remaining_withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingWithheldCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingCalculationBreakdown deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingCalculationBreakdownBuilder();
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


