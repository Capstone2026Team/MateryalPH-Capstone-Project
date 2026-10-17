import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/count_badge.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/notifications/navigation_counts_controller.dart';
import 'item_procurement_fakes.dart';

class CountsTransport implements NavigationCountsTransport {
  BuyerNavigationCounts value = const BuyerNavigationCounts();
  Future<BuyerNavigationCounts> Function()? load;
  void Function()? invalidation;
  int calls = 0;
  int stopped = 0;
  @override
  Future<BuyerNavigationCounts> counts() async {
    calls++;
    return load == null ? value : load!();
  }

  @override
  Future<void Function()> watchCounts(void Function() refresh) async {
    invalidation = refresh;
    return () {
      stopped++;
    };
  }
}

void main() {
  testWidgets(
    'loads without opening a page and coalesces concurrent incoming events',
    (tester) async {
      final transport = CountsTransport()
        ..value = const BuyerNavigationCounts(
          messages: 26,
          orders: 3,
          disputes: 2,
        );
      final controller = NavigationCountsController(transport)..setActive(true);
      await tester.pump();
      expect(controller.value.messages, 26);
      transport.value = const BuyerNavigationCounts(
        messages: 0,
        orders: 2,
        disputes: 0,
      );
      for (var i = 0; i < 20; i++) {
        transport.invalidation!();
      }
      await tester.pump(const Duration(milliseconds: 100));
      expect(transport.calls, 2);
      expect(controller.value.messages, 0);
      expect(controller.value.orders, 2);
      expect(controller.value.disputes, 0);
      controller.dispose();
    },
  );

  testWidgets(
    'an event during initial loading fetches missed state after that response',
    (tester) async {
      final initial = Completer<BuyerNavigationCounts>();
      final transport = CountsTransport()..load = () => initial.future;
      final controller = NavigationCountsController(transport)..setActive(true);
      await tester.pump();
      transport.invalidation!();
      transport.load = null;
      transport.value = const BuyerNavigationCounts(messages: 2);
      initial.complete(const BuyerNavigationCounts(messages: 1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.value.messages, 2);
      controller.dispose();
    },
  );

  testWidgets(
    'clears private counts on logout and rejects old-session responses',
    (tester) async {
      final old = Completer<BuyerNavigationCounts>();
      final transport = CountsTransport()..load = () => old.future;
      final controller = NavigationCountsController(transport)..setActive(true);
      await tester.pump();
      controller.setActive(false, clear: true);
      transport.load = null;
      transport.value = const BuyerNavigationCounts(messages: 4);
      controller.setActive(true);
      await tester.pump();
      old.complete(const BuyerNavigationCounts(messages: 99));
      await tester.pump();
      expect(controller.value.messages, 4);
      controller.setActive(false, clear: true);
      expect(controller.value.messages, 0);
      controller.dispose();
    },
  );

  testWidgets(
    'resynchronizes on foreground resume and polls when events are missed',
    (tester) async {
      final transport = CountsTransport();
      final controller = NavigationCountsController(transport)..setActive(true);
      await tester.pump();
      controller.setActive(false);
      transport.value = const BuyerNavigationCounts(orders: 5);
      await tester.pump(const Duration(seconds: 30));
      expect(transport.calls, 1);
      controller.setActive(true);
      await tester.pump();
      expect(controller.value.orders, 5);
      transport.value = const BuyerNavigationCounts(orders: 0);
      await tester.pump(const Duration(seconds: 15));
      expect(controller.value.orders, 0);
      controller.dispose();
    },
  );

  testWidgets(
    'older counts cannot overwrite a cart mutation returned by the server',
    (tester) async {
      final stale = Completer<BuyerNavigationCounts>();
      final transport = CountsTransport()..load = () => stale.future;
      final controller = NavigationCountsController(transport)..setActive(true);
      controller.publishCart('5.0001', 8);
      stale.complete(
        const BuyerNavigationCounts(
          messages: 2,
          cartQuantity: '2',
          cartVersion: 7,
        ),
      );
      await tester.pump();
      expect(controller.value.cartQuantity, '5.0001');
      expect(controller.value.messages, 2);
      controller.dispose();
    },
  );

  test(
    'cart quantities count units across lines rather than distinct lines',
    () {
      final controller = CartController(
        repository: FakeProcurementRepository(),
      );
      controller.replace(twoVendorCart());
      expect(controller.lineCount, 2);
      expect(controller.quantity, '4');
      controller.dispose();
      expect(compactBadgeQuantity('99.0001'), '99+');
      expect(compactBadgeQuantity('2.5001'), '2.5001');
    },
  );

  testWidgets(
    'badges hide zero and cap large totals without changing the accessible quantity',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Row(
            children: [
              CountBadge(quantity: '0'),
              CountBadge(quantity: '120'),
              CountBadge(quantity: '2.5'),
            ],
          ),
        ),
      );
      expect(find.text('0'), findsNothing);
      expect(find.text('99+'), findsOneWidget);
      expect(find.text('2.5'), findsOneWidget);
    },
  );
}
