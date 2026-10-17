//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_threshold_calculation.g.dart';

/// Recorded components of POSTED MERCHANT_CWT assessments for the same environment and taxpayer-year accumulator. VOIDED assessments are excluded. Assessed cash is the original estimate for these assessments, before subsequent refunds; it is not a provider balance or date-filtered Earnings total.
///
/// Properties:
/// * [collectionsCentavos]
/// * [refundsCentavos]
/// * [deliveryCentavos]
/// * [materialVatCentavos]
/// * [providerChargesCentavos]
/// * [grossBasisCentavos]
/// * [withheldCentavos]
/// * [assessedCashCentavos]
@BuiltValue()
abstract class WithholdingThresholdCalculation implements Built<WithholdingThresholdCalculation, WithholdingThresholdCalculationBuilder> {
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


