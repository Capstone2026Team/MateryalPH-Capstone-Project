import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/orders/order_fulfillment_sections.dart';
import 'package:materyalph/features/orders/order_models.dart';

import 'orders_fakes.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('Buyer delivery coordination reflows at $width pixels', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final proof = FulfillmentProofView(
        milestone: 'DELIVERED',
        handoverConfirmed: false,
        receiverName: 'Site Receiver',
        recordedAt: DateTime.utc(2026, 10, 13, 2),
        recordedBy: 'Assigned Delivery Staff',
        note: 'All materials received.',
      );
      final fulfillment = FulfillmentView(
        method: 'DELIVERY',
        state: 'DELIVERED',
        late: false,
        steps: [
          FulfillmentStepView(
            key: 'DELIVERED',
            label: 'Delivered',
            status: 'COMPLETE',
            proofRequired: true,
            proof: proof,
          ),
        ],
        trackingNotice: 'No live GPS tracking.',
        receipt: const FulfillmentReceiptView(paused: false, windowHours: 48),
        thread: const FulfillmentThreadView(available: false, readOnly: false),
        nextAction: 'CONFIRM_RECEIPT',
        expectedDate: '2026-10-13',
        assigneeName: 'Assigned Delivery Staff',
        vehicleName: 'Accepted box truck',
        assignedAt: DateTime.utc(2026, 10, 13, 1),
        proof: proof,
        deliveryIssues: const ['DELAY: Road works at the gate.'],
      );
      final order = orderDetail(
        state: 'DELIVERED',
        fulfillment: 'DELIVERY',
        fulfillmentView: fulfillment,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: OrderFulfillmentPanel(
                order: order,
                fulfillment: fulfillment,
                repository: FakeOrdersRepository(detail: order),
                busy: false,
                onResolveProblem: (_) {},
                onReload: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Assigned Delivery Staff'), findsNWidgets(2));
      expect(find.text('Delivery vehicle: Accepted box truck'), findsOneWidget);
      expect(find.text('Received by Site Receiver'), findsOneWidget);
      expect(find.text('All materials received.'), findsOneWidget);
      expect(find.text('DELAY: Road works at the gate.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
