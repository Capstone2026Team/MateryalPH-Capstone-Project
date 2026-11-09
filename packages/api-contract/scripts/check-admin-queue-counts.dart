import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  const counts = {'OPEN': 32, 'CLOSED': 0};
  final compliance = standardSerializers.deserializeWith(
    ProductComplianceQueueEnvelopeMeta.serializer,
    {'current_page': 2, 'last_page': 2, 'total': 32, 'counts': counts},
  )!;
  final enforcement = standardSerializers.deserializeWith(
    EnforcementListEnvelopeMeta.serializer,
    {'page': 2, 'per_page': 25, 'total': 32, 'has_more': false, 'counts': counts},
  )!;
  final moderation = standardSerializers.deserializeWith(
    ReviewListMeta.serializer,
    {'page': 2, 'total': 32, 'counts': counts},
  )!;
  final support = standardSerializers.deserializeWith(
    SupportPageMeta.serializer,
    {'next_cursor': null, 'counts': counts},
  )!;
  for (final actual in [compliance.counts, enforcement.counts, moderation.counts, support.counts]) {
    if (actual?['OPEN'] != 32 || actual?['CLOSED'] != 0) {
      throw StateError('Queue counts must retain full integer totals and zeroes.');
    }
  }
  final restored = standardSerializers.serializeWith(SupportPageMeta.serializer, support) as Map<String, Object?>;
  if ((restored['counts'] as Map)['CLOSED'] != 0 ||
      standardSerializers.deserializeWith(SupportPageMeta.serializer, {'next_cursor': null})!.counts != null) {
    throw StateError('Support counts must round trip and remain optional outside Admin lists.');
  }
  print('Dart queue count metadata checks passed for all four queues.');
}
