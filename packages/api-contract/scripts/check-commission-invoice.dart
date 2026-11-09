import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool value, String message) {
  if (!value) throw StateError(message);
}

void main() {
  final request = StatementInvoiceUpdateRequest((b) => b
    ..lockVersion = 4
    ..invoiceHeading = 'October commission fees'
    ..invoiceMessage = 'Thank you for your completed orders.');
  final wire = standardSerializers.serializeWith(
      StatementInvoiceUpdateRequest.serializer, request) as Map;
  check(wire['lock_version'] == 4, 'Preserve the concurrency version.');
  check(wire['invoice_heading'] == 'October commission fees',
      'Serialize the draft heading.');
  check(wire['invoice_message'] == 'Thank you for your completed orders.',
      'Serialize the Vendor message.');
  final clear = standardSerializers.serializeWith(
      StatementInvoiceUpdateRequest.serializer,
      request.rebuild((b) => b..invoiceMessage = null)) as Map;
  check(clear.containsKey('invoice_message') && clear['invoice_message'] == null,
      'Preserve an explicitly cleared nullable message.');
  final statement = standardSerializers.deserializeWith(FeeStatement.serializer, {
    'id': 'statement',
    'reference': 'SAMPLE-STMT-202610',
    'state': 'DRAFT',
    'overdue': false,
    'period_start': '2026-10-01',
    'period_end': '2026-10-31',
    'issued_on': '2026-11-01',
    'due_on': '2026-11-15',
    'charges_centavos': 20000,
    'credits_centavos': 3000,
    'paid_centavos': 0,
    'outstanding_centavos': 17000,
    'disputed_held_centavos': 0,
    'lock_version': 5,
    'sample_notice': 'SAMPLE / TEST',
    'invoice_heading': wire['invoice_heading'],
    'invoice_message': wire['invoice_message'],
  })!;
  check(statement.invoiceHeading == request.invoiceHeading &&
      statement.invoiceMessage == request.invoiceMessage &&
      statement.lockVersion == 5 &&
      statement.outstandingCentavos == 17000,
      'Read edited invoice copy without changing recorded commission amounts.');
  print('Commission invoice Dart contract passed.');
}
