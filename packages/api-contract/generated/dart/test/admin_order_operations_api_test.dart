import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminOrderOperationsApi
void main() {
  final instance = MateryalphApiClient().getAdminOrderOperationsApi();

  group(AdminOrderOperationsApi, () {
    // reimbursements.decide. Reasoned confirmation of an evidenced reimbursement.
    //
    //Future<AdminOrderActionResultEnvelope> confirmAdminReimbursement(String reimbursementId, AdminReimbursementDecision adminReimbursementDecision) async
    test('test confirmAdminReimbursement', () async {
      // TODO
    });

    // orders.operations.view. Counts of failed and pending refunds, pending reimbursements, open cancellation requests and recent NFR events.
    //
    //Future<AdminOrderOperationsSummaryEnvelope> getAdminOrderOperationsSummary() async
    test('test getAdminOrderOperationsSummary', () async {
      // TODO
    });

    // orders.operations.view. Open Buyer requests awaiting the Vendor, earliest deadline first.
    //
    //Future<AdminCancellationRequestListEnvelope> listAdminCancellationRequests() async
    test('test listAdminCancellationRequests', () async {
      // TODO
    });

    // orders.operations.view. Refund instructions, failures first. Admins never hold or disburse funds.
    //
    //Future<AdminRefundListEnvelope> listAdminRefunds({ String state, String trigger, int page }) async
    test('test listAdminRefunds', () async {
      // TODO
    });

    // orders.operations.view. Vendor cash reimbursements of cancelled orders.
    //
    //Future<AdminReimbursementListEnvelope> listAdminReimbursements() async
    test('test listAdminReimbursements', () async {
      // TODO
    });

    // refunds.retry. Re-send a failed instruction to the original payment only.
    //
    //Future<AdminOrderActionResultEnvelope> retryAdminRefund(String refundId, String idempotencyKey) async
    test('test retryAdminRefund', () async {
      // TODO
    });

  });
}
