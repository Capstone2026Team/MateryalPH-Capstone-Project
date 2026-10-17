import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerOrdersApi
void main() {
  final instance = MateryalphApiClient().getBuyerOrdersApi();

  group(BuyerOrdersApi, () {
    // Explicit acceptance of the current NRPC with the Terms version displayed with it (409 NRPC_TERMS_CHANGED otherwise) and acknowledged=true. Recorded with the Terms version and time; the version is then frozen and the order becomes payable.
    //
    //Future<OrderDetailEnvelope> acceptBuyerOrderNrpc(String orderId, String idempotencyKey, NrpcAcceptRequest nrpcAcceptRequest) async
    test('test acceptBuyerOrderNrpc', () async {
      // TODO
    });

    // Accepts exactly the shown Vendor commercial version (snapshot_version). A stale version is 409 STALE_VERSION. With a proposed NRPC the order moves to AWAITING_NRPC_ACCEPTANCE; otherwise the version is frozen and the order becomes payable.
    //
    //Future<OrderDetailEnvelope> approveBuyerOrderRevision(String orderId, String idempotencyKey, OrderRevisionDecision orderRevisionDecision) async
    test('test approveBuyerOrderRevision', () async {
      // TODO
    });

    // Buy Again for a completed or cancelled Item-Based order (otherwise 409 BUY_AGAIN_UNAVAILABLE). Each line is added to the cart at today's price version and the original quantity, merged into any existing line, using the same eligibility, radius and quantity checks as adding by hand. A line that cannot be added is listed in skipped with its reason; quantities are never reduced to fit stock, so exact inventory is never revealed. Nothing is ordered or reserved. Idempotency-Key makes retries safe; a replay returns the current cart with empty added and skipped lists and meta.replayed true.
    //
    //Future<BuyAgainEnvelope> buyBuyerOrderAgain(String idempotencyKey, String orderId) async
    test('test buyBuyerOrderAgain', () async {
      // TODO
    });

    // Flags an NRPC as disproportionate for staff review. Separate from acceptance; never accepts, rejects or changes the order. One flag per NRPC.
    //
    //Future<OrderDetailEnvelope> flagBuyerOrderNrpc(String orderId, String idempotencyKey, NrpcFlagRequest nrpcFlagRequest) async
    test('test flagBuyerOrderNrpc', () async {
      // TODO
    });

    // The parent checkout with its child orders. The parent status is derived from the children and never replaces them.
    //
    //Future<CheckoutSubmissionEnvelope> getBuyerCheckout(String checkoutId) async
    test('test getBuyerCheckout', () async {
      // TODO
    });

    // Order details with immutable line snapshots, the current commercial version and change summary, separate state rows, the MoneyBreakdown (materials, discount, included VAT, delivery, NRPC within the order value, processing fee, total), the NRPC disclosure with its Terms version, the confirmed delivery drop-off before acceptance, deadlines in UTC with Asia/Manila as the display zone, and server-calculated actions. A window that has passed resolves to EXPIRED on read.
    //
    //Future<OrderDetailEnvelope> getBuyerOrder(String orderId) async
    test('test getBuyerOrder', () async {
      // TODO
    });

    // The Buyer's own orders, newest first. Status chips: CONFIRMATION (awaiting the Vendor, the Buyer's approval or NRPC acceptance, or payment), PROCESSING (confirmed, preparing, cancellation requested), TO_SHIP (ready for pickup, out for delivery), TO_RECEIVE (delivered or picked up, awaiting receipt confirmation), COMPLETED, CANCELLED (cancelled, declined, expired) and DISPUTED. procurement_type filters the Item and Project tabs; meta.counts follow the same procurement filter. Order, payment, fulfillment, refund and dispute states are separate rows. Due windows are resolved before listing. CANCELLED_REFUNDED is the Profile history of actual CANCELLED orders or orders with PARTIALLY_REFUNDED or REFUNDED refund state, filtered before pagination; declined and expired orders without a completed refund are excluded.
    //
    //Future<OrderListEnvelope> listBuyerOrders({ String group, String procurementType, int page }) async
    test('test listBuyerOrders', () async {
      // TODO
    });

    // Returns the order's single Fulfillment Messages thread, separate from inquiry conversations. Threads open at order submission; for an open order submitted before that, this opens it. One thread exists per order, so every retry returns the same thread. A closed order without a thread is 409 FULFILLMENT_THREAD_CLOSED. Another Buyer's order is 404.
    //
    //Future<OrderFulfillmentConversationEnvelope> openBuyerFulfillmentConversation(String idempotencyKey, String orderId) async
    test('test openBuyerFulfillmentConversation', () async {
      // TODO
    });

    // Rejects the current NRPC. The request is cancelled and its hard reservation released.
    //
    //Future<OrderDetailEnvelope> rejectBuyerOrderNrpc(String orderId, String idempotencyKey, NrpcRejectRequest nrpcRejectRequest) async
    test('test rejectBuyerOrderNrpc', () async {
      // TODO
    });

    // Rejects the shown Vendor version. The request is cancelled and its hard reservation released.
    //
    //Future<OrderDetailEnvelope> rejectBuyerOrderRevision(String orderId, String idempotencyKey, OrderRevisionDecision orderRevisionDecision) async
    test('test rejectBuyerOrderRevision', () async {
      // TODO
    });

    // Submits the selected READY Vendor groups of the cart as one parent checkout with one child order request per Vendor. Each child snapshots its lines (listing, variant, unit, applied price version and frozen volume tiers, tax classification, displayed image) and keeps the intended destination and any heavy-vehicle alternate drop-off as separate references. Submission never reserves stock. Submitting fewer groups than the cart holds requires split_confirmed. A retry with the same Idempotency-Key and body returns the same checkout (200, meta.replayed=true); a changed body under the key is 409 IDEMPOTENCY_CONFLICT. After commit each child order gets one all-or-nothing Item-Based auto-accept attempt.
    //
    //Future<CheckoutSubmissionEnvelope> submitBuyerCheckout(String idempotencyKey, CheckoutSubmitRequest checkoutSubmitRequest) async
    test('test submitBuyerCheckout', () async {
      // TODO
    });

  });
}
