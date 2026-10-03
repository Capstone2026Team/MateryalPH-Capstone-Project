import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminFinanceApi
void main() {
  final instance = MateryalphApiClient().getAdminFinanceApi();

  group(AdminFinanceApi, () {
    // finance.approve_statements by a user different from the preparer (403 PREPARER_REVIEWER_SAME).
    //
    //Future<FinanceActionResultEnvelope> approveFeeCredit(String proposalId) async
    test('test approveFeeCredit', () async {
      // TODO
    });

    // finance.approve_statements. Issue a DRAFT; due = max(15th of next month, issue + 12 days).
    //
    //Future<FeeStatementEnvelope> approveFeeStatement(String statementId, StatementApproveRequest statementApproveRequest) async
    test('test approveFeeStatement', () async {
      // TODO
    });

    // finance.approve_statements. Idempotently draft last month's statements (also scheduled 00:05 Asia/Manila on the 1st).
    //
    //Future<FinanceActionResultEnvelope> draftFeeStatements() async
    test('test draftFeeStatements', () async {
      // TODO
    });

    // finance.view. Figures, prior-year position, declaration year, overlap, breach, reason code and status-event history. Raw TIN never returned.
    //
    //Future<WithholdingAccumulatorDetailEnvelope> getWithholdingAccumulator(String accumulatorId) async
    test('test getWithholdingAccumulator', () async {
      // TODO
    });

    // finance.view. Payment log with evidence origin and reconciliation state.
    //
    //Future<AdminPaymentListEnvelope> listAdminPayments({ int page, String state, String purpose, String evidenceOrigin, String reconciliationState }) async
    test('test listAdminPayments', () async {
      // TODO
    });

    // finance.view. Versioned TEST channel fee schedule (DEMO published rates; validate against the active Xendit agreement).
    //
    //Future<ChannelFeeVersionListEnvelope> listChannelFees() async
    test('test listChannelFees', () async {
      // TODO
    });

    // finance.view. Monthly commission statements.
    //
    //Future<FeeStatementListEnvelope> listFeeStatements({ int page, String state }) async
    test('test listFeeStatements', () async {
      // TODO
    });

    // finance.view. Reconciliation exceptions, payment mismatches, late captures, unresolved overlap, threshold adjustments, base reviews, overdue statements and fee-credit proposals.
    //
    //Future<FinanceReviewItemListEnvelope> listFinanceReviewItems({ int page, String state, String kind }) async
    test('test listFinanceReviewItems', () async {
      // TODO
    });

    // finance.view. FIN-04A accumulators.
    //
    //Future<WithholdingAccumulatorListEnvelope> listWithholdingAccumulators({ int page, String status, int taxableYear }) async
    test('test listWithholdingAccumulators', () async {
      // TODO
    });

    // finance.review_tax. Prepare a FIN-03 credit from returned exclusive value after completion.
    //
    //Future<FinanceActionResultEnvelope> proposeFeeCredit(FeeCreditProposalRequest feeCreditProposalRequest) async
    test('test proposeFeeCredit', () async {
      // TODO
    });

    // finance.record_external_evidence. Record a reasoned resolution.
    //
    //Future<FinanceActionResultEnvelope> resolveFinanceReviewItem(String itemId, ReviewResolveRequest reviewResolveRequest) async
    test('test resolveFinanceReviewItem', () async {
      // TODO
    });

    // finance.review_tax. Record the outside-platform overlap of an UNDER_REVIEW accumulator; a total above the limit breaches.
    //
    //Future<WithholdingAccumulatorDetailEnvelope> resolveWithholdingOverlap(String accumulatorId, OverlapResolveRequest overlapResolveRequest) async
    test('test resolveWithholdingOverlap', () async {
      // TODO
    });

    // finance.view. Run the bounded reconciliation sweep now.
    //
    //Future<FinanceActionResultEnvelope> runPaymentReconciliation() async
    test('test runPaymentReconciliation', () async {
      // TODO
    });

  });
}
