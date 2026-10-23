//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_trend_point.g.dart';

/// CommissionTrendPoint
///
/// Properties:
/// * [period] - Asia/Manila day, or month start when the trend is monthly.
/// * [earnedCentavos]
/// * [creditsCentavos]
/// * [collectedCentavos]
/// * [refundedCentavos]
/// * [netEarningsCentavos] - Posted fee revenue net of credits and fee VAT, less platform commission payment processing expense. Can be negative in a refund period.
/// * [gmvCentavos] - Gross merchandise value of orders confirmed in the period (Vendor money, never platform revenue).
/// * [buyerPaymentsCentavos] - Verified online Buyer payments plus recorded Cash on Delivery and In-Store cash, received by Vendors.
/// * [buyerRefundsCentavos] - Confirmed online refunds and cash reimbursements to Buyers.
@BuiltValue()
abstract class CommissionTrendPoint implements Built<CommissionTrendPoint, CommissionTrendPointBuilder> {
  /// Asia/Manila day, or month start when the trend is monthly.
  @BuiltValueField(wireName: r'period')
  Date get period;

  @BuiltValueField(wireName: r'earned_centavos')
  int get earnedCentavos;

  @BuiltValueField(wireName: r'credits_centavos')
  int get creditsCentavos;

  @BuiltValueField(wireName: r'collected_centavos')
  int get collectedCentavos;

  @BuiltValueField(wireName: r'refunded_centavos')
  int get refundedCentavos;

  /// Posted fee revenue net of credits and fee VAT, less platform commission payment processing expense. Can be negative in a refund period.
  @BuiltValueField(wireName: r'net_earnings_centavos')
  int get netEarningsCentavos;

  /// Gross merchandise value of orders confirmed in the period (Vendor money, never platform revenue).
  @BuiltValueField(wireName: r'gmv_centavos')
  int get gmvCentavos;

  /// Verified online Buyer payments plus recorded Cash on Delivery and In-Store cash, received by Vendors.
  @BuiltValueField(wireName: r'buyer_payments_centavos')
  int get buyerPaymentsCentavos;

  /// Confirmed online refunds and cash reimbursements to Buyers.
  @BuiltValueField(wireName: r'buyer_refunds_centavos')
  int get buyerRefundsCentavos;

  CommissionTrendPoint._();

  factory CommissionTrendPoint([void updates(CommissionTrendPointBuilder b)]) = _$CommissionTrendPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionTrendPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionTrendPoint> get serializer => _$CommissionTrendPointSerializer();
}

class _$CommissionTrendPointSerializer implements PrimitiveSerializer<CommissionTrendPoint> {
  @override
  final Iterable<Type> types = const [CommissionTrendPoint, _$CommissionTrendPoint];

  @override
  final String wireName = r'CommissionTrendPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(Date),
    );
    yield r'earned_centavos';
    yield serializers.serialize(
      object.earnedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'credits_centavos';
    yield serializers.serialize(
      object.creditsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'collected_centavos';
    yield serializers.serialize(
      object.collectedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refunded_centavos';
    yield serializers.serialize(
      object.refundedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'net_earnings_centavos';
    yield serializers.serialize(
      object.netEarningsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'gmv_centavos';
    yield serializers.serialize(
      object.gmvCentavos,
      specifiedType: const FullType(int),
    );
    yield r'buyer_payments_centavos';
    yield serializers.serialize(
      object.buyerPaymentsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'buyer_refunds_centavos';
    yield serializers.serialize(
      object.buyerRefundsCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionTrendPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.period = valueDes;
          break;
        case r'earned_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earnedCentavos = valueDes;
          break;
        case r'credits_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.creditsCentavos = valueDes;
          break;
        case r'collected_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.collectedCentavos = valueDes;
          break;
        case r'refunded_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundedCentavos = valueDes;
          break;
        case r'net_earnings_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netEarningsCentavos = valueDes;
          break;
        case r'gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gmvCentavos = valueDes;
          break;
        case r'buyer_payments_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyerPaymentsCentavos = valueDes;
          break;
        case r'buyer_refunds_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyerRefundsCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionTrendPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionTrendPointBuilder();
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


