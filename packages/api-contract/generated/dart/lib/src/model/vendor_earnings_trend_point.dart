//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_trend_point.g.dart';

/// VendorEarningsTrendPoint
///
/// Properties:
/// * [date] - Bucket start: the day, or the first day of the month.
/// * [commercialSalesCentavos]
/// * [onlineCollectionsCentavos] - Verified online principal less confirmed refunded principal, attributed to the original payment date; fully refunded principal contributes zero.
/// * [onlineRefundsCentavos] - Confirmed online refunds, including their refunded Buyer fees, attributed to the original payment date. Pending and failed refunds do not reduce collections.
/// * [buyerProcessingFeesCentavos]
/// * [physicalCollectionsCentavos]
/// * [providerChargesCentavos]
/// * [simulatedCwtCentavos]
/// * [estimatedRemittanceCashCentavos]
/// * [earnedCommissionCentavos]
@BuiltValue()
abstract class VendorEarningsTrendPoint implements Built<VendorEarningsTrendPoint, VendorEarningsTrendPointBuilder> {
  /// Bucket start: the day, or the first day of the month.
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'commercial_sales_centavos')
  int get commercialSalesCentavos;

  /// Verified online principal less confirmed refunded principal, attributed to the original payment date; fully refunded principal contributes zero.
  @BuiltValueField(wireName: r'online_collections_centavos')
  int get onlineCollectionsCentavos;

  /// Confirmed online refunds, including their refunded Buyer fees, attributed to the original payment date. Pending and failed refunds do not reduce collections.
  @BuiltValueField(wireName: r'online_refunds_centavos')
  int get onlineRefundsCentavos;

  @BuiltValueField(wireName: r'buyer_processing_fees_centavos')
  int get buyerProcessingFeesCentavos;

  @BuiltValueField(wireName: r'physical_collections_centavos')
  int get physicalCollectionsCentavos;

  @BuiltValueField(wireName: r'provider_charges_centavos')
  int get providerChargesCentavos;

  @BuiltValueField(wireName: r'simulated_cwt_centavos')
  int get simulatedCwtCentavos;

  @BuiltValueField(wireName: r'estimated_remittance_cash_centavos')
  int get estimatedRemittanceCashCentavos;

  @BuiltValueField(wireName: r'earned_commission_centavos')
  int get earnedCommissionCentavos;

  VendorEarningsTrendPoint._();

  factory VendorEarningsTrendPoint([void updates(VendorEarningsTrendPointBuilder b)]) = _$VendorEarningsTrendPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsTrendPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsTrendPoint> get serializer => _$VendorEarningsTrendPointSerializer();
}

class _$VendorEarningsTrendPointSerializer implements PrimitiveSerializer<VendorEarningsTrendPoint> {
  @override
  final Iterable<Type> types = const [VendorEarningsTrendPoint, _$VendorEarningsTrendPoint];

  @override
  final String wireName = r'VendorEarningsTrendPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'commercial_sales_centavos';
    yield serializers.serialize(
      object.commercialSalesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'online_collections_centavos';
    yield serializers.serialize(
      object.onlineCollectionsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'online_refunds_centavos';
    yield serializers.serialize(
      object.onlineRefundsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'buyer_processing_fees_centavos';
    yield serializers.serialize(
      object.buyerProcessingFeesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'physical_collections_centavos';
    yield serializers.serialize(
      object.physicalCollectionsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'provider_charges_centavos';
    yield serializers.serialize(
      object.providerChargesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'simulated_cwt_centavos';
    yield serializers.serialize(
      object.simulatedCwtCentavos,
      specifiedType: const FullType(int),
    );
    yield r'estimated_remittance_cash_centavos';
    yield serializers.serialize(
      object.estimatedRemittanceCashCentavos,
      specifiedType: const FullType(int),
    );
    yield r'earned_commission_centavos';
    yield serializers.serialize(
      object.earnedCommissionCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsTrendPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'commercial_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commercialSalesCentavos = valueDes;
          break;
        case r'online_collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onlineCollectionsCentavos = valueDes;
          break;
        case r'online_refunds_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onlineRefundsCentavos = valueDes;
          break;
        case r'buyer_processing_fees_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyerProcessingFeesCentavos = valueDes;
          break;
        case r'physical_collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.physicalCollectionsCentavos = valueDes;
          break;
        case r'provider_charges_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.providerChargesCentavos = valueDes;
          break;
        case r'simulated_cwt_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.simulatedCwtCentavos = valueDes;
          break;
        case r'estimated_remittance_cash_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedRemittanceCashCentavos = valueDes;
          break;
        case r'earned_commission_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  VendorEarningsTrendPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsTrendPointBuilder();
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


