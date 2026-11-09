import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  final wire = <String, Object?>{
    'month': '2026-10',
    'period_start': '2026-10-01',
    'period_end': '2026-10-31',
    'environment': 'TEST',
    'assignment_status': 'UNCONFIRMED',
    'platform_withheld_centavos': 12345,
    'provider_withheld_centavos': 6789,
    'vendor_count': 1,
    'assessment_count': 2,
    'review_required': 0,
    'vendors': [
      {
        'vendor_id': 'sample-vendor',
        'vendor_name': 'Sample Supply',
        'withholding_entity': 'DEMO_PLATFORM_WITHHOLDER',
        'assessment_count': 2,
        'withheld_centavos': 12345,
        'review_required': 0,
        'calculation': {
          'collections_centavos': 3100000,
          'refunds_centavos': 100000,
          'delivery_centavos': 200000,
          'vat_centavos': 250000,
          'provider_charge_centavos': 81000,
          'gross_basis_centavos': 2469000,
          'taxable_basis_centavos': 2469000,
          'relieved_basis_centavos': 0,
        },
        'filing_issues': ['TAX_ADJUSTMENT_OPEN'],
      }
    ],
  };
  final data = standardSerializers.deserializeWith(
      WithholdingRegister.serializer, wire)!;
  if (data.platformWithheldCentavos != 12345 ||
      data.providerWithheldCentavos != 6789 ||
      data.vendors.single.withheldCentavos != 12345) {
    throw StateError('Separate withholding amounts must retain exact centavos.');
  }
  final restored = standardSerializers.serializeWith(
      WithholdingRegister.serializer, data) as Map<String, Object?>;
  if (data.vendors.single.calculation.grossBasisCentavos != 2469000 ||
      data.vendors.single.filingIssues.single.name != 'TAX_ADJUSTMENT_OPEN') {
    throw StateError('Recorded calculation components and filing issues must survive deserialization.');
  }
  if (restored['assignment_status'] != 'UNCONFIRMED' ||
      restored['environment'] != 'TEST') {
    throw StateError('The register must preserve demo responsibility limits.');
  }
  final approval = standardSerializers.deserializeWith(
    RemittanceReconciliationApproval.serializer,
    <String, Object?>{'source_version': 'a' * 64, 'reason': 'Checked the recorded sources.'},
  )!;
  if (approval.sourceVersion != 'a' * 64 || approval.reason != 'Checked the recorded sources.') {
    throw StateError('Backup approval must preserve the source version and reason.');
  }
  final decision = standardSerializers.deserializeWith(
    RemittanceReconciliationDecision.serializer,
    <String, Object?>{
      'id': 'decision-1', 'assessment_id': 'assessment-1', 'environment': 'TEST',
      'origin': 'SIMULATED', 'method': 'BACKUP_APPROVAL', 'actor_role': 'ADMIN_FINANCE',
      'reason': 'Checked the recorded sources.', 'reconciled_at': '2026-11-08T00:00:00Z',
    },
  )!;
  final decisionWire = standardSerializers.serializeWith(RemittanceReconciliationDecision.serializer, decision) as Map<String, Object?>;
  if (decisionWire['origin'] != 'SIMULATED' || decisionWire['method'] != 'BACKUP_APPROVAL' || decisionWire['actor_role'] != 'ADMIN_FINANCE') {
    throw StateError('The decision must retain its TEST origin and authorized actor.');
  }
  final row = standardSerializers.deserializeWith(RemittanceQueueRow.serializer, <String, Object?>{
    'id': 'assessment-1', 'order_reference': 'ORD-TEST', 'vendor_name': 'Sample Supply',
    'environment': 'TEST', 'taxpayer_key_suffix': '123456', 'components': {'withheld_centavos': 508},
    'calculation_state': 'POSTED', 'deduction_evidence_state': 'SIMULATED_WITHHELD', 'reconciliation_state': 'RECONCILED',
    'source_version': 'a' * 64, 'can_approve_reconciliation': false, 'reconciliation_method': 'AUTOMATIC',
    'reconciliation_actor_role': 'SYSTEM', 'reconciled_at': '2026-11-08T00:00:00Z',
    'reason': 'Recorded matching sources.', 'created_at': '2026-11-08T00:00:00Z',
  })!;
  final rowWire = standardSerializers.serializeWith(RemittanceQueueRow.serializer, row) as Map<String, Object?>;
  if (rowWire['reconciliation_method'] != 'AUTOMATIC' || rowWire['can_approve_reconciliation'] != false) {
    throw StateError('Queue records must preserve automatic decisions and denied approval access.');
  }
  final detail = standardSerializers.deserializeWith(WithholdingVendorDetail.serializer, <String, Object?>{
    'vendor_id': 'sample-vendor', 'vendor_name': 'Sample Supply', 'month': '2026-10',
    'withholding_entity': 'DEMO_PLATFORM_WITHHOLDER', 'declaration_state': 'PENDING', 'threshold': null,
    'payments': [<String, Object?>{'id': 'assessment', 'order_reference': 'MP-100', 'collected_at': '2026-10-21T10:00:00Z', 'amount_centavos': 999, 'taxable_centavos': null, 'tax_centavos': null}],
  })!;
  if (detail.threshold != null || detail.payments.single.taxCentavos != null || detail.payments.single.amountCentavos != 999) {
    throw StateError('Pending declaration and unposted amounts must retain nulls and exact centavos.');
  }
  print('Dart withholding-register and remittance-reconciliation contract checks passed.');
}
