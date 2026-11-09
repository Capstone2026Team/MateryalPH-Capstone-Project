//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_transaction_list_envelope.g.dart';

/// Owner-only paginated transaction rows. PAYMENTS lists online payment attempts (kind ONLINE) and Cash on Delivery / In-Store obligations (kind PHYSICAL, one per order) together, newest first. A PHYSICAL row has purpose CASH_ON_DELIVERY or IN_STORE_PAYMENT, a PHYSICAL_* status, gross = the cash owed at opening, no Buyer fee, collected_centavos = cash recorded, refunded_centavos = confirmed cash reimbursements, remaining_centavos = the current collectible balance (zero for PHYSICAL_RELEASED), and evidence_origin VENDOR_RECORD; cancellation releases retain their historical recorded amounts without creating debt or a refund. An online balance credit appears as its own ONLINE row. ONLINE rows preserve the original payment status and additionally return refund_state (NOT_REQUESTED, REFUND_PENDING, REFUND_FAILED, PARTIALLY_REFUNDED or REFUNDED). For ONLINE rows, gross_centavos and collected_centavos use order principal only (collection is zero for unpaid attempts); refunded_centavos uses completed principal refunds only and net_collected_centavos is verified order principal less completed principal refunds, floored at zero (zero for unpaid attempts). Buyer-paid fees and their refunds are excluded from all of these order-payment amounts. buyer_processing_fee_centavos remains separately identified provider-flow information and is never added to order gross or deducted from order principal. Original fee-inclusive provider collections/charges remain only in the recorded assessment reconciliation. Standalone REMITTANCE gross uses its recorded principal. Refunds are aggregated per original payment, never inferred from order cancellation. PAYMENTS additionally returns nullable order_after_refunds_centavos (the linked assessment principal, falling back to original payment principal, less completed principal refunds, floored at zero; null for unpaid, physical and standalone assessment rows) and net_remittance_centavos (for paid ONLINE rows with a POSTED assessment and a known assessed cash result, order_after_refunds_centavos minus recorded withholding, or zero when fully refunded; otherwise null). This retained order amount uses the same principal/refund basis as the annual threshold-payments list, excludes Buyer-paid fees and does not rewrite immutable assessment amounts. PAYMENTS rows additionally return nullable assessment_id, assessment_collected_centavos, assessment_refunds_centavos, assessment_delivery_centavos, assessment_vat_centavos, assessment_rate_basis_points, provider_charge_centavos, gross_basis_centavos, withheld_centavos, expected_cash_centavos, calculation_state, threshold_status_after, deduction_evidence_state, reconciliation_state and assessment_at. These are original MERCHANT_CWT assessment values matched by payment, order, environment and current Vendor; absent assessments and physical payments return null. assessment_delivery_centavos and assessment_vat_centavos are the original separately billed delivery and included material VAT allocated to this assessment, never current order totals. For POSTED assessments, the tax basis equals assessment_collected_centavos minus assessment_refunds_centavos minus assessment_delivery_centavos minus assessment_vat_centavos minus provider_charge_centavos. Buyer-paid processing fees are included in the recorded collection and must not be deducted again. assessment_rate_basis_points is the original effective withholding rate (50 means 0.5%, 0 means zero). Voided values remain historical and must not be displayed as current deductions or cash. Historical merchant assessments with no payment_id remain kind REMITTANCE, purpose REMITTANCE_ASSESSMENT, status ASSESSED rows in the same date-ordered, paginated list; their refunded_centavos and net_collected_centavos are null because current payment collection is not inferred. Payment-status filters exclude these standalone assessments. CSV and PDF PAYMENTS exports use the same projection. The legacy REMITTANCES API remains available. REMITTANCES rows additionally return calculation_state; VOIDED marks a collection whose whole payment was confirmed refunded, which is no remittance and no longer counts toward the FIN-04A threshold (a crossed taxable year is never lowered).
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class FinanceTransactionListEnvelope implements Built<FinanceTransactionListEnvelope, FinanceTransactionListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<BuiltMap<String, JsonObject?>> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  FinanceTransactionListEnvelope._();

  factory FinanceTransactionListEnvelope([void updates(FinanceTransactionListEnvelopeBuilder b)]) = _$FinanceTransactionListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceTransactionListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceTransactionListEnvelope> get serializer => _$FinanceTransactionListEnvelopeSerializer();
}

class _$FinanceTransactionListEnvelopeSerializer implements PrimitiveSerializer<FinanceTransactionListEnvelope> {
  @override
  final Iterable<Type> types = const [FinanceTransactionListEnvelope, _$FinanceTransactionListEnvelope];

  @override
  final String wireName = r'FinanceTransactionListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceTransactionListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceTransactionListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceTransactionListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceTransactionListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceTransactionListEnvelopeBuilder();
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


