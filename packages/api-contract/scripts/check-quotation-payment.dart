import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  final content = <String, Object?>{
    'lines': <Object>[],
    'commercial': {
      'materials_payable_centavos': 6800,
      'materials_vat_centavos': 0,
      'vendor_discount_centavos': 0,
      'delivery_centavos': 0,
      'nrpc_centavos': 0,
      'commercial_total_centavos': 6800
    },
    'fulfillment_method': 'PICKUP',
    'fulfillment_date': '2026-10-20',
    'changes': <Object>[],
    'original_changes': <Object>[],
    'price_source': 'PRIVATE_TRANSACTION',
    'processing_fee_status': 'PENDING_PAYMENT_CHANNEL',
  };
  final quotation =
      standardSerializers.deserializeWith(ChatQuotationVersion.serializer, {
    'id': 'quote',
    'version': 1,
    'latest': true,
    'state': 'PUBLISHED',
    'published_at': '2026-10-18T00:00:00Z',
    'expires_at': '2026-10-19T00:00:00Z',
    'content_hash': 'hash',
    'content': content,
    'viewed': false,
    'actions': ['accept'],
    'available_payment_methods': ['ONLINE', 'IN_STORE'],
    'selected_payment_method': null,
  })!;
  check(
      quotation.availablePaymentMethods!.contains('IN_STORE') &&
          quotation.selectedPaymentMethod == null,
      'Unaccepted versions carry available choices without selecting one');
  final encoded = standardSerializers.serializeWith(
      ChatQuotationVersion.serializer, quotation) as Map;
  check(!(encoded['content'] as Map).containsKey('payment_method'),
      'New terms have no Vendor payment selection');
  for (final method in ChatDecisionPaymentMethodEnum.values) {
    final decision = ChatDecision((b) => b
      ..versionId = 'quote'
      ..paymentMethod = method);
    final json = standardSerializers.serializeWith(
        ChatDecision.serializer, decision) as Map;
    check(json['payment_method'] == method.name,
        'Buyer method is serialized in acceptance');
  }
  final draft =
      standardSerializers.deserializeWith(ChatDraftContent.serializer, {
    'lines': <Object>[],
    'fulfillment_method': 'PICKUP',
    'fulfillment_date': '2026-10-20',
  })!;
  check(
      !(standardSerializers.serializeWith(ChatDraftContent.serializer, draft)
              as Map)
          .containsKey('payment_method'),
      'Vendor drafts do not require a payment method');
  // Older snapshots still decode with their historical preference retained in JSON.
  final historical = standardSerializers.deserializeWith(
      ChatQuotationContent.serializer,
      {...content, 'payment_method': 'ONLINE'})!;
  check(
      (standardSerializers.serializeWith(
                  ChatQuotationContent.serializer, historical)
              as Map)['payment_method'] ==
          'ONLINE',
      'Historical quotation terms remain readable');
  print(
      'Quotation payment Dart codec passed: Buyer choices, acceptance methods, new drafts and historical snapshots.');
}
