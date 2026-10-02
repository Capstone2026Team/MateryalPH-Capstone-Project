import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../core/api_guard.dart';
import 'order_models.dart';

/// Buyer order submission and decisions through `/api/v1` only. Every mutation carries an
/// Idempotency-Key so a retried tap can never create a second checkout or decision.
abstract interface class OrdersRepository {
  Future<CheckoutView> submitCheckout({
    required int cartLockVersion,
    required List<String> vendorIds,
    required bool splitConfirmed,
    required String idempotencyKey,
    Map<String, String> paymentMethods = const {},
  });

  Future<OrderListPage> orders({required String group, int page = 1});

  Future<OrderDetailView> order(String orderId);

  Future<OrderDetailView> approveRevision(
    String orderId, {
    required int snapshotVersion,
    required String idempotencyKey,
    String? budgetOverrideReason,
  });

  Future<OrderDetailView> rejectRevision(
    String orderId, {
    required int snapshotVersion,
    required String idempotencyKey,
  });

  Future<OrderDetailView> acceptNrpc(
    String orderId, {
    required int snapshotVersion,
    required String nrpcId,
    required String termsVersionId,
    required String idempotencyKey,
    String? budgetOverrideReason,
  });

  Future<OrderDetailView> rejectNrpc(
    String orderId, {
    required int snapshotVersion,
    required String nrpcId,
    required String idempotencyKey,
  });

  Future<OrderDetailView> flagNrpc(
    String orderId, {
    required String nrpcId,
    required String reason,
    required String idempotencyKey,
  });

  /// Server-computed purpose, principal and per-channel Payment Processing Fee.
  Future<PaymentOptionsView> paymentOptions(String orderId);

  /// Opens one provider payment for the due purpose. [expectedTotalCentavos] is only compared with the
  /// server total; a mismatch is a 409 and nothing is charged.
  Future<PaymentAttemptView> startPayment(
    String orderId, {
    required String channelCode,
    required int expectedTotalCentavos,
    required String idempotencyKey,
  });

  Future<PaymentAttemptView> payment(String paymentId);

  /// Asks the provider for the authoritative status. Still pending until verified.
  Future<PaymentAttemptView> refreshPayment(String paymentId);

  Future<void> acknowledgePhysicalPayment(
    String orderId, {
    required String recordId,
    required String idempotencyKey,
  });
}

final class ApiOrdersRepository implements OrdersRepository {
  ApiOrdersRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : _client = client,
       _api = ApiGuard(onSessionExpired);

  final api.MateryalphApiClient _client;
  final ApiGuard _api;

  api.BuyerOrdersApi get _orders => _client.getBuyerOrdersApi();

  @override
  Future<CheckoutView> submitCheckout({
    required int cartLockVersion,
    required List<String> vendorIds,
    required bool splitConfirmed,
    required String idempotencyKey,
    Map<String, String> paymentMethods = const {},
  }) => _api(() async {
    final response = await _orders.submitBuyerCheckout(
      idempotencyKey: idempotencyKey,
      checkoutSubmitRequest: api.CheckoutSubmitRequest(
        (b) => b
          ..cartLockVersion = cartLockVersion
          ..vendorIds = SetBuilder<String>(vendorIds)
          ..splitConfirmed = splitConfirmed
          ..paymentMethods = paymentMethods.isEmpty
              ? null
              : MapBuilder<String, api.CheckoutSubmitRequestPaymentMethodsEnum>(
                  {
                    for (final entry in paymentMethods.entries)
                      entry.key:
                          api.CheckoutSubmitRequestPaymentMethodsEnum.valueOf(
                            entry.value,
                          ),
                  },
                ),
      ),
    );
    return _checkout(_api.required(response.data?.data));
  });

  @override
  Future<OrderListPage> orders({required String group, int page = 1}) => _api(
    () async {
      final response = await _orders.listBuyerOrders(group: group, page: page);
      final envelope = _api.required(response.data);
      return OrderListPage(
        items: envelope.data.map(_summary).toList(),
        counts: envelope.meta.counts.toMap(),
        page: envelope.meta.page,
        hasMore: envelope.meta.hasMore,
        total: envelope.meta.total,
      );
    },
  );

  @override
  Future<OrderDetailView> order(String orderId) => _api(() async {
    final response = await _orders.getBuyerOrder(orderId: orderId);
    return _detail(_api.required(response.data?.data));
  });

  @override
  Future<OrderDetailView> approveRevision(
    String orderId, {
    required int snapshotVersion,
    required String idempotencyKey,
    String? budgetOverrideReason,
  }) => _api(() async {
    final response = await _orders.approveBuyerOrderRevision(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      orderRevisionDecision: api.OrderRevisionDecision(
        (b) => b
          ..snapshotVersion = snapshotVersion
          ..budgetOverrideReason = budgetOverrideReason,
      ),
    );
    return _detail(_api.required(response.data?.data));
  });

  @override
  Future<OrderDetailView> rejectRevision(
    String orderId, {
    required int snapshotVersion,
    required String idempotencyKey,
  }) => _api(() async {
    const String? budgetOverrideReason = null;
    final response = await _orders.rejectBuyerOrderRevision(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      orderRevisionDecision: api.OrderRevisionDecision(
        (b) => b
          ..snapshotVersion = snapshotVersion
          ..budgetOverrideReason = budgetOverrideReason,
      ),
    );
    return _detail(_api.required(response.data?.data));
  });

  @override
  Future<OrderDetailView> acceptNrpc(
    String orderId, {
    required int snapshotVersion,
    required String nrpcId,
    required String termsVersionId,
    required String idempotencyKey,
    String? budgetOverrideReason,
  }) => _api(() async {
    final response = await _orders.acceptBuyerOrderNrpc(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      nrpcAcceptRequest: api.NrpcAcceptRequest(
        (b) => b
          ..snapshotVersion = snapshotVersion
          ..nrpcId = nrpcId
          ..termsVersionId = termsVersionId
          ..budgetOverrideReason = budgetOverrideReason
          ..acknowledged = api.NrpcAcceptRequestAcknowledgedEnum.true_,
      ),
    );
    return _detail(_api.required(response.data?.data));
  });

  @override
  Future<OrderDetailView> rejectNrpc(
    String orderId, {
    required int snapshotVersion,
    required String nrpcId,
    required String idempotencyKey,
  }) => _api(() async {
    final response = await _orders.rejectBuyerOrderNrpc(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      nrpcRejectRequest: api.NrpcRejectRequest(
        (b) => b
          ..snapshotVersion = snapshotVersion
          ..nrpcId = nrpcId,
      ),
    );
    return _detail(_api.required(response.data?.data));
  });

  @override
  Future<OrderDetailView> flagNrpc(
    String orderId, {
    required String nrpcId,
    required String reason,
    required String idempotencyKey,
  }) => _api(() async {
    final response = await _orders.flagBuyerOrderNrpc(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      nrpcFlagRequest: api.NrpcFlagRequest(
        (b) => b
          ..nrpcId = nrpcId
          ..reason = reason,
      ),
    );
    return _detail(_api.required(response.data?.data));
  });

  static List<OrderStateRowView> _states(BuiltList<api.OrderStateRow> rows) =>
      rows.map((row) => OrderStateRowView(row.family.name, row.state)).toList();

  static CheckoutView _checkout(api.CheckoutSubmission checkout) =>
      CheckoutView(
        id: checkout.id,
        reference: checkout.reference,
        submittedAt: checkout.submittedAt,
        notice: checkout.notice,
        orders: checkout.orders
            .map(
              (order) => CheckoutChildView(
                id: order.id,
                reference: order.reference,
                vendorName: order.vendor.name,
                orderState: order.orderState.name,
                fulfillmentMethod: order.fulfillmentMethod.name,
                autoAccepted: order.confirmationSource?.name == 'AUTO_ACCEPT',
                commercialTotalCentavos: order.commercialTotalCentavos,
                deliveryPending: order.deliveryCentavos == null,
                vendorResponseDueAt: order.vendorResponseDueAt,
                paymentExpiresAt: order.paymentExpiresAt,
              ),
            )
            .toList(),
      );

  static OrderSummaryView _summary(api.OrderSummary order) => OrderSummaryView(
    id: order.id,
    reference: order.reference,
    vendorName: order.vendor.name,
    submittedAt: order.submittedAt,
    states: _states(order.states),
    fulfillmentMethod: order.fulfillmentMethod.name,
    lineCount: order.lineCount,
    firstLineName: order.firstLine.displayName,
    firstLineImageUrl: order.firstLine.image?.url,
    commercialTotalCentavos: order.commercialTotalCentavos,
    deliveryPending: order.deliveryPending,
    deadline: order.deadline == null
        ? null
        : OrderDeadlineView(
            kind: order.deadline!.kind.name,
            at: order.deadline!.at,
          ),
    nextAction: order.nextAction?.name,
    paymentRetryable: order.paymentRetryable ?? false,
    autoAccepted: order.confirmationSource?.name == 'AUTO_ACCEPT',
  );

  static OrderPointView? _point(api.OrderPoint? point) => point == null
      ? null
      : OrderPointView(
          label: point.label,
          formattedAddress: point.formattedAddress,
        );

  static OrderDetailView _detail(api.OrderDetail order) {
    final destination = order.destination;
    final confirmed = order.delivery.confirmed;
    final nrpc = order.nrpc;
    final money = order.money;
    return OrderDetailView(
      id: order.id,
      reference: order.reference,
      projectContext: order.projectContext
          ?.map((k, v) => MapEntry(k, v?.value))
          .toMap(),
      vendorName: order.vendor.name,
      fulfillmentMethod: order.fulfillmentMethod.name,
      submittedAt: order.submittedAt,
      states: _states(order.states),
      snapshotVersion: order.commercialVersion.current,
      autoAccepted: order.confirmationSource?.name == 'AUTO_ACCEPT',
      lines: order.lines
          .map(
            (line) => OrderLineView(
              id: line.id,
              displayName: line.displayName,
              variantLabel: line.variantLabel,
              imageUrl: line.image?.url,
              unitName: line.unitName,
              requestedQuantity: line.requestedQuantity,
              confirmedQuantity: line.confirmedQuantity,
              unitPriceCentavos: line.unitPriceCentavos,
              lineTotalCentavos: line.lineTotalCentavos,
              discountCentavos: line.discountCentavos,
              vatLabel: line.vatLabel,
              change: line.change?.name,
              volumeTierApplied: line.volumeTierApplied,
            ),
          )
          .toList(),
      changes: order.changes
          .map(
            (change) => OrderChangeView(
              type: change.type.name,
              label: change.label,
              from: change.from,
              to: change.to,
            ),
          )
          .toList(),
      money: MoneyView(
        status: money.status.name,
        materialsGrossCentavos: money.materialsGrossCentavos,
        vendorDiscountCentavos: money.vendorDiscountCentavos,
        materialsSubtotalCentavos: money.materialsSubtotalCentavos,
        includedVatCentavos: money.includedVatCentavos,
        pricesIncludeVat: money.vatTreatment.name == 'PRICES_INCLUDE_VAT',
        deliveryStatus: money.delivery.status.name,
        deliveryCentavos: money.delivery.amountCentavos,
        deliveryEstimateMin: money.delivery.estimate?.minCentavos,
        deliveryEstimateMax: money.delivery.estimate?.maxCentavos,
        nrpcCentavos: money.nrpc.amountCentavos,
        processingFeeStatus: money.processingFee.status.name,
        processingFeeCentavos: money.processingFee.amountCentavos,
        commercialTotalCentavos: money.commercialTotalCentavos,
        amountDueOnlineCentavos: money.amountDueOnlineCentavos,
        physicalBalanceCentavos: money.physicalBalanceCentavos,
        paymentPurpose: money.paymentPurpose?.name,
      ),
      timeline: order.timeline
          .map(
            (event) => OrderEventView(
              family: event.family.name,
              toState: event.toState,
              source: event.source_.name,
              at: event.at,
            ),
          )
          .toList(),
      actions: {...?order.availableActions?.map((action) => action.name)},
      destination: destination == null
          ? null
          : OrderDestinationView(
              type: destination.type.name,
              storeAddress: destination.storeAddress,
              intended: _point(destination.intended),
              alternateDropOff: _point(destination.alternateDropOff),
              heavyVehicleRestriction:
                  destination.heavyVehicleRestriction?.name,
              vehicleEndpoint: destination.vehicleEndpoint?.name,
              accessInstructions: destination.accessInstructions,
            ),
      confirmedDelivery: confirmed == null
          ? null
          : ConfirmedDeliveryView(
              vehicles: confirmed.vehicles
                  .map(
                    (vehicle) => ConfirmedVehicleView(
                      name: vehicle.name ?? 'Vehicle',
                      brand: vehicle.brand,
                      vehicles: vehicle.numberOfVehicles,
                      trips: vehicle.totalVehicleTrips,
                      perTripCentavos: vehicle.perTripCentavos,
                    ),
                  )
                  .toList(),
              distanceMeters: confirmed.distanceMeters,
              endpoint: confirmed.endpoint?.name,
              finalFeeCentavos: confirmed.finalFeeCentavos,
              fulfillmentDate: confirmed.fulfillmentDate?.toString(),
              arrangement: confirmed.arrangement,
              intended: _point(confirmed.intended),
              alternateDropOff: _point(confirmed.alternateDropOff),
            ),
      nrpc: nrpc == null
          ? null
          : NrpcView(
              id: nrpc.id,
              amountCentavos: nrpc.amountCentavos,
              reason: nrpc.reason,
              affectedLines: nrpc.affectedLines
                  .map(
                    (line) => NrpcLineView(
                      label: line.label,
                      principalCentavos: line.principalCentavos,
                      linePayableCentavos: line.linePayableCentavos,
                    ),
                  )
                  .toList(),
              terms: nrpc.terms == null
                  ? null
                  : NrpcTermsView(
                      id: nrpc.terms!.id,
                      version: nrpc.terms!.version,
                      title: nrpc.terms!.title,
                      content: nrpc.terms!.content,
                    ),
              cancellationEffect: nrpc.cancellationEffect,
              status: nrpc.status.name,
              flagged: nrpc.flag != null,
              acceptedAt: nrpc.acceptedAt,
            ),
      vendorResponseDueAt: order.deadlines.vendorResponseDueAt,
      buyerResponseDueAt: order.deadlines.buyerResponseDueAt,
      paymentExpiresAt: order.deadlines.paymentExpiresAt,
      expectedFulfillmentDate: order.expectedFulfillmentDate?.toString(),
      terminalReasonCode: order.terminalReasonCode,
      paymentNotice: order.payment?.notice,
      payment: order.payment == null ? null : _payment(order.payment!),
    );
  }

  api.BuyerPaymentsApi get _payments => _client.getBuyerPaymentsApi();

  @override
  Future<PaymentOptionsView> paymentOptions(String orderId) => _api(() async {
    final response = await _payments.getBuyerPaymentOptions(orderId: orderId);
    final options = _api.required(response.data?.data);
    return PaymentOptionsView(
      orderId: options.orderId,
      orderReference: options.orderReference,
      paymentDue: options.paymentDue,
      providerReady: options.providerReady,
      notice: options.notice,
      purpose: options.purpose?.name,
      principalCentavos: options.principalCentavos,
      payBy: options.payBy,
      latestAttempt: options.latestAttempt == null
          ? null
          : _attempt(options.latestAttempt!),
      channels: options.channels
          .map(
            (channel) => PaymentChannelView(
              code: channel.code,
              displayName: channel.displayName,
              kind: channel.kind.name,
              available: channel.available,
              rateLabel: channel.rateLabel,
              unavailableReason: channel.unavailableReason,
              feeCentavos: channel.feeCentavos,
              totalCentavos: channel.totalCentavos,
            ),
          )
          .toList(),
    );
  });

  @override
  Future<PaymentAttemptView> startPayment(
    String orderId, {
    required String channelCode,
    required int expectedTotalCentavos,
    required String idempotencyKey,
  }) => _api(() async {
    final response = await _payments.createBuyerPayment(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      paymentCreateRequest: api.PaymentCreateRequest(
        (b) => b
          ..channelCode = channelCode
          ..expectedTotalCentavos = expectedTotalCentavos,
      ),
    );
    return _attempt(_api.required(response.data?.data));
  });

  @override
  Future<PaymentAttemptView> payment(String paymentId) => _api(() async {
    final response = await _payments.getBuyerPayment(paymentId: paymentId);
    return _attempt(_api.required(response.data?.data));
  });

  @override
  Future<PaymentAttemptView> refreshPayment(String paymentId) => _api(() async {
    final response = await _payments.refreshBuyerPayment(paymentId: paymentId);
    return _attempt(_api.required(response.data?.data));
  });

  @override
  Future<void> acknowledgePhysicalPayment(
    String orderId, {
    required String recordId,
    required String idempotencyKey,
  }) => _api(() async {
    await _payments.acknowledgePhysicalPayment(
      orderId: orderId,
      recordId: recordId,
      idempotencyKey: idempotencyKey,
    );
  });

  static PaymentAttemptView _attempt(api.PaymentAttempt attempt) =>
      PaymentAttemptView(
        id: attempt.id,
        purpose: attempt.purpose.name,
        status: attempt.status.name,
        principalCentavos: attempt.principalCentavos,
        processingFeeCentavos: attempt.processingFeeCentavos,
        totalCentavos: attempt.totalCentavos,
        evidenceOrigin: attempt.evidenceOrigin.name,
        canCheckStatus: attempt.canCheckStatus,
        message: attempt.message,
        orderId: attempt.orderId,
        channelName: attempt.channelName,
        checkoutUrl: attempt.checkoutUrl,
        expiresAt: attempt.expiresAt,
        paidAt: attempt.paidAt,
      );

  static OrderPaymentView _payment(api.OrderPaymentAvailability payment) {
    final physical = payment.physical;
    return OrderPaymentView(
      available: payment.available,
      purpose: payment.purpose?.name,
      principalCentavos: payment.principalCentavos,
      notice: payment.notice,
      latestAttempt: payment.latestAttempt == null
          ? null
          : _attempt(payment.latestAttempt!),
      verifiedPayment: payment.verifiedPayment == null
          ? null
          : _attempt(payment.verifiedPayment!),
      physicalApplicable: physical?.applicable ?? false,
      physicalMethod: physical?.method,
      physicalRemainingCentavos: physical?.remainingCentavos,
      onlineBalanceApproved: physical?.onlineBalanceApproved ?? false,
      physicalRecords: (physical?.records.toList() ?? const [])
          .map(
            (record) => PhysicalRecordView(
              id: record.id,
              kind: record.kind.name,
              amountCentavos: record.amountCentavos,
              remainingCentavos: record.remainingCentavos,
              recordedAt: record.recordedAt,
              source: record.source_.name,
              acknowledgedAt: record.buyerAcknowledgedAt,
            ),
          )
          .toList(),
    );
  }
}
