import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  final policy = <String, Object?>{
    'id': 'policy-2',
    'version': 2,
    'commission_basis_points': 325,
    'rate_label': '3.25%',
    'effective_from': '2026-11-01T00:00:00Z',
    'status': 'SCHEDULED',
    'agreement_version_id': null,
    'reason': null,
  };
  final policies =
      standardSerializers.deserializeWith(CommissionPolicies.serializer, {
    'current': null,
    'next': policy,
    'latest_version': 2,
    'can_manage': false,
    'versions': [policy],
  })!;
  check(policies.current == null && policies.next!.commissionBasisPoints == 325,
      'Nullable current and scheduled policies deserialize without losing the percentage.');
  final request = CommissionPolicyPublishRequest((b) => b
    ..commissionBasisPoints = 325
    ..expectedVersion = 1
    ..effectiveFrom = DateTime.utc(2026, 11, 1)
    ..vendorMessage = 'Review the updated terms'
    ..noticeOverride = true
    ..noticeOverrideReason = 'Approved shorter notice'
    ..supersedesPolicyId = 'policy-1'
    ..cancelScheduled = false
    ..reason = 'Commercial commission rate review');
  final wire = standardSerializers.serializeWith(
      CommissionPolicyPublishRequest.serializer, request) as Map;
  check(wire['commission_basis_points'] == 325 && wire['expected_version'] == 1,
      'Publishing preserves integer basis points and concurrency version.');
  check(
      wire['vendor_message'] == 'Review the updated terms' &&
          wire['notice_override'] == true &&
          wire['supersedes_policy_id'] == 'policy-1',
      'Notice override, public message and scheduled revision fields survive Dart serialization.');
  final summary = {
    for (final key in [
      'estimated',
      'earned',
      'credited',
      'net_earned',
      'unbilled',
      'draft',
      'outstanding',
      'overdue',
      'collected',
      'refunded',
      'net_collected'
    ])
      '${key}_centavos': 0
  };
  final annualPayments = {
    'label': '2026',
    'starts_on': '2026-01-01',
    'ends_on': '2026-12-31',
    'resets_at': '2027-01-01T00:00:00+08:00',
    'collected_centavos': 0,
    'refunded_centavos': 0,
    'net_collected_centavos': 0,
  };
  final monthlyPayments = {
    ...annualPayments,
    'label': 'November 2026',
    'starts_on': '2026-11-01',
    'ends_on': '2026-11-30',
    'resets_at': '2026-12-01T00:00:00+08:00',
  };
  final monitor = standardSerializers
      .deserializeWith(VendorCommissionMonitoring.serializer, {
    'current_policy': policy,
    'next_policy': null,
    'terms_accepted': false,
    'summary': summary,
    'annual_payments': annualPayments,
    'monthly_payments': monthlyPayments,
    'payment_history': {
      'items': <Object>[],
      'page': 1,
      'per_page': 10,
      'total': 0,
      'has_more': false,
    },
    'assessments': [
      {
        'id': 'assessment',
        'order_reference': 'OLD-ORDER',
        'state': 'EARNED',
        'commission_basis_centavos': 1000000,
        'commission_basis_points': 200,
        'estimated_centavos': 0,
        'earned_centavos': 20000,
        'credited_centavos': 4000,
        'net_centavos': 16000,
        'dispute_hold': false,
        'earned_at': null
      }
    ],
  })!;
  check(
      monitor.currentPolicy!.commissionBasisPoints == 325 &&
          monitor.assessments.single.commissionBasisPoints == 200,
      'Monitoring preserves each original order rate separately from the current policy.');
  check(!monitor.termsAccepted && monitor.summary.outstandingCentavos == 0,
      'Monitoring retains acceptance and recorded debt.');
  check(
      monitor.annualPayments.label == '2026' &&
          monitor.annualPayments.resetsAt == DateTime.utc(2026, 12, 31, 16) &&
          monitor.monthlyPayments.label == 'November 2026' &&
          monitor.monthlyPayments.resetsAt == DateTime.utc(2026, 11, 30, 16) &&
          monitor.monthlyPayments.netCollectedCentavos == 0,
      'Monitoring preserves calendar periods, Manila reset instants and integer payment totals.');
  check(
      monitor.paymentHistory.items.isEmpty &&
          monitor.paymentHistory.page == 1 &&
          monitor.paymentHistory.perPage ==
              CommissionPaymentHistoryPerPageEnum.number10 &&
          monitor.paymentHistory.total == 0 &&
          !monitor.paymentHistory.hasMore,
      'An empty payment history retains its pagination.');
  print('Commission policy Dart contract checks passed.');
}
