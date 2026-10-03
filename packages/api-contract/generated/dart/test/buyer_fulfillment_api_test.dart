import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerFulfillmentApi
void main() {
  final instance = MateryalphApiClient().getBuyerFulfillmentApi();

  group(BuyerFulfillmentApi, () {
    // Confirm receipt of an evidenced Vendor cash reimbursement (REIMBURSEMENT_CONFIRMED). Not a provider refund.
    //
    //Future<OrderDetailEnvelope> acknowledgeBuyerReimbursement(String orderId, String reimbursementId, String idempotencyKey) async
    test('test acknowledgeBuyerReimbursement', () async {
      // TODO
    });

    // Withdraw before Vendor confirmation, cancel before paying, cancel with a reason at CONFIRMED (final at once, full refund) or request cancellation with a reason during PROCESSING (CANCELLATION_REQUESTED; the Vendor has 24 hours). Unavailable at READY_FOR_PICKUP and later (409 CANCELLATION_UNAVAILABLE with remedies). A final paid cancellation creates exactly one Cancellation Refund per original payment and submits it immediately after commit.
    //
    //Future<OrderDetailEnvelope> cancelBuyerOrder(String orderId, String idempotencyKey, BuyerCancelRequest buyerCancelRequest) async
    test('test cancelBuyerOrder', () async {
      // TODO
    });

    // Confirm receipt after DELIVERED or PICKED_UP. Completes the order once and earns the commission once.
    //
    //Future<OrderDetailEnvelope> confirmBuyerReceipt(String orderId, String idempotencyKey) async
    test('test confirmBuyerReceipt', () async {
      // TODO
    });

    // Server-computed availability and FIN-07 refund estimate from the original payments and allocations, with and without an evidenced NRPC retention.
    //
    //Future<BuyerCancellationPreviewEnvelope> getBuyerCancellationPreview(String orderId) async
    test('test getBuyerCancellationPreview', () async {
      // TODO
    });

    // Proof, problem and reimbursement evidence referenced by this order only.
    //
    //Future<Uint8List> getBuyerOrderFile(String orderId, String fileId) async
    test('test getBuyerOrderFile', () async {
      // TODO
    });

    // Report a Problem from READY_FOR_PICKUP until receipt. Pauses the 48-hour auto-confirmation; never opens a dispute or a refund.
    //
    //Future<OrderDetailEnvelope> reportBuyerProblem(String orderId, String idempotencyKey, String category, String description, { BuiltList<MultipartFile> files }) async
    test('test reportBuyerProblem', () async {
      // TODO
    });

    // Mark the reported problem resolved; the remaining auto-confirmation time resumes.
    //
    //Future<OrderDetailEnvelope> resolveBuyerProblem(String orderId, String issueId, String idempotencyKey, ProblemResolveRequest problemResolveRequest) async
    test('test resolveBuyerProblem', () async {
      // TODO
    });

    // Withdraw an open request; the order returns to PROCESSING.
    //
    //Future<OrderDetailEnvelope> withdrawBuyerCancellationRequest(String orderId, String idempotencyKey) async
    test('test withdrawBuyerCancellationRequest', () async {
      // TODO
    });

  });
}
