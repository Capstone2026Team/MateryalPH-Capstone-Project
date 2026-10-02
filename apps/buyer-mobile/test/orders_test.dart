import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/order_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/item_procurement/checkout_preview_screen.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/orders/nrpc_disclosure_screen.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/orders/order_models.dart';
import 'package:materyalph/features/orders/order_submitted_screen.dart';
import 'package:materyalph/features/orders/orders_screen.dart';

import 'item_procurement_fakes.dart';
import 'orders_fakes.dart';

Widget _app(Widget home) => MaterialApp(theme: BuyerTheme.light, home: home);

void main() {
  testWidgets(
    'order list retries only pending orders and refreshes expiry from the server',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      OrderListPage page(String state, {OrderDeadlineView? deadline}) =>
          OrderListPage(
            items: [
              orderSummary(
                state: state,
                nextAction: state == 'AWAITING_PAYMENT' ? 'PAY' : null,
                paymentRetryable: true,
                deadline: deadline,
              ),
            ],
            counts: const {},
            page: 1,
            hasMore: false,
            total: 1,
          );
      final repository = FakeOrdersRepository(
        list: page(
          'AWAITING_PAYMENT',
          deadline: OrderDeadlineView(
            kind: 'PAYMENT',
            at: DateTime.now().add(const Duration(seconds: 2)),
          ),
        ),
      );
      await tester.pumpWidget(
        _app(OrdersScreen(repository: repository, initialGroup: 'ALL')),
      );
      await tester.pump();
      expect(find.text('Re-process payment'), findsOneWidget);
      expect(find.text('Pay now'), findsNothing);
      repository.list = page('EXPIRED');
      // The countdown asks the server to refresh; the response decides the new state.
      tester
          .widget<DeadlineCountdown>(find.byType(DeadlineCountdown))
          .onExpired!();
      await tester.pump();
      expect(
        repository.calls.where((call) => call == 'orders:ALL:1'),
        hasLength(2),
      );
      expect(find.text('Re-process payment'), findsNothing);
      expect(find.text('Pay now'), findsNothing);
    },
  );

  testWidgets(
    'a 24-hour countdown displays hours and the exact Manila deadline',
    (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: DeadlineCountdown(
              deadline: DateTime.utc(2026, 10, 6, 1),
              now: () => DateTime.utc(2026, 10, 5, 1, 1),
              label: 'Pay before',
            ),
          ),
        ),
      );
      expect(find.text('23 h 59 min'), findsOneWidget);
      expect(find.textContaining('Oct 6, 2026, 9:00 AM PHT'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'order details show five separate state rows and never imply payment from the order state',
    (tester) async {
      final repository = FakeOrdersRepository(
        detail: orderDetail(
          state: 'AWAITING_PAYMENT',
          payment: 'PENDING',
          paymentExpiresAt: DateTime.now().add(const Duration(minutes: 30)),
        ),
      );
      await tester.pumpWidget(
        _app(OrderDetailsScreen(orderId: 'order-1', repository: repository)),
      );
      await tester.pump();
      for (final label in [
        'Order',
        'Payment',
        'Fulfillment',
        'Refund',
        'Dispute',
      ]) {
        expect(find.bySemanticsLabel(RegExp('^$label: ')), findsOneWidget);
      }
      expect(find.bySemanticsLabel('Payment: Payment due'), findsOneWidget);
      expect(find.bySemanticsLabel('Refund: None'), findsOneWidget);
      expect(
        find.text('Pending payment — the Vendor confirmed your order'),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'order is confirmed only after the payment provider verifies',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('a Vendor revision is approved for the exact version shown', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository =
        FakeOrdersRepository(
            detail: orderDetail(
              state: 'AWAITING_BUYER_APPROVAL',
              actions: const {'APPROVE_REVISION', 'REJECT_REVISION'},
              confirmedQuantity: '8.0000',
              buyerResponseDueAt: DateTime.now().add(const Duration(hours: 20)),
              changes: const [
                OrderChangeView(
                  type: 'QUANTITY_REDUCED',
                  label: 'Concrete Hollow Block 4"',
                  from: '10.0000',
                  to: '8.0000',
                ),
              ],
            ),
          )
          ..onDecision = (_) => orderDetail(
            state: 'AWAITING_PAYMENT',
            payment: 'PENDING',
            paymentExpiresAt: DateTime.now().add(const Duration(hours: 24)),
          );
    await tester.pumpWidget(
      _app(OrderDetailsScreen(orderId: 'order-1', repository: repository)),
    );
    await tester.pump();
    expect(find.text('Review the Vendor’s confirmed version'), findsOneWidget);
    expect(find.text('Concrete Hollow Block 4": 10 → 8'), findsOneWidget);
    expect(find.text('Respond within'), findsOneWidget);
    await tester.tap(find.text('Approve this version'));
    await tester.pump();
    await tester.pump();
    expect(repository.calls, contains('approve:2'));
    expect(repository.keys, hasLength(1));
    expect(
      find.text('Approved. Your order moves to the next step.'),
      findsOneWidget,
    );
    expect(find.text('Pay before'), findsOneWidget);
  });

  testWidgets('rejecting a revision asks first and then cancels', (
    tester,
  ) async {
    final repository = FakeOrdersRepository(
      detail: orderDetail(
        state: 'AWAITING_BUYER_APPROVAL',
        actions: const {'APPROVE_REVISION', 'REJECT_REVISION'},
        confirmedQuantity: '8.0000',
      ),
    )..onDecision = (_) => orderDetail(state: 'CANCELLED');
    await tester.pumpWidget(
      _app(OrderDetailsScreen(orderId: 'order-1', repository: repository)),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Reject'));
    await tester.pumpAndSettle();
    expect(find.text('Reject this version?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Reject'));
    await tester.pumpAndSettle();
    expect(repository.calls, contains('reject:2'));
    expect(find.text('This order was cancelled'), findsOneWidget);
  });

  testWidgets(
    'the NRPC acceptance control activates only after the full disclosure is shown and acknowledged',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final detail = orderDetail(
        state: 'AWAITING_NRPC_ACCEPTANCE',
        actions: const {'ACCEPT_NRPC', 'REJECT_NRPC', 'FLAG_NRPC'},
        nrpc: nrpcView(),
        amounts: money(nrpc: 5000),
      );
      final repository = FakeOrdersRepository(detail: detail)
        ..onDecision = (action) => action == 'acceptNrpc'
            ? orderDetail(
                state: 'AWAITING_PAYMENT',
                payment: 'PENDING',
                nrpc: nrpcView(status: 'ACCEPTED'),
              )
            : orderDetail(
                state: 'AWAITING_NRPC_ACCEPTANCE',
                actions: const {'ACCEPT_NRPC', 'REJECT_NRPC'},
                nrpc: nrpcView(flagged: true),
              );
      OrderDetailView? result;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async =>
                    result = await Navigator.of(context).push<OrderDetailView>(
                      MaterialPageRoute(
                        builder: (_) => NrpcDisclosureScreen(
                          order: detail,
                          repository: repository,
                        ),
                      ),
                    ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      FilledButton accept() => tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Accept preparation cost'),
      );
      expect(find.text('₱50.00'), findsWidgets);
      expect(find.text('Custom cutting to the Buyer drawings'), findsOneWidget);
      expect(
        find.text('Scroll through the full disclosure to continue.'),
        findsOneWidget,
      );
      expect(accept().onPressed, isNull);

      // Flagging is separate and never accepts.
      await tester.tap(find.text('Flag as disproportionate'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Too high');
      await tester.tap(find.text('Send for review'));
      await tester.pump();
      expect(
        find.text('Describe your concern in at least 10 characters.'),
        findsOneWidget,
      );
      await tester.enterText(
        find.byType(TextField),
        'Too high for simple straight cuts.',
      );
      await tester.tap(find.text('Send for review'));
      await tester.pumpAndSettle();
      expect(repository.calls.single, startsWith('flagNrpc:nrpc-1:'));
      expect(result?.state('ORDER'), 'AWAITING_NRPC_ACCEPTANCE');

      // Reopen and accept only after scrolling to the Terms and acknowledging them.
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).last, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(find.textContaining('NRPC Terms v1'), findsOneWidget);
      expect(
        accept().onPressed,
        isNull,
        reason: 'The acknowledgement is still required.',
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(accept().onPressed, isNotNull);
      await tester.tap(
        find.widgetWithText(FilledButton, 'Accept preparation cost'),
      );
      await tester.pumpAndSettle();
      expect(repository.calls.last, 'acceptNrpc:nrpc-1:terms-1');
      expect(result?.state('ORDER'), 'AWAITING_PAYMENT');
    },
  );

  testWidgets('unavailable NRPC Terms keep acceptance disabled', (
    tester,
  ) async {
    final unavailable = NrpcView(
      id: 'nrpc-1',
      amountCentavos: 5000,
      reason: 'Custom cutting to the Buyer drawings',
      affectedLines: const [],
      terms: const NrpcTermsView(
        id: 'terms-1',
        version: 1,
        title: 'NRPC Terms',
        content: null,
      ),
      cancellationEffect: 'Effect',
      status: 'PROPOSED',
      flagged: false,
    );
    await tester.pumpWidget(
      _app(
        NrpcDisclosureScreen(
          order: orderDetail(
            state: 'AWAITING_NRPC_ACCEPTANCE',
            actions: const {'ACCEPT_NRPC'},
            nrpc: unavailable,
          ),
          repository: FakeOrdersRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('The NRPC Terms are unavailable right now'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Accept preparation cost'),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets(
    'the payment countdown shows the exact Manila time and resolves on expiry',
    (tester) async {
      var now = DateTime.utc(2026, 10, 5, 1, 44, 58);
      var expired = 0;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: DeadlineCountdown(
              deadline: DateTime.utc(2026, 10, 5, 1, 45),
              label: 'Pay before',
              endedLabel: 'Payment window ended',
              onExpired: () => expired++,
              now: () => now,
            ),
          ),
        ),
      );
      expect(find.text('00:02'), findsOneWidget);
      expect(find.textContaining('Oct 5, 2026, 9:45 AM PHT'), findsOneWidget);
      now = DateTime.utc(2026, 10, 5, 1, 45, 1);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Payment window ended'), findsOneWidget);
      expect(expired, 1);
    },
  );

  testWidgets(
    'the money breakdown keeps NRPC inside the subtotal and leaves the fee pending',
    (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: SingleChildScrollView(
              child: MoneyBreakdownCard(
                money: money(
                  nrpc: 5000,
                  delivery: null,
                  deliveryStatus: 'PENDING_VENDOR_CONFIRMATION',
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Preparation cost (NRPC)'), findsOneWidget);
      expect(
        find.text('Part of the materials subtotal, not an extra charge'),
        findsOneWidget,
      );
      expect(find.text('Shown at payment'), findsOneWidget);
      expect(find.text('Est. ₱605.00'), findsOneWidget);
      expect(find.text('Total before delivery'), findsOneWidget);
      expect(
        find.textContaining(
          RegExp('commission|withholding', caseSensitive: false),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'the order hub groups orders and shows the next action with its deadline',
    (tester) async {
      final repository = FakeOrdersRepository(
        list: OrderListPage(
          items: [
            orderSummary(
              deadline: OrderDeadlineView(
                kind: 'BUYER_RESPONSE',
                at: DateTime.utc(2026, 10, 6, 1),
              ),
            ),
          ],
          counts: const {'ALL': 3, 'AWAITING_ACTION': 1, 'ACTIVE': 2},
          page: 1,
          hasMore: false,
          total: 1,
        ),
      );
      await tester.pumpWidget(_app(OrdersScreen(repository: repository)));
      await tester.pumpAndSettle();
      expect(find.text('Needs action (1)'), findsOneWidget);
      expect(
        find.textContaining(
          'Review the Vendor’s confirmed version · Respond by Oct 6, 2026, 9:00 AM PHT',
        ),
        findsOneWidget,
      );
      expect(find.text('Needs your approval'), findsOneWidget);
      expect(find.text('Payment: No payment due'), findsOneWidget);
      repository.list = const OrderListPage(
        items: [],
        counts: {'ALL': 3},
        page: 1,
        hasMore: false,
        total: 0,
      );
      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      expect(repository.calls.last, 'orders:COMPLETED:1');
      expect(find.text('No orders here yet'), findsOneWidget);
    },
  );

  testWidgets(
    'checkout submits ready groups once, confirms a split and opens the real confirmation',
    (tester) async {
      final procurement = FakeProcurementRepository(
        preview: previewFixture(deliveryStatus: 'BLOCKED'),
      );
      final cart = CartController(repository: procurement);
      await cart.load();
      final orders = FakeOrdersRepository(
        checkout: CheckoutView(
          id: 'checkout-1',
          reference: 'CHK-2026-ZX12CV34',
          submittedAt: DateTime.utc(2026, 10, 5, 1),
          notice: 'Each Vendor reviews its own order request.',
          orders: [
            CheckoutChildView(
              id: 'order-2',
              reference: 'ORD-2026-BRAVO001',
              vendorName: 'Bravo Builders Depot',
              orderState: 'AWAITING_PAYMENT',
              fulfillmentMethod: 'PICKUP',
              autoAccepted: true,
              commercialTotalCentavos: 18000,
              deliveryPending: false,
              paymentExpiresAt: DateTime.now().add(const Duration(hours: 24)),
            ),
          ],
        ),
      );
      await tester.pumpWidget(
        _app(
          CheckoutPreviewScreen(
            controller: cart,
            savedLocations: () => const [],
            orders: orders,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Submit order request'), findsOneWidget);
      await tester.tap(find.text('Submit order request'));
      await tester.pumpAndSettle();
      expect(find.text('Submit 1 of 2 stores?'), findsOneWidget);
      await tester.tap(find.text('Submit ready stores'));
      await tester.pumpAndSettle();
      expect(orders.submissions.single, {
        'cartLockVersion': 3,
        'vendorIds': ['vendor-2'],
        'splitConfirmed': true,
        'paymentMethods': {'vendor-2': 'ONLINE'},
      });
      expect(find.byType(OrderSubmittedScreen), findsOneWidget);
      expect(find.text('CHK-2026-ZX12CV34'), findsOneWidget);
      expect(find.text('Accepted automatically — pay before'), findsOneWidget);
    },
  );

  testWidgets(
    'a failed submission keeps the Buyer on checkout with the reason',
    (tester) async {
      final procurement = FakeProcurementRepository(preview: previewFixture());
      final cart = CartController(repository: procurement);
      await cart.load();
      final orders = FakeOrdersRepository()
        ..failure = const DiscoveryFailure(
          DiscoveryFailureKind.conflict,
          'A price changed while you were checking out.',
          code: 'CHECKOUT_CHANGED',
        );
      await tester.pumpWidget(
        _app(
          CheckoutPreviewScreen(
            controller: cart,
            savedLocations: () => const [],
            orders: orders,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit 2 order requests'));
      await tester.pumpAndSettle();
      expect(
        find.text('A price changed while you were checking out.'),
        findsOneWidget,
      );
      expect(find.byType(OrderSubmittedScreen), findsNothing);
    },
  );
}
