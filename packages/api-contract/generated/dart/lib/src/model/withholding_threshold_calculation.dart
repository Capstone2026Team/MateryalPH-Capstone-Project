//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/withholding_calculation_breakdown.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_threshold_calculation.g.dart';

/// Recorded components of POSTED MERCHANT_CWT assessments for the same environment and taxpayer-year accumulator. VOIDED assessments are excluded. Assessed cash is the original estimate for these assessments, before subsequent refunds; it is not a provider balance or date-filtered Earnings total.
///
/// Properties:
/// * [assessedPayments] - Number of POSTED merchant online-payment assessments included for this taxpayer and taxable year. Direct COD and In-Store cash records are excluded.
/// * [paymentPrincipalCentavos] - Original online order principal in the included assessments, before refunds. Not the all-method, date-filtered Net sales figure.
/// * [buyerProcessingFeesCentavos] - Buyer fees included in the assessed online collections. Payment principal plus these fees equals collections_centavos; Buyer fees are not sales revenue.
/// * [collectionsCentavos]
/// * [refundsCentavos]
/// * [deliveryCentavos]
/// * [materialVatCentavos]
/// * [providerChargesCentavos]
/// * [grossBasisCentavos]
/// * [withheldCentavos]
/// * [assessedCashCentavos]
/// * [withholdingBreakdown] - Optional read-only preview for explaining the recorded withholding total. Null when concurrent source changes prevent a consistent preview; the recorded total is retained. Other stores remain aggregate-only.
@BuiltValue()
abstract class WithholdingThresholdCalculation implements Built<WithholdingThresholdCalculation, WithholdingThresholdCalculationBuilder> {
  /// Number of POSTED merchant online-payment assessments included for this taxpayer and taxable year. Direct COD and In-Store cash records are excluded.
  @BuiltValueField(wireName: r'assessed_payments')
  int get assessedPayments;

  /// Original online order principal in the included assessments, before refunds. Not the all-method, date-filtered Net sales figure.
  @BuiltValueField(wireName: r'payment_principal_centavos')
  int get paymentPrincipalCentavos;

  /// Buyer fees included in the assessed online collections. Payment principal plus these fees equals collections_centavos; Buyer fees are not sales revenue.
  @BuiltValueField(wireName: r'buyer_processing_fees_centavos')
  int get buyerProcessingFeesCentavos;

  @BuiltValueField(wireName: r'collections_centavos')
  int get collectionsCentavos;

  @BuiltValueField(wireName: r'refunds_centavos')
  int get refundsCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int get deliveryCentavos;

  @BuiltValueField(wireName: r'material_vat_centavos')
  int get materialVatCentavos;

  @BuiltValueField(wireName: r'provider_charges_centavos')
  int get providerChargesCentavos;

  @BuiltValueField(wireName: r'gross_basis_centavos')
  int get grossBasisCentavos;

  @BuiltValueField(wireName: r'withheld_centavos')
  int get withheldCentavos;

  @BuiltValueField(wireName: r'assessed_cash_centavos')
  int get assessedCashCentavos;

  /// Optional read-only preview for explaining the recorded withholding total. Null when concurrent source changes prevent a consistent preview; the recorded total is retained. Other stores remain aggregate-only.
  @BuiltValueField(wireName: r'withholding_breakdown')
  WithholdingCalculationBreakdown? get withholdingBreakdown;

  WithholdingThresholdCalculation._();

  factory WithholdingThresholdCalculation([void updates(WithholdingThresholdCalculationBuilder b)]) = _$WithholdingThresholdCalculation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingThresholdCalculationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingThresholdCalculation> get serializer => _$WithholdingThresholdCalculationSerializer();
}

class _$WithholdingThresholdCalculationSerializer implements PrimitiveSerializer<WithholdingThresholdCalculation> {
  @override
  final Iterable<Type> types = const [WithholdingThresholdCalculation, _$WithholdingThresholdCalculation];

  @override
  final String wireName = r'WithholdingThresholdCalculation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingThresholdCalculation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assessed_payments';
    yield serializers.serialize(
      object.assessedPayments,
      specifiedType: const FullType(int),
    );
    yield r'payment_principal_centavos';
    yield serializers.serialize(
      object.paymentPrincipalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'buyer_processing_fees_centavos';
    yield serializers.serialize(
      object.buyerProcessingFeesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'collections_centavos';
    yield serializers.serialize(
      object.collectionsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refunds_centavos';
    yield serializers.serialize(
      object.refundsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType(int),
    );
    yield r'material_vat_centavos';
    yield serializers.serialize(
      object.materialVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'provider_charges_centavos';
    yield serializers.serialize(
      object.providerChargesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'gross_basis_centavos';
    yield serializers.serialize(
      object.grossBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'withheld_centavos';
    yield serializers.serialize(
      object.withheldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'assessed_cash_centavos';
    yield serializers.serialize(
      object.assessedCashCentavos,
      specifiedType: const FullType(int),
    );
    if (object.withholdingBreakdown != null) {
      yield r'withholding_breakdown';
      yield serializers.serialize(
        object.withholdingBreakdown,
        specifiedType: const FullType.nullable(WithholdingCalculationBreakdown),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingThresholdCalculation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingThresholdCalculationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assessed_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assessedPayments = valueDes;
          break;
        case r'payment_principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentPrincipalCentavos = valueDes;
          break;
        case r'buyer_processing_fees_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyerProcessingFeesCentavos = valueDes;
          break;
        case r'collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.collectionsCentavos = valueDes;
          break;
        case r'refunds_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundsCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deliveryCentavos = valueDes;
          break;
        case r'material_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialVatCentavos = valueDes;
          break;
        case r'provider_charges_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.providerChargesCentavos = valueDes;
          break;
        case r'gross_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossBasisCentavos = valueDes;
          break;
        case r'withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withheldCentavos = valueDes;
          break;
        case r'assessed_cash_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assessedCashCentavos = valueDes;
          break;
        case r'withholding_breakdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WithholdingCalculationBreakdown),
          ) as WithholdingCalculationBreakdown?;
          if (valueDes == null) continue;
          result.withholdingBreakdown.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingThresholdCalculation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingThresholdCalculationBuilder();
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


