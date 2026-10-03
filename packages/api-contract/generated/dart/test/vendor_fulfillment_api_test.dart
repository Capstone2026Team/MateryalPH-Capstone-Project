import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorFulfillmentApi
void main() {
  final instance = MateryalphApiClient().getVendorFulfillmentApi();

  group(VendorFulfillmentApi, () {
    // Owner or Store Manager assign or reassign Fulfillment Staff. The former assignee loses order, thread, file and realtime access immediately; history keeps its attribution.
    //
    //Future<OrderDetailEnvelope> assignVendorFulfillmentStaff(String orderId, String idempotencyKey, FulfillmentAssignmentRequest fulfillmentAssignmentRequest) async
    test('test assignVendorFulfillmentStaff', () async {
      // TODO
    });

    // Owner, Store Manager or Store Staff cancel with a reason before DELIVERED/PICKED_UP: NRPC forfeited, every Buyer-paid amount refunded to the original method, reservation released, NFR event recorded.
    //
    //Future<OrderDetailEnvelope> cancelVendorOrder(String orderId, String idempotencyKey, VendorCancelRequest vendorCancelRequest) async
    test('test cancelVendorOrder', () async {
      // TODO
    });

    // Finalize a Buyer request within 24 hours. Retaining the accepted NRPC requires preparation evidence; otherwise everything is refunded. The Vendor cannot refuse a permitted request.
    //
    //Future<OrderDetailEnvelope> finalizeVendorCancellationRequest(String orderId, String idempotencyKey, bool retainNrpc, { String note, MultipartFile file }) async
    test('test finalizeVendorCancellationRequest', () async {
      // TODO
    });

    // Owner, Store Manager or Store Staff: FIN-07 amounts for a Vendor cancellation and for finalizing an open Buyer request.
    //
    //Future<VendorCancellationPreviewEnvelope> getVendorCancellationPreview(String orderId) async
    test('test getVendorCancellationPreview', () async {
      // TODO
    });

    // Order evidence for authorized Vendor users of this order; Fulfillment Staff only while assigned.
    //
    //Future<Uint8List> getVendorOrderFile(String orderId, String fileId) async
    test('test getVendorOrderFile', () async {
      // TODO
    });

    // Owner or Store Manager: active Fulfillment Staff that can be assigned.
    //
    //Future<FulfillmentAssigneeListEnvelope> listVendorFulfillmentAssignees(String orderId) async
    test('test listVendorFulfillmentAssignees', () async {
      // TODO
    });

    // Owner, Store Manager or the assigned Fulfillment Staff record the next milestone through the shared state machine. Duplicate → replay or 409 MILESTONE_ALREADY_RECORDED; out of order → 409 ORDER_STATE_CONFLICT; open cancellation request → 409 CANCELLATION_PENDING; missing proof → 422 PROOF_REQUIRED. READY_FOR_PICKUP or OUT_FOR_DELIVERY opens the one fulfillment thread in the same transaction.
    //
    //Future<OrderDetailEnvelope> recordVendorFulfillmentMilestone(String orderId, String idempotencyKey, String milestone, int lockVersion, { int vehicleIndex, int tripNumber, String receiverName, String receiverKind, bool handoverConfirmed, String note, MultipartFile file, MultipartFile signature }) async
    test('test recordVendorFulfillmentMilestone', () async {
      // TODO
    });

    // Record another accepted trip while out for delivery; never beyond the accepted trip count.
    //
    //Future<OrderDetailEnvelope> recordVendorFulfillmentTrip(String orderId, String idempotencyKey, FulfillmentTripRequest fulfillmentTripRequest) async
    test('test recordVendorFulfillmentTrip', () async {
      // TODO
    });

    // Record returning cash collected directly, with private evidence. Confirmed by the Buyer or an authorized Admin decision.
    //
    //Future<OrderDetailEnvelope> recordVendorReimbursement(String orderId, String reimbursementId, String idempotencyKey, MultipartFile file, { DateTime reimbursedAt, String note }) async
    test('test recordVendorReimbursement', () async {
      // TODO
    });

    // Report a vehicle issue. The accepted arrangement and fee are unchanged; a different arrangement needs an authorized revision approved by the Buyer.
    //
    //Future<OrderDetailEnvelope> reportVendorVehicleIssue(String orderId, String idempotencyKey, VehicleIssueRequest vehicleIssueRequest) async
    test('test reportVendorVehicleIssue', () async {
      // TODO
    });

    // Respond to an open Buyer problem report.
    //
    //Future<OrderDetailEnvelope> respondVendorProblem(String orderId, String issueId, String idempotencyKey, ProblemResponseRequest problemResponseRequest) async
    test('test respondVendorProblem', () async {
      // TODO
    });

    // Owner only: retry a REFUND_FAILED instruction after funding is resolved. Same instruction and trigger; the next attempt uses a new provider idempotency key.
    //
    //Future<OrderDetailEnvelope> retryVendorRefund(String orderId, String refundId, String idempotencyKey) async
    test('test retryVendorRefund', () async {
      // TODO
    });

  });
}
