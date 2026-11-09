//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_calculation.g.dart';

/// Sums of immutable POSTED assessment components for one Vendor and withholding entity in the collection month. Non-posted assessments and later tax corrections are excluded. Tax is rounded per collection, so multiplying the monthly taxable basis can differ from the recorded withholding sum.
///
/// Properties:
/// * [collectionsCentavos]
/// * [refundsCentavos]
/// * [deliveryCentavos]
/// * [vatCentavos]
/// * [providerChargeCentavos]
/// * [grossBasisCentavos]
/// * [taxableBasisCentavos]
/// * [relievedBasisCentavos]
@BuiltValue()
abstract class WithholdingCalculation implements Built<WithholdingCalculation, WithholdingCalculationBuilder> {
  @BuiltValueField(wireName: r'collections_centavos')
  int get collectionsCentavos;

  @BuiltValueField(wireName: r'refunds_centavos')
  int get refundsCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int get deliveryCentavos;

  @BuiltValueField(wireName: r'vat_centavos')
  int get vatCentavos;

  @BuiltValueField(wireName: r'provider_charge_centavos')
  int get providerChargeCentavos;

  @BuiltValueField(wireName: r'gross_basis_centavos')
  int get grossBasisCentavos;

  @BuiltValueField(wireName: r'taxable_basis_centavos')
  int get taxableBasisCentavos;

  @BuiltValueField(wireName: r'relieved_basis_centavos')
  int get relievedBasisCentavos;

  WithholdingCalculation._();

  factory WithholdingCalculation([void updates(WithholdingCalculationBuilder b)]) = _$WithholdingCalculation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingCalculationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingCalculation> get serializer => _$WithholdingCalculationSerializer();
}

class _$WithholdingCalculationSerializer implements PrimitiveSerializer<WithholdingCalculation> {
  @override
  final Iterable<Type> types = const [WithholdingCalculation, _$WithholdingCalculation];

  @override
  final String wireName = r'WithholdingCalculation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingCalculation object, {
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
    yield r'vat_centavos';
    yield serializers.serialize(
      object.vatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'provider_charge_centavos';
    yield serializers.serialize(
      object.providerChargeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'gross_basis_centavos';
    yield serializers.serialize(
      object.grossBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'taxable_basis_centavos';
    yield serializers.serialize(
      object.taxableBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'relieved_basis_centavos';
    yield serializers.serialize(
      object.relievedBasisCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingCalculation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingCalculationBuilder result,
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
        case r'vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatCentavos = valueDes;
          break;
        case r'provider_charge_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.providerChargeCentavos = valueDes;
          break;
        case r'gross_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossBasisCentavos = valueDes;
          break;
        case r'taxable_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxableBasisCentavos = valueDes;
          break;
        case r'relieved_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.relievedBasisCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingCalculation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingCalculationBuilder();
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


