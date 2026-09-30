import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorOrdersApi
void main() {
  final instance = MateryalphApiClient().getVendorOrdersApi();

  group(VendorOrdersApi, () {
    // Manual confirmation, permitted revision (lower quantities or an order-level discount; never a price increase) and optional manual NRPC. One transaction locks the organization, order and every inventory row in deterministic order, revalidates the store (activation, restriction, public profile), online payment capability, listings, tax classification and stock, and reserves every confirmed line or none (409 STOCK_INSUFFICIENT / STORE_NOT_ELIGIBLE / LINE_NOT_ELIGIBLE). Owner, Manager, Store Staff and Customer Service confirm unchanged orders; revisions and NRPC need Owner, Manager or Store Staff; Site Delivery vehicles, trips and the formula fee need Owner or Manager (409 DELIVERY_FEE_CHANGED if the fee differs from the formula).
    //
    //Future<OrderDetailEnvelope> confirmVendorOrder(String orderId, String idempotencyKey, VendorOrderConfirmRequest vendorOrderConfirmRequest) async
    test('test confirmVendorOrder', () async {
      // TODO
    });

    // Declines a request awaiting confirmation with a reason code and reason. Nothing is reserved before confirmation, so nothing is released.
    //
    //Future<OrderDetailEnvelope> declineVendorOrder(String orderId, String idempotencyKey, VendorOrderDeclineRequest vendorOrderDeclineRequest) async
    test('test declineVendorOrder', () async {
      // TODO
    });

    // Job-order detail with lines, authorized inventory, reservations, auto-accept outcome, confirmed delivery, NRPC, money breakdown, history, role-aware permissions and one primary action per state. Buyer coordinates are never returned.
    //
    //Future<OrderDetailEnvelope> getVendorOrder(String orderId) async
    test('test getVendorOrder', () async {
      // TODO
    });

    // Advisory vehicle, trip and formula-fee options for a Site Delivery request, routed from the store's current address to the order's frozen vehicle drop-off. Advisory only; never a confirmation.
    //
    //Future<DeliveryPlanEnvelope> getVendorOrderDeliveryPlan(String orderId, DeliveryPlanRequest deliveryPlanRequest) async
    test('test getVendorOrderDeliveryPlan', () async {
      // TODO
    });

    // Status-filtered order workspace for the current organization (NEW, WAITING_ON_BUYER, AWAITING_PAYMENT, CONFIRMED, CLOSED). Fulfillment Staff never see requests before confirmation and payment conditions. Search matches Order ID or Buyer name.
    //
    //Future<OrderListEnvelope> listVendorOrders({ String group, String q, int page }) async
    test('test listVendorOrders', () async {
      // TODO
    });

  });
}
