import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/order_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/orders/nrpc_disclosure_screen.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/orders/order_models.dart';
import 'package:materyalph/features/orders/order_submitted_screen.dart';
import 'package:materyalph/features/orders/orders_screen.dart';

import 'orders_fakes.dart';

// Synthetic layout evidence only; no payment/provider or live marketplace claim.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.utc(2026, 10, 5, 1);
  setUpAll(() async {
    for (final font in {
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
      'Inter': 'assets/fonts/Inter-Variable.ttf',
      'packages/lucide_icons_flutter/Lucide':
          'packages/lucide_icons_flutter/assets/lucide.ttf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
  });

  Future<void> capture(
    WidgetTester tester,
    String name,
    Widget page, {
    Size size = const Size(390, 1200),
    double scale = 1,
  }) async {
    await tester.binding.setSurfaceSize(size);
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(() {
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      return tester.binding.setSurfaceSize(null);
    });
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: BuyerTheme.light,
        home: page,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../../docs/design/evidence/phase-8/$name.png'),
    );
  }

  for (final state in [
    'AWAITING_VENDOR_CONFIRMATION',
    'AWAITING_BUYER_APPROVAL',
    'AWAITING_NRPC_ACCEPTANCE',
    'AWAITING_PAYMENT',
    'DECLINED',
    'CANCELLED',
    'EXPIRED',
  ]) {
    testWidgets('order details $state', (tester) async {
      final detail = orderDetail(
        state: state,
        payment: state == 'AWAITING_PAYMENT' ? 'PENDING' : 'NOT_REQUIRED',
        vendorResponseDueAt: now.add(const Duration(hours: 24)),
        buyerResponseDueAt: now.add(const Duration(hours: 24)),
        paymentExpiresAt: now.add(const Duration(hours: 24)),
        confirmedQuantity: state == 'AWAITING_BUYER_APPROVAL' ? '8.0000' : null,
        amounts: money(
          materials: state == 'AWAITING_BUYER_APPROVAL' ? 14400 : 18000,
          nrpc: state == 'AWAITING_NRPC_ACCEPTANCE' ? 5000 : 0,
        ),
        changes: state == 'AWAITING_BUYER_APPROVAL'
            ? const [
                OrderChangeView(
                  type: 'QUANTITY_REDUCED',
                  label: 'Concrete Hollow Block 4"',
                  from: '10.0000',
                  to: '8.0000',
                ),
              ]
            : const [],
        actions: switch (state) {
          'AWAITING_BUYER_APPROVAL' => {'APPROVE_REVISION', 'REJECT_REVISION'},
          'AWAITING_NRPC_ACCEPTANCE' => {
            'ACCEPT_NRPC',
            'REJECT_NRPC',
            'FLAG_NRPC',
          },
          _ => {},
        },
        nrpc: state == 'AWAITING_NRPC_ACCEPTANCE' ? nrpcView() : null,
      );
      await capture(
        tester,
        '390-details-${state.toLowerCase()}',
        OrderDetailsScreen(
          orderId: detail.id,
          repository: FakeOrdersRepository(detail: detail),
          now: () => now,
        ),
      );
    });
  }

  testWidgets('NRPC full disclosure', (tester) async {
    await capture(
      tester,
      '390-nrpc-disclosure',
      NrpcDisclosureScreen(
        order: orderDetail(
          state: 'AWAITING_NRPC_ACCEPTANCE',
          nrpc: nrpcView(),
          actions: const {'ACCEPT_NRPC', 'REJECT_NRPC', 'FLAG_NRPC'},
        ),
        repository: FakeOrdersRepository(),
      ),
    );
  });

  testWidgets('order hub', (tester) async {
    await capture(
      tester,
      '390-order-hub',
      OrdersScreen(
        repository: FakeOrdersRepository(
          list: OrderListPage(
            items: [
              orderSummary(
                deadline: OrderDeadlineView(
                  kind: 'BUYER_RESPONSE',
                  at: now.add(const Duration(hours: 24)),
                ),
              ),
              orderSummary(
                id: 'order-2',
                state: 'AWAITING_VENDOR_CONFIRMATION',
                nextAction: null,
              ),
            ],
            counts: const {'ALL': 2, 'AWAITING_ACTION': 1, 'ACTIVE': 1},
            page: 1,
            hasMore: false,
            total: 2,
          ),
        ),
      ),
    );
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('money breakdown at ${scale}x text', (tester) async {
      await capture(
        tester,
        '${scale == 1 ? 390 : 320}-money-${scale}x',
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: MoneyBreakdownCard(
                money: money(
                  nrpc: 5000,
                  discount: 100,
                  delivery: null,
                  deliveryStatus: 'PENDING_VENDOR_CONFIRMATION',
                ),
              ),
            ),
          ),
        ),
        size: Size(scale == 1 ? 390 : 320, 1200),
        scale: scale,
      );
    });
  }

  testWidgets('submitted confirmation', (tester) async {
    await capture(
      tester,
      '390-submitted',
      OrderSubmittedScreen(
        checkout: CheckoutView(
          id: 'checkout-1',
          reference: 'CHK-2026-ZX12CV34',
          submittedAt: now,
          notice: 'Each Vendor reviews its own order request.',
          orders: [
            CheckoutChildView(
              id: 'order-1',
              reference: 'ORD-2026-ABCD1234',
              vendorName: 'Alpha Construction Supply',
              orderState: 'AWAITING_VENDOR_CONFIRMATION',
              fulfillmentMethod: 'PICKUP',
              autoAccepted: false,
              commercialTotalCentavos: 18000,
              deliveryPending: false,
              vendorResponseDueAt: now.add(const Duration(hours: 24)),
            ),
          ],
        ),
        repository: FakeOrdersRepository(),
      ),
    );
  });
}
