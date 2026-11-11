import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  final period = <String, Object?>{
    'label': '2026',
    'starts_on': '2026-01-01',
    'ends_on': '2026-12-31',
    'resets_at': '2026-12-31T16:00:00.000Z',
    'collected_centavos': 10000,
    'refunded_centavos': 20000,
    'net_collected_centavos': -10000,
  };
  final history = standardSerializers.deserializeWith(
    CommissionPaymentHistory.serializer,
    {'items': [period], 'page': 2, 'per_page': 10, 'total': 11, 'has_more': false},
  )!;
  final payment = history.items.single;
  if (history.page != 2 || history.total != 11 || history.hasMore ||
      payment.netCollectedCentavos != -10000 ||
      payment.resetsAt != DateTime.utc(2026, 12, 31, 16)) {
    throw StateError('Commission periods must preserve history, reset time and negative-net refunds.');
  }
  final restored = standardSerializers.serializeWith(
    CommissionPaymentPeriod.serializer, payment,
  ) as Map<String, Object?>;
  if (restored['starts_on'] != period['starts_on'] ||
      restored['net_collected_centavos'] != period['net_collected_centavos']) {
    throw StateError('Commission payment amounts and calendar dates must survive serialization.');
  }
  print('Dart commission period and history serialization passed.');
}
