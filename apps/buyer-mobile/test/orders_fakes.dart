import 'dart:typed_data';

import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/orders/order_models.dart';
import 'package:materyalph/features/orders/orders_repository.dart';

/// Synthetic order fixtures for widget and golden tests. Not live marketplace, payment or provider data.
List<OrderStateRowView> orderStates(
  String order, {
  String payment = 'NOT_REQUIRED',
}) => [
  OrderStateRowView('ORDER', order),
  OrderStateRowView('PAYMENT', payment),
  const OrderStateRowView('FULFILLMENT', 'NOT_STARTED'),
  const OrderStateRowView('REFUND', 'NOT_REQUESTED'),
  const OrderStateRowView('DISPUTE', 'NONE'),
];

const nrpcTerms = NrpcTermsView(
  id: 'terms-1',
  version: 1,
  title: 'Non-Recoverable Preparation Cost Terms — CAPSTONE/TEST',
  content:
      '1. What an NRPC is. A Vendor may identify part of the agreed order value as a Non-Recoverable Preparation Cost for actual irreversible preparation.\n\n2. Your decision. You may accept or reject it. Rejecting cancels the request and releases the reserved stock.\n\n3. Raising a concern. A flag creates a review record and never accepts or rejects on its own.',
);

MoneyView money({
  int materials = 18000,
  int discount = 0,
  int? delivery = 0,
  String deliveryStatus = 'NOT_APPLICABLE',
  int nrpc = 0,
  String status = 'ADVISORY_UNTIL_VENDOR_CONFIRMATION',
}) => MoneyView(
  status: status,
  materialsGrossCentavos: materials + discount,
  vendorDiscountCentavos: discount,
  materialsSubtotalCentavos: materials,
  includedVatCentavos: 0,
  pricesIncludeVat: false,
  deliveryStatus: deliveryStatus,
  deliveryCentavos: delivery,
  deliveryEstimateMin: delivery == null ? 60500 : null,
  deliveryEstimateMax: delivery == null ? 60500 : null,
  nrpcCentavos: nrpc,
  processingFeeStatus: 'PENDING_PAYMENT_CHANNEL',
  processingFeeCentavos: null,
  commercialTotalCentavos: delivery == null ? null : materials + delivery,
  amountDueOnlineCentavos: null,
  physicalBalanceCentavos: 0,
  paymentPurpose: 'FULL_ORDER_PAYMENT',
);

OrderDetailView orderDetail({
  String state = 'AWAITING_VENDOR_CONFIRMATION',
  String payment = 'NOT_REQUIRED',
  Set<String> actions = const {},
  NrpcView? nrpc,
  MoneyView? amounts,
  String fulfillment = 'PICKUP',
  List<OrderChangeView> changes = const [],
  String? confirmedQuantity,
  DateTime? paymentExpiresAt,
  DateTime? buyerResponseDueAt,
  DateTime? vendorResponseDueAt,
  bool autoAccepted = false,
  ConfirmedDeliveryView? confirmedDelivery,
  OrderPaymentView? paymentView,
  String? terminalReasonCode,
  FulfillmentView? fulfillmentView,
  CancellationView? cancellation,
  RefundTimelineView? refundTimeline,
  int lockVersion = 3,
}) => OrderDetailView(
  id: 'order-1',
  reference: 'ORD-2026-ABCD1234',
  vendorName: 'Alpha Construction Supply',
  fulfillmentMethod: fulfillment,
  submittedAt: DateTime.utc(2026, 10, 5, 1),
  states: orderStates(state, payment: payment),
  snapshotVersion: state == 'AWAITING_VENDOR_CONFIRMATION' ? 1 : 2,
  lines: [
    OrderLineView(
      id: 'line-1',
      displayName: 'Concrete Hollow Block 4"',
      variantLabel: 'Standard',
      imageUrl: null,
      unitName: 'piece',
      requestedQuantity: '10.0000',
      confirmedQuantity: confirmedQuantity,
      unitPriceCentavos: 1800,
      lineTotalCentavos: confirmedQuantity == null
          ? 18000
          : (double.parse(confirmedQuantity) * 1800).round(),
      discountCentavos: 0,
      vatLabel: 'Non-VAT seller',
      change: confirmedQuantity == null || confirmedQuantity == '10.0000'
          ? null
          : 'QUANTITY_REDUCED',
      volumeTierApplied: false,
    ),
  ],
  changes: changes,
  money: amounts ?? money(),
  timeline: [
    OrderEventView(
      family: 'ORDER',
      toState: 'AWAITING_VENDOR_CONFIRMATION',
      source: 'BUYER',
      at: DateTime.utc(2026, 10, 5, 1),
    ),
    if (state != 'AWAITING_VENDOR_CONFIRMATION')
      OrderEventView(
        family: 'ORDER',
        toState: state,
        source: autoAccepted ? 'AUTO_ACCEPT' : 'VENDOR',
        at: DateTime.utc(2026, 10, 5, 2),
      ),
  ],
  actions: actions,
  autoAccepted: autoAccepted,
  destination: fulfillment == 'PICKUP'
      ? const OrderDestinationView(
          type: 'PICKUP',
          storeAddress: '123 Aurora Boulevard, Quezon City',
        )
      : const OrderDestinationView(
          type: 'DELIVERY',
          intended: OrderPointView(
            label: 'Project site',
            formattedAddress: 'Project site, Quezon City',
          ),
          alternateDropOff: OrderPointView(
            label: 'North gate',
            formattedAddress: 'North gate, Quezon City',
          ),
          heavyVehicleRestriction: 'YES',
          vehicleEndpoint: 'ALTERNATE_DROP_OFF',
          accessInstructions: 'Forklift at the north gate.',
        ),
  confirmedDelivery: confirmedDelivery,
  nrpc: nrpc,
  vendorResponseDueAt: vendorResponseDueAt,
  buyerResponseDueAt: buyerResponseDueAt,
  paymentExpiresAt: paymentExpiresAt,
  payment: paymentView,
  terminalReasonCode: terminalReasonCode,
  paymentNotice: state == 'AWAITING_PAYMENT'
      ? 'TEST — no real charge. The order is confirmed only after the payment provider verifies your payment.'
      : null,
  lockVersion: lockVersion,
  fulfillment: fulfillmentView,
  cancellation: cancellation,
  refundTimeline: refundTimeline,
);

NrpcView nrpcView({
  String status = 'PROPOSED',
  bool flagged = false,
}) => NrpcView(
  id: 'nrpc-1',
  amountCentavos: 5000,
  reason: 'Custom cutting to the Buyer drawings',
  affectedLines: const [
    NrpcLineView(
      label: 'Concrete Hollow Block 4"',
      principalCentavos: 5000,
      linePayableCentavos: 18000,
    ),
  ],
  terms: nrpcTerms,
  cancellationEffect:
      'If you cancel during preparation and the Vendor substantiates it, the Vendor may keep this amount.',
  status: status,
  flagged: flagged,
);

OrderSummaryView orderSummary({
  String id = 'order-1',
  String state = 'AWAITING_BUYER_APPROVAL',
  String? nextAction = 'REVIEW_REVISION',
  OrderDeadlineView? deadline,
  bool paymentRetryable = false,
}) => OrderSummaryView(
  id: id,
  reference: 'ORD-2026-ABCD1234',
  vendorName: 'Alpha Construction Supply',
  submittedAt: DateTime.utc(2026, 10, 5, 1),
  states: orderStates(state),
  fulfillmentMethod: 'PICKUP',
  lineCount: 2,
  firstLineName: 'Concrete Hollow Block 4"',
  firstLineImageUrl: null,
  commercialTotalCentavos: 18000,
  deliveryPending: false,
  deadline: deadline,
  nextAction: nextAction,
  paymentRetryable: paymentRetryable,
  autoAccepted: false,
);

class FakeOrdersRepository implements OrdersRepository {
  FakeOrdersRepository({this.detail, this.list, this.checkout});

  OrderDetailView? detail;
  OrderListPage? list;
  CheckoutView? checkout;
  DiscoveryFailure? failure;
  DiscoveryFailure? paymentStartFailure;
  final List<String> calls = [];
  final List<String> keys = [];
  final List<Map<String, Object?>> submissions = [];

  OrderDetailView Function(String action)? onDecision;

  Future<T> _answer<T>(String call, T value) async {
    calls.add(call);
    if (failure != null) throw failure!;
    return value;
  }

  @override
  Future<CheckoutView> submitCheckout({
    required int cartLockVersion,
    required List<String> vendorIds,
    required bool splitConfirmed,
    required String idempotencyKey,
    Map<String, String> paymentMethods = const {},
  }) async {
    keys.add(idempotencyKey);
    submissions.add({
      'cartLockVersion': cartLockVersion,
      'vendorIds': vendorIds,
      'splitConfirmed': splitConfirmed,
      'paymentMethods': paymentMethods,
    });
    if (failure != null) {
      calls.add('submit');
      throw failure!;
    }
    return _answer('submit', checkout!);
  }

  @override
  Future<OrderListPage> orders({required String group, int page = 1}) =>
      _answer('orders:$group:$page', list!);

  @override
  Future<OrderDetailView> order(String orderId) =>
      _answer('order:$orderId', detail!);

  OrderDetailView _decide(String action, String key) {
    keys.add(key);
    return onDecision?.call(action) ?? detail!;
  }

  @override
  Future<OrderDetailView> approveRevision(
    String orderId, {
    required int snapshotVersion,
    required String idempotencyKey,
    String? budgetOverrideReason,
  }) => _answer('approve:$snapshotVersion', _decide('approve', idempotencyKey));

  @override
  Future<OrderDetailView> rejectRevision(
    String orderId, {
    required int snapshotVersion,
    required String idempotencyKey,
  }) => _answer('reject:$snapshotVersion', _decide('reject', idempotencyKey));

  @override
  Future<OrderDetailView> acceptNrpc(
    String orderId, {
    required int snapshotVersion,
    required String nrpcId,
    required String termsVersionId,
    required String idempotencyKey,
    String? budgetOverrideReason,
  }) => _answer(
    'acceptNrpc:$nrpcId:$termsVersionId',
    _decide('acceptNrpc', idempotencyKey),
  );

  @override
  Future<OrderDetailView> rejectNrpc(
    String orderId, {
    required int snapshotVersion,
    required String nrpcId,
    required String idempotencyKey,
  }) => _answer('rejectNrpc:$nrpcId', _decide('rejectNrpc', idempotencyKey));

  @override
  Future<OrderDetailView> flagNrpc(
    String orderId, {
    required String nrpcId,
    required String reason,
    required String idempotencyKey,
  }) =>
      _answer('flagNrpc:$nrpcId:$reason', _decide('flagNrpc', idempotencyKey));

  // Phase 11 payments: scripted provider-side results; a fake never marks anything paid by itself.
  PaymentOptionsView? options;
  PaymentAttemptView? attempt;
  final List<PaymentAttemptView> refreshes = [];

  @override
  Future<PaymentOptionsView> paymentOptions(String orderId) =>
      _answer('paymentOptions:$orderId', options!);

  @override
  Future<PaymentAttemptView> startPayment(
    String orderId, {
    required String channelCode,
    required int expectedTotalCentavos,
    required String idempotencyKey,
  }) {
    keys.add(idempotencyKey);
    if (paymentStartFailure != null) return Future.error(paymentStartFailure!);
    return _answer(
      'startPayment:$channelCode:$expectedTotalCentavos',
      attempt!,
    );
  }

  @override
  Future<PaymentAttemptView> payment(String paymentId) =>
      _answer('payment:$paymentId', attempt!);

  @override
  Future<PaymentAttemptView> refreshPayment(String paymentId) => _answer(
    'refreshPayment:$paymentId',
    refreshes.isEmpty ? attempt! : refreshes.removeAt(0),
  );

  @override
  Future<void> acknowledgePhysicalPayment(
    String orderId, {
    required String recordId,
    required String idempotencyKey,
  }) {
    keys.add(idempotencyKey);
    return _answer('acknowledge:$recordId', null);
  }

  // Phase 12 fulfillment and cancellation: the fake returns scripted server views only.
  CancellationPreviewView? preview;
  final Map<String, Uint8List> files = {};

  @override
  Future<CancellationPreviewView> cancellationPreview(String orderId) =>
      _answer('cancellationPreview:$orderId', preview!);

  @override
  Future<OrderDetailView> cancelOrder(
    String orderId, {
    required int lockVersion,
    required String idempotencyKey,
    String? reasonCode,
    String? reason,
  }) => _answer(
    'cancel:$lockVersion:${reasonCode ?? '-'}:${reason ?? ''}',
    _decide('cancel', idempotencyKey),
  );

  @override
  Future<OrderDetailView> withdrawCancellationRequest(
    String orderId, {
    required String idempotencyKey,
  }) => _answer(
    'withdrawCancellationRequest',
    _decide('withdrawCancellationRequest', idempotencyKey),
  );

  @override
  Future<OrderDetailView> confirmReceipt(
    String orderId, {
    required String idempotencyKey,
  }) => _answer('confirmReceipt', _decide('confirmReceipt', idempotencyKey));

  @override
  Future<OrderDetailView> reportProblem(
    String orderId, {
    required String category,
    required String description,
    required String idempotencyKey,
    ProblemPhoto? photo,
  }) => _answer(
    'reportProblem:$category:${photo?.filename ?? '-'}',
    _decide('reportProblem', idempotencyKey),
  );

  @override
  Future<OrderDetailView> resolveProblem(
    String orderId, {
    required String issueId,
    required String idempotencyKey,
    String? note,
  }) => _answer(
    'resolveProblem:$issueId',
    _decide('resolveProblem', idempotencyKey),
  );

  @override
  Future<OrderDetailView> acknowledgeReimbursement(
    String orderId, {
    required String reimbursementId,
    required String idempotencyKey,
  }) => _answer(
    'acknowledgeReimbursement:$reimbursementId',
    _decide('acknowledgeReimbursement', idempotencyKey),
  );

  @override
  Future<Uint8List> orderFile(String orderId, String fileId) =>
      _answer('orderFile:$fileId', files[fileId] ?? Uint8List(0));
}
