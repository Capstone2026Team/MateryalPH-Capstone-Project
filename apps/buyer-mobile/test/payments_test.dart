import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/orders/order_models.dart';
import 'package:materyalph/features/orders/order_payment_screen.dart';

import 'orders_fakes.dart';

/// Synthetic Phase 11 payment fixtures. TEST/SIMULATED values only; no provider data.
Widget _app(Widget home) => MaterialApp(theme: BuyerTheme.light, home: home);

PaymentAttemptView attemptView({
  String status = 'PENDING',
  String? checkoutUrl = 'https://checkout-staging.example.test/session/ps-1',
}) => PaymentAttemptView(
  id: 'payment-1',
  purpose: 'FULL_ORDER_PAYMENT',
  status: status,
  principalCentavos: 1000000,
  processingFeeCentavos: 26441,
  totalCentavos: 1026441,
  evidenceOrigin: 'XENDIT_TEST',
  canCheckStatus: status == 'PENDING',
  message: status == 'PAID'
      ? 'The payment provider verified this payment.'
      : 'Waiting for the payment provider to verify this payment.',
  orderId: 'order-1',
  channelName: 'GCash',
  checkoutUrl: checkoutUrl,
  expiresAt: DateTime.now().add(const Duration(minutes: 40)),
);

PaymentOptionsView optionsView() => PaymentOptionsView(
  orderId: 'order-1',
  orderReference: 'ORD-2026-ABCD1234',
  paymentDue: true,
  providerReady: true,
  notice: 'TEST — no real charge.',
  purpose: 'FULL_ORDER_PAYMENT',
  principalCentavos: 1000000,
  payBy: DateTime.now().add(const Duration(minutes: 40)),
  channels: const [
    PaymentChannelView(
      code: 'GCASH',
      displayName: 'GCash',
      kind: 'EWALLET',
      available: true,
      rateLabel: '2.3% + 12% VAT',
      feeCentavos: 26441,
      totalCentavos: 1026441,
    ),
    PaymentChannelView(
      code: 'CARDS',
      displayName: 'Credit or debit card',
      kind: 'CARD',
      available: true,
      rateLabel: '3.2% + ₱10.00 + 12% VAT',
      feeCentavos: 38377,
      totalCentavos: 1038377,
    ),
    PaymentChannelView(
      code: 'QRPH',
      displayName: 'QR Ph',
      kind: 'QR',
      available: false,
      rateLabel: '',
      unavailableReason: 'REFUND_ROUTE_UNAVAILABLE',
    ),
  ],
);

void main() {
  testWidgets(
    'payment controls require Pending Payment or an approved balance',
    (tester) async {
      for (final state in [
        'AWAITING_VENDOR_CONFIRMATION',
        'CONFIRMED',
        'EXPIRED',
      ]) {
        final repository = FakeOrdersRepository(
          detail: orderDetail(state: state, actions: const {'PAY'}),
        );
        await tester.pumpWidget(
          _app(
            OrderDetailsScreen(
              key: UniqueKey(),
              orderId: 'order-1',
              repository: repository,
            ),
          ),
        );
        await tester.pump();
        expect(find.text('Pay now'), findsNothing);
        expect(find.text('Re-process payment'), findsNothing);
      }
      final repository = FakeOrdersRepository(
        detail: orderDetail(
          state: 'CONFIRMED',
          actions: const {'PAY'},
          paymentView: const OrderPaymentView(
            available: true,
            physicalApplicable: true,
            physicalRecords: [],
            onlineBalanceApproved: true,
            purpose: 'ORDER_BALANCE_PAYMENT',
          ),
        ),
      );
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            key: UniqueKey(),
            orderId: 'order-1',
            repository: repository,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Pay remaining balance'), findsOneWidget);
      expect(find.text('Pay now'), findsNothing);
    },
  );

  testWidgets(
    '409 resumes the named checkout without creating or launching another',
    (tester) async {
      final repository = FakeOrdersRepository()
        ..options = optionsView()
        ..attempt = attemptView()
        ..paymentStartFailure = const DiscoveryFailure(
          DiscoveryFailureKind.conflict,
          'A payment is already in progress.',
          code: 'PAYMENT_ATTEMPT_IN_PROGRESS',
          details: {'payment_id': 'payment-1'},
        );
      var launches = 0;
      await tester.pumpWidget(
        _app(
          OrderPaymentScreen(
            orderId: 'order-1',
            repository: repository,
            launcher: (_) async {
              launches++;
              return true;
            },
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Pay ₱10,264.41 — TEST'));
      await tester.pumpAndSettle();
      expect(repository.keys, hasLength(1));
      expect(repository.calls, contains('payment:payment-1'));
      expect(find.text('Payment pending verification'), findsOneWidget);
      expect(find.text('Payment did not start'), findsNothing);
      expect(launches, 0);
      await tester.tap(find.text('Open payment page again'));
      expect(launches, 1);
    },
  );

  for (final status in ['FAILED', 'EXPIRED']) {
    testWidgets('$status allows retry only until the server closes the order', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = FakeOrdersRepository(
        detail: orderDetail(
          state: 'AWAITING_PAYMENT',
          payment: 'PENDING',
          actions: const {'PAY'},
          paymentExpiresAt: DateTime.now().add(const Duration(hours: 24)),
        ),
      )..attempt = attemptView(status: status);
      await tester.pumpWidget(
        _app(
          PaymentPendingScreen(
            paymentId: 'payment-1',
            repository: repository,
            initial: repository.attempt,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Re-process payment'), findsOneWidget);
      repository.detail = orderDetail(
        state: 'EXPIRED',
        payment: 'EXPIRED',
        terminalReasonCode: 'PAYMENT_WINDOW_EXPIRED',
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.text('Re-process payment'), findsNothing);
      expect(find.text('Cancelled — payment expired'), findsOneWidget);
    });
  }

  testWidgets(
    'channels show the server fee and total, and paying sends the selected channel and total once',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final launched = <Uri>[];
      final repository = FakeOrdersRepository()
        ..options = optionsView()
        ..attempt = attemptView();
      await tester.pumpWidget(
        _app(
          OrderPaymentScreen(
            orderId: 'order-1',
            repository: repository,
            launcher: (url) async {
              launched.add(url);
              return true;
            },
          ),
        ),
      );
      await tester.pump();

      expect(find.text('TEST — no real charge.'), findsOneWidget);
      expect(find.text('₱10,264.41'), findsOneWidget);
      expect(find.text('+₱264.41 fee'), findsOneWidget);
      expect(
        find.text('Not offered: no approved refund route'),
        findsOneWidget,
      );

      await tester.tap(find.text('Credit or debit card'));
      await tester.pump();
      expect(find.text('Pay ₱10,383.77 — TEST'), findsOneWidget);
      await tester.tap(find.text('Pay ₱10,383.77 — TEST'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(repository.calls, contains('startPayment:CARDS:1038377'));
      expect(launched.single.host, 'checkout-staging.example.test');
      expect(find.text('Payment pending verification'), findsOneWidget);
      expect(find.text('Payment verified'), findsNothing);
    },
  );

  testWidgets(
    'an offline start keeps the same idempotency key so a retry cannot open a second attempt',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = FakeOrdersRepository()
        ..options = optionsView()
        ..attempt = attemptView();
      await tester.pumpWidget(
        _app(
          OrderPaymentScreen(
            orderId: 'order-1',
            repository: repository,
            launcher: (_) async => true,
          ),
        ),
      );
      await tester.pump();

      repository.failure = const DiscoveryFailure(
        DiscoveryFailureKind.offline,
        'You appear to be offline.',
      );
      await tester.tap(find.text('Pay ₱10,264.41 — TEST'));
      await tester.pump();
      expect(find.text('Payment did not start'), findsOneWidget);

      repository.failure = null;
      await tester.tap(find.text('Pay ₱10,264.41 — TEST'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(repository.keys, hasLength(2));
      expect(repository.keys.toSet(), hasLength(1));
    },
  );

  testWidgets(
    'the pending screen confirms only after the server reports PAID, including on app resume',
    (tester) async {
      final repository = FakeOrdersRepository()
        ..attempt = attemptView()
        ..refreshes.addAll([attemptView(), attemptView(status: 'PAID')]);
      await tester.pumpWidget(
        _app(
          PaymentPendingScreen(
            paymentId: 'payment-1',
            repository: repository,
            initial: attemptView(),
            launcher: (_) async => true,
            pollInterval: const Duration(hours: 1),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Payment pending verification'), findsOneWidget);
      expect(
        find.text('Xendit TEST payment — no real charge.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Check payment status'));
      await tester.pump();
      expect(find.text('Payment pending verification'), findsOneWidget);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();

      expect(
        repository.calls.where((call) => call == 'refreshPayment:payment-1'),
        hasLength(2),
      );
      expect(find.text('Payment verified'), findsOneWidget);
      expect(find.text('Check payment status'), findsNothing);
      expect(find.text('Back to order'), findsOneWidget);
    },
  );

  testWidgets(
    'order details offer Pay now, resume a pending attempt, and confirm a Vendor record once',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = FakeOrdersRepository(
        detail: orderDetail(
          state: 'AWAITING_PAYMENT',
          payment: 'PENDING',
          actions: const {'PAY'},
          paymentExpiresAt: DateTime.now().add(const Duration(minutes: 30)),
        ),
      );
      await tester.pumpWidget(
        _app(OrderDetailsScreen(orderId: 'order-1', repository: repository)),
      );
      await tester.pump();
      expect(find.text('Pay now'), findsOneWidget);

      repository.detail = orderDetail(
        state: 'AWAITING_PAYMENT',
        payment: 'PENDING',
        actions: const {'PAY'},
        paymentExpiresAt: DateTime.now().add(const Duration(minutes: 30)),
        paymentView: OrderPaymentView(
          available: true,
          physicalApplicable: false,
          physicalRecords: const [],
          onlineBalanceApproved: false,
          purpose: 'FULL_ORDER_PAYMENT',
          latestAttempt: attemptView(),
        ),
      );
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            key: UniqueKey(),
            orderId: 'order-1',
            repository: repository,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('View pending payment'), findsOneWidget);
      expect(find.text('Payment pending verification'), findsOneWidget);

      final record = PhysicalRecordView(
        id: 'record-1',
        kind: 'COLLECTION',
        amountCentavos: 50000,
        remainingCentavos: 0,
        recordedAt: DateTime.utc(2026, 10, 6, 3),
        source: 'VENDOR_RECORD',
      );
      repository.detail = orderDetail(
        state: 'CONFIRMED',
        payment: 'NOT_REQUIRED',
        paymentView: OrderPaymentView(
          available: false,
          physicalApplicable: true,
          physicalRecords: [record],
          onlineBalanceApproved: false,
          physicalMethod: 'CASH_ON_PICKUP',
          physicalRemainingCentavos: 0,
        ),
      );
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            key: UniqueKey(),
            orderId: 'order-1',
            repository: repository,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Cash on pickup'), findsOneWidget);
      expect(find.text('Vendor recorded ₱500.00'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pump();

      expect(repository.calls, contains('acknowledge:record-1'));
      expect(repository.keys, hasLength(1));
    },
  );
}
