//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_trend_change.g.dart';

/// Percent change of each figure against the previous period, one decimal; null when the previous total is zero.
///
/// Properties:
/// * [commercialSalesCentavos]
/// * [onlineCollectionsCentavos]
/// * [onlineRefundsCentavos]
/// * [buyerProcessingFeesCentavos]
/// * [physicalCollectionsCentavos]
/// * [providerChargesCentavos]
/// * [simulatedCwtCentavos]
/// * [estimatedRemittanceCashCentavos]
/// * [earnedCommissionCentavos]
@BuiltValue()
abstract class VendorEarningsTrendChange implements Built<VendorEarningsTrendChange, VendorEarningsTrendChangeBuilder> {
  @BuiltValueField(wireName: r'commercial_sales_centavos')
  num? get commercialSalesCentavos;

  @BuiltValueField(wireName: r'online_collections_centavos')
  num? get onlineCollectionsCentavos;

  @BuiltValueField(wireName: r'online_refunds_centavos')
  num? get onlineRefundsCentavos;

  @BuiltValueField(wireName: r'buyer_processing_fees_centavos')
  num? get buyerProcessingFeesCentavos;

  @BuiltValueField(wireName: r'physical_collections_centavos')
  num? get physicalCollectionsCentavos;

  @BuiltValueField(wireName: r'provider_charges_centavos')
  num? get providerChargesCentavos;

  @BuiltValueField(wireName: r'simulated_cwt_centavos')
  num? get simulatedCwtCentavos;

  @BuiltValueField(wireName: r'estimated_remittance_cash_centavos')
  num? get estimatedRemittanceCashCentavos;

  @BuiltValueField(wireName: r'earned_commission_centavos')
  num? get earnedCommissionCentavos;

  VendorEarningsTrendChange._();

  factory VendorEarningsTrendChange([void updates(VendorEarningsTrendChangeBuilder b)]) = _$VendorEarningsTrendChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsTrendChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsTrendChange> get serializer => _$VendorEarningsTrendChangeSerializer();
}

class _$VendorEarningsTrendChangeSerializer implements PrimitiveSerializer<VendorEarningsTrendChange> {
  @override
  final Iterable<Type> types = const [VendorEarningsTrendChange, _$VendorEarningsTrendChange];

  @override
  final String wireName = r'VendorEarningsTrendChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsTrendChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'commercial_sales_centavos';
    yield object.commercialSalesCentavos == null ? null : serializers.serialize(
      object.commercialSalesCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'online_collections_centavos';
    yield object.onlineCollectionsCentavos == null ? null : serializers.serialize(
      object.onlineCollectionsCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'online_refunds_centavos';
    yield object.onlineRefundsCentavos == null ? null : serializers.serialize(
      object.onlineRefundsCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'buyer_processing_fees_centavos';
    yield object.buyerProcessingFeesCentavos == null ? null : serializers.serialize(
      object.buyerProcessingFeesCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'physical_collections_centavos';
    yield object.physicalCollectionsCentavos == null ? null : serializers.serialize(
      object.physicalCollectionsCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'provider_charges_centavos';
    yield object.providerChargesCentavos == null ? null : serializers.serialize(
      object.providerChargesCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'simulated_cwt_centavos';
    yield object.simulatedCwtCentavos == null ? null : serializers.serialize(
      object.simulatedCwtCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'estimated_remittance_cash_centavos';
    yield object.estimatedRemittanceCashCentavos == null ? null : serializers.serialize(
      object.estimatedRemittanceCashCentavos,
      specifiedType: const FullType.nullable(num),
    );
    yield r'earned_commission_centavos';
    yield object.earnedCommissionCentavos == null ? null : serializers.serialize(
      object.earnedCommissionCentavos,
      specifiedType: const FullType.nullable(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsTrendChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsTrendChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'commercial_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.commercialSalesCentavos = valueDes;
          break;
        case r'online_collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.onlineCollectionsCentavos = valueDes;
          break;
        case r'online_refunds_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.onlineRefundsCentavos = valueDes;
          break;
        case r'buyer_processing_fees_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.buyerProcessingFeesCentavos = valueDes;
          break;
        case r'physical_collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.physicalCollectionsCentavos = valueDes;
          break;
        case r'provider_charges_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.providerChargesCentavos = valueDes;
          break;
        case r'simulated_cwt_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.simulatedCwtCentavos = valueDes;
          break;
        case r'estimated_remittance_cash_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.estimatedRemittanceCashCentavos = valueDes;
          break;
        case r'earned_commission_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.earnedCommissionCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsTrendChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsTrendChangeBuilder();
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


