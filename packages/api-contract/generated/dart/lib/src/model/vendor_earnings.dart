//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_earnings_products.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_trend.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_breakdown.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings.g.dart';

/// VendorEarnings
///
/// Properties:
/// * [demo]
/// * [environment]
/// * [notice]
/// * [commercialSalesCentavos] - Latest financial-snapshot total (materials after vendor discount, VAT included, plus delivery) of orders accepted in the range, leaving out declined, expired, cancelled and unconfirmed orders and orders whose payment was fully refunded. The Dashboard's Product sales value uses the same rule.
/// * [includedVatCentavos]
/// * [onlineCollectionsCentavos] - Verified online principal less confirmed refunded principal, attributed to the original payment date; fully refunded principal contributes zero.
/// * [onlineRefundsCentavos] - Confirmed online refunds, including their refunded Buyer fees, attributed to the original payment date. Pending and failed refunds do not reduce collections.
/// * [buyerProcessingFeesCentavos]
/// * [physicalCollectionsCentavos]
/// * [providerChargesCentavos]
/// * [simulatedCwtCentavos]
/// * [estimatedRemittanceCashCentavos]
/// * [remittanceCollectionsCentavos] - Original collected amounts, including Buyer processing fees, of POSTED assessments and confirmed fully refunded VOIDED assessments in the selected assessment-date range. Fully refunded amounts appear in both collections and refunds and cancel out; their provider charge, CWT and net cash remain zero.
/// * [remittanceRefundsCentavos] - Refund allocations already applied to remittances plus subsequent confirmed full and partial refunds, counted once and allocated up to the original collection. Includes fully refunded VOIDED assessments, so refund visibility is preserved without counting refunded money as earnings. Pending and failed refunds do not reduce cash. Uses the same assessment-date range as estimated_remittance_cash_centavos.
/// * [earnedCommissionCentavos] - Signed commission earnings less approved credits, by earned_at and approved_at respectively; shared with Admin Finance. Can be negative in a credit-only period.
/// * [estimatedCommissionCentavos]
/// * [unpaidStatementsCentavos]
/// * [breakdown]
/// * [products]
/// * [trend]
@BuiltValue()
abstract class VendorEarnings implements Built<VendorEarnings, VendorEarningsBuilder> {
  @BuiltValueField(wireName: r'demo')
  bool get demo;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  /// Latest financial-snapshot total (materials after vendor discount, VAT included, plus delivery) of orders accepted in the range, leaving out declined, expired, cancelled and unconfirmed orders and orders whose payment was fully refunded. The Dashboard's Product sales value uses the same rule.
  @BuiltValueField(wireName: r'commercial_sales_centavos')
  int get commercialSalesCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

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

  /// Original collected amounts, including Buyer processing fees, of POSTED assessments and confirmed fully refunded VOIDED assessments in the selected assessment-date range. Fully refunded amounts appear in both collections and refunds and cancel out; their provider charge, CWT and net cash remain zero.
  @BuiltValueField(wireName: r'remittance_collections_centavos')
  int get remittanceCollectionsCentavos;

  /// Refund allocations already applied to remittances plus subsequent confirmed full and partial refunds, counted once and allocated up to the original collection. Includes fully refunded VOIDED assessments, so refund visibility is preserved without counting refunded money as earnings. Pending and failed refunds do not reduce cash. Uses the same assessment-date range as estimated_remittance_cash_centavos.
  @BuiltValueField(wireName: r'remittance_refunds_centavos')
  int get remittanceRefundsCentavos;

  /// Signed commission earnings less approved credits, by earned_at and approved_at respectively; shared with Admin Finance. Can be negative in a credit-only period.
  @BuiltValueField(wireName: r'earned_commission_centavos')
  int get earnedCommissionCentavos;

  @BuiltValueField(wireName: r'estimated_commission_centavos')
  int get estimatedCommissionCentavos;

  @BuiltValueField(wireName: r'unpaid_statements_centavos')
  int get unpaidStatementsCentavos;

  @BuiltValueField(wireName: r'breakdown')
  VendorEarningsBreakdown get breakdown;

  @BuiltValueField(wireName: r'products')
  VendorEarningsProducts get products;

  @BuiltValueField(wireName: r'trend')
  VendorEarningsTrend get trend;

  VendorEarnings._();

  factory VendorEarnings([void updates(VendorEarningsBuilder b)]) = _$VendorEarnings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarnings> get serializer => _$VendorEarningsSerializer();
}

class _$VendorEarningsSerializer implements PrimitiveSerializer<VendorEarnings> {
  @override
  final Iterable<Type> types = const [VendorEarnings, _$VendorEarnings];

  @override
  final String wireName = r'VendorEarnings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarnings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'demo';
    yield serializers.serialize(
      object.demo,
      specifiedType: const FullType(bool),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
    yield r'commercial_sales_centavos';
    yield serializers.serialize(
      object.commercialSalesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
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
    yield r'remittance_collections_centavos';
    yield serializers.serialize(
      object.remittanceCollectionsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'remittance_refunds_centavos';
    yield serializers.serialize(
      object.remittanceRefundsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'earned_commission_centavos';
    yield serializers.serialize(
      object.earnedCommissionCentavos,
      specifiedType: const FullType(int),
    );
    yield r'estimated_commission_centavos';
    yield serializers.serialize(
      object.estimatedCommissionCentavos,
      specifiedType: const FullType(int),
    );
    yield r'unpaid_statements_centavos';
    yield serializers.serialize(
      object.unpaidStatementsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'breakdown';
    yield serializers.serialize(
      object.breakdown,
      specifiedType: const FullType(VendorEarningsBreakdown),
    );
    yield r'products';
    yield serializers.serialize(
      object.products,
      specifiedType: const FullType(VendorEarningsProducts),
    );
    yield r'trend';
    yield serializers.serialize(
      object.trend,
      specifiedType: const FullType(VendorEarningsTrend),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarnings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'demo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.demo = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        case r'commercial_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commercialSalesCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
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
        case r'remittance_collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remittanceCollectionsCentavos = valueDes;
          break;
        case r'remittance_refunds_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remittanceRefundsCentavos = valueDes;
          break;
        case r'earned_commission_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earnedCommissionCentavos = valueDes;
          break;
        case r'estimated_commission_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedCommissionCentavos = valueDes;
          break;
        case r'unpaid_statements_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unpaidStatementsCentavos = valueDes;
          break;
        case r'breakdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsBreakdown),
          ) as VendorEarningsBreakdown;
          result.breakdown.replace(valueDes);
          break;
        case r'products':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsProducts),
          ) as VendorEarningsProducts;
          result.products.replace(valueDes);
          break;
        case r'trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsTrend),
          ) as VendorEarningsTrend;
          result.trend.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarnings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsBuilder();
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


