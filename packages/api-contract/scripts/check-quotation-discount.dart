import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  final base = <String, Object?>{
    'lines': [
      {
        'variant_id': '019c6e27-e55b-73d1-87d8-4e01f1f75043',
        'quantity': '4',
        'unit_price_centavos': 1700,
      },
    ],
    'fulfillment_method': 'DELIVERY',
    'payment_method': 'ONLINE',
    'fulfillment_date': '2026-10-20',
  };
  for (final scope in ['MATERIALS', 'DELIVERY']) {
    final input = {
      ...base,
      'discount': {'scope': scope, 'percent': '12.50'},
    };
    final draft = standardSerializers.deserializeWith(
      ChatDraftContent.serializer,
      input,
    )!;
    check(
      draft.discount!.percent == '12.50',
      'Percentage precision is retained',
    );
    final json = standardSerializers.serializeWith(
      ChatDraftContent.serializer,
      draft,
    ) as Map<String, Object?>;
    check(
      (json['discount'] as Map<String, Object?>)['scope'] == scope,
      'Scope is serialized',
    );
    check(
      !json.containsKey('vendor_discount_centavos'),
      'New drafts omit the legacy discount',
    );
    check(
      (json['lines'] as List<Object?>).first is Map,
      'Material lines remain serializable',
    );
  }
  final legacy = standardSerializers.deserializeWith(
    ChatDraftContent.serializer,
    {...base, 'vendor_discount_centavos': 850},
  )!;
  check(legacy.discount == null, 'Older drafts decode without a percentage');
  final legacyJson = standardSerializers.serializeWith(
    ChatDraftContent.serializer,
    legacy,
  ) as Map<String, Object?>;
  check(
    legacyJson['vendor_discount_centavos'] == 850,
    'The original fixed amount is preserved',
  );
  final assessment = standardSerializers.deserializeWith(
    ChatQuotationDiscountAssessment.serializer,
    {
      'scope': 'DELIVERY',
      'percent': '20.00',
      'basis_centavos': 60500,
      'deduction_centavos': 12100,
    },
  )!;
  check(
    assessment.basisCentavos == 60500 && assessment.deductionCentavos == 12100,
    'Published money stays integer centavos',
  );
  final assessmentJson = standardSerializers.serializeWith(
    ChatQuotationDiscountAssessment.serializer,
    assessment,
  ) as Map<String, Object?>;
  check(
    assessmentJson['scope'] == 'DELIVERY' &&
        assessmentJson['deduction_centavos'] == 12100,
    'Published assessments round trip',
  );
  final confirmation = standardSerializers
      .deserializeWith(VendorOrderConfirmRequest.serializer, {
    'lock_version': 1,
    'lines': [
      {
        'order_line_id': '019c6e27-e55b-73d1-87d8-4e01f1f75043',
        'confirmed_quantity': '12'
      }
    ],
    'discount': {'scope': 'DELIVERY', 'percent': '20.00'},
  })!;
  final requestJson = standardSerializers.serializeWith(
          VendorOrderConfirmRequest.serializer, confirmation)
      as Map<String, Object?>;
  check((requestJson['discount'] as Map<String, Object?>)['percent'] == '20.00',
      'Order confirmations retain percentage precision');
  check(!requestJson.containsKey('vendor_discount_centavos'),
      'Percentage confirmations omit a fixed discount');
  final monetaryJson = <String, Object?>{
    'currency': 'PHP',
    'calculation_version': 'fin02.order.v1',
    'status': 'ACCEPTED',
    'materials_gross_centavos': 18000,
    'vendor_discount_centavos': 0,
    'materials_subtotal_centavos': 18000,
    'included_vat_centavos': 0,
    'vat_exclusive_centavos': 18000,
    'vat_treatment': 'NO_INCLUDED_VAT',
    'delivery': {'status': 'CONFIRMED', 'amount_centavos': 48400},
    'nrpc': {'amount_centavos': 0, 'within_order_value': true},
    'processing_fee': {
      'status': 'PENDING_PAYMENT_CHANNEL',
      'amount_centavos': null
    },
    'commercial_total_centavos': 66400,
    'excludes': ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'],
    'discount': assessmentJson,
  };
  final breakdown = standardSerializers.deserializeWith(
      MoneyBreakdown.serializer, monetaryJson)!;
  check(
      breakdown.discount!.deductionCentavos == 12100 &&
          breakdown.delivery.amountCentavos == 48400,
      'Saved breakdowns retain gross assessment and net delivery separately');
  monetaryJson.remove('discount');
  check(
      standardSerializers
              .deserializeWith(MoneyBreakdown.serializer, monetaryJson)!
              .discount ==
          null,
      'Historical payment breakdowns decode without discount metadata');
  print(
      'Vendor discount Dart codec passed: quotations, order confirmations, saved breakdowns and legacy data.');
}
