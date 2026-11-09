import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  final data = standardSerializers.deserializeWith(IntegrationOverview.serializer, {
    'generated_at': '2026-11-07T03:00:00Z', 'environment': {'deployment': 'HOSTINGER_VPS'}, 'integrations': [],
    'queues': {'failed_jobs': 5, 'dead_letters': 8}, 'scheduled_tasks': [], 'analytics': {}, 'can_retry': false,
    'automatic_recovery': {'status': 'OVERDUE', 'max_cycles': 3, 'delays_minutes': [15, 60, 360], 'last_started_at': null},
  })!;
  if (data.environment['deployment']?.value != 'HOSTINGER_VPS' || data.queues['failed_jobs']?.value != 5 || data.queues['dead_letters']?.value != 8 ||
      data.automaticRecovery?.maxCycles != AutomaticRecoveryHealthMaxCyclesEnum.number3 ||
      data.automaticRecovery?.status != AutomaticRecoveryHealthStatusEnum.OVERDUE) {
    throw StateError('Recovery metadata and existing queue counts must survive decoding.');
  }
  final failure = standardSerializers.deserializeWith(OperationFailure.serializer, {
    'kind': 'OUTBOX_EVENT', 'reference': 'event', 'label': 'Notice', 'queue': 'default', 'failure': 'Delivery attempts exhausted',
    'failed_at': '2026-11-07T03:00:00Z', 'retryable': true, 'recovery_status': 'SCHEDULED', 'recovery_attempts': 1, 'next_retry_at': '2026-11-07T04:00:00Z',
  })!;
  if (failure.recoveryStatus != OperationFailureRecoveryStatusEnum.SCHEDULED || failure.recoveryAttempts != 1 ||
      failure.nextRetryAt != DateTime.utc(2026, 11, 7, 4)) {
    throw StateError('Failure recovery state and its eligibility instant must survive decoding.');
  }
  print('Dart Platform Monitoring contract checks passed.');
}
