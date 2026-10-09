import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminFinanceOperationsApi
void main() {
  final instance = MateryalphApiClient().getAdminFinanceOperationsApi();

  group(AdminFinanceOperationsApi, () {
    // finance.view. Gross and net GMV beside assessed CWT, commission, platform revenue, collected cash and receivables (DEMO).
    //
    //Future<FinanceKpiEnvelope> getFinanceKpis({ Date from, Date to }) async
    test('test getFinanceKpis', () async {
      // TODO
    });

    // finance.view. Remittance reconciliation queue with FIN-05 components and FIN-04A threshold before/after.
    //
    //Future<RemittanceQueueEnvelope> listRemittanceQueue({ String reconciliationState, String calculationState, String deductionEvidenceState, int page }) async
    test('test listRemittanceQueue', () async {
      // TODO
    });

    // finance.view. Tax adjustments with preparer, reviewer and the actions available to you.
    //
    //Future<TaxAdjustmentListEnvelope> listTaxAdjustments({ String state, int page }) async
    test('test listTaxAdjustments', () async {
      // TODO
    });

    // finance.view. Tax evidence review state; decisions are made in the Vendor Verification case.
    //
    //Future<TaxEvidenceQueueEnvelope> listTaxEvidenceQueue({ String reviewState, int page }) async
    test('test listTaxEvidenceQueue', () async {
      // TODO
    });

    // finance.review_tax. Post an approved adjustment as a linked compensating entry; posted assessments and the FIN-04A counter are never rewritten.
    //
    //Future<TaxAdjustmentEnvelope> postTaxAdjustment(String adjustmentId) async
    test('test postTaxAdjustment', () async {
      // TODO
    });

    // finance.review_tax. Record the proposed correction, reason, evidence reference and certificate impact.
    //
    //Future<TaxAdjustmentEnvelope> prepareTaxAdjustment(String adjustmentId, TaxAdjustmentPrepareRequest taxAdjustmentPrepareRequest) async
    test('test prepareTaxAdjustment', () async {
      // TODO
    });

    // finance.review_tax by a different user than the preparer.
    //
    //Future<TaxAdjustmentEnvelope> reviewTaxAdjustment(String adjustmentId, TaxAdjustmentReviewRequest taxAdjustmentReviewRequest) async
    test('test reviewTaxAdjustment', () async {
      // TODO
    });

  });
}
