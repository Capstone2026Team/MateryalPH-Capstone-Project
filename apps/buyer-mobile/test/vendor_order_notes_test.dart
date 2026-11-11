import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/fulfillment_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/orders/order_models.dart';

import 'orders_fakes.dart';

const _note = 'Collect at the loading entrance.\nBring your order reference.';
final _at = DateTime.utc(2026, 11, 11, 2, 30);

FulfillmentStepView _step({String? note}) => FulfillmentStepView(
  key: 'PROCESSING',
  label: 'Preparing',
  status: 'COMPLETE',
  proofRequired: false,
  at: _at,
  actorRole: 'OWNER',
  note: note,
);

Widget _app(Widget home) => MaterialApp(
  theme: BuyerTheme.light,
  home: Scaffold(body: home),
);

void main() {
  for (final method in ['PICKUP', 'DELIVERY']) {
    for (final state in ['PROCESSING', 'CANCELLED', 'COMPLETED']) {
      testWidgets('$method $state shows saved notes in Order Details', (
        tester,
      ) async {
        final fulfillment = FulfillmentView(
          method: method,
          state: state,
          late: false,
          steps: [_step(note: _note)],
          trackingNotice: 'No live GPS tracking.',
          receipt: const FulfillmentReceiptView(paused: false, windowHours: 48),
          thread: const FulfillmentThreadView(available: false, readOnly: true),
          nextAction: 'NONE',
        );
        await tester.pumpWidget(
          _app(
            OrderDetailsScreen(
              orderId: 'order-1',
              repository: FakeOrdersRepository(
                detail: orderDetail(
                  state: state,
                  fulfillment: method,
                  fulfillmentView: fulfillment,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Notes from Vendor'));
        await tester.pumpAndSettle();
        expect(find.text(_note), findsOneWidget);
        expect(
          find.text('Preparing · Nov 11, 2026, 10:30 AM PHT'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('missing and blank notes leave no empty section', (tester) async {
    await tester.pumpWidget(
      _app(
        VendorOrderNotes(
          steps: [
            _step(),
            _step(note: '  \n '),
          ],
        ),
      ),
    );
    expect(find.text('Notes from Vendor'), findsNothing);
  });

  for (final note in [null, _note]) {
    testWidgets('handover notes appear once with milestone note $note', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const proof = FulfillmentProofView(
        milestone: 'PICKED_UP',
        handoverConfirmed: true,
        note: _note,
      );
      final fulfillment = FulfillmentView(
        method: 'PICKUP',
        state: 'PICKED_UP',
        late: false,
        steps: [
          FulfillmentStepView(
            key: 'PICKED_UP',
            label: 'Picked up',
            status: 'COMPLETE',
            proofRequired: true,
            proof: proof,
            note: note,
          ),
        ],
        trackingNotice: 'No live GPS tracking.',
        receipt: const FulfillmentReceiptView(paused: false, windowHours: 48),
        thread: const FulfillmentThreadView(available: false, readOnly: false),
        nextAction: 'CONFIRM_RECEIPT',
      );
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            orderId: 'order-1',
            repository: FakeOrdersRepository(
              detail: orderDetail(
                state: 'PICKED_UP',
                fulfillmentView: fulfillment,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Notes from Vendor'));
      await tester.pumpAndSettle();
      expect(find.text(_note), findsOneWidget);
      expect(find.text('Proof of pickup'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('long notes wrap at 320px with large text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: VendorOrderNotes(
                steps: [_step(note: List.filled(5, _note).join('\n'))],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Notes from Vendor'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
