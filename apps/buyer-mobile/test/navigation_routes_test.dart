import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/orders/order_models.dart';
import 'package:materyalph/features/orders/order_submitted_screen.dart';
import 'package:materyalph/features/orders/orders_screen.dart';
import 'package:materyalph/screens/buyer_profile_screen.dart';

import 'buyer_account_test.dart' as fixtures;
import 'orders_fakes.dart';

/// Regression coverage for the Buyer button audit: each control must reach its real destination.
Widget _app(Widget home) => MaterialApp(theme: BuyerTheme.light, home: home);

Future<void> _pumpProfile(
  WidgetTester tester, {
  VoidCallback? orders,
  VoidCallback? cart,
  VoidCallback? search,
  VoidCallback? notifications,
}) async {
  await tester.pumpWidget(
    _app(
      BuyerProfileScreen(
        repository: fixtures.repository(),
        onSignedOut: () {},
        onSignOut: () async {},
        onOpenOrders: orders,
        onOpenCart: cart,
        onOpenSearch: search,
        onOpenNotifications: notifications,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Profile rows and header actions use the supplied destinations', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final taps = <String>[];
    await _pumpProfile(
      tester,
      orders: () => taps.add('orders'),
      cart: () => taps.add('cart'),
      search: () => taps.add('search'),
      notifications: () => taps.add('notifications'),
    );

    await tester.tap(find.text('Orders'));
    await tester.tap(find.text('Cart'));
    await tester.tap(find.byTooltip('Search'));
    await tester.tap(find.byTooltip('Notifications'));
    await tester.tap(find.text('Notification Settings'));

    expect(taps, ['orders', 'cart', 'search', 'notifications', 'notifications']);
  });

  testWidgets('Profile Orders and Cart fall back to the placeholder only when unwired', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpProfile(tester);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('This feature is not available yet.'), findsOneWidget);
  });

  testWidgets('View my orders clears the checkout trail so Back returns Home', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = FakeOrdersRepository(
      list: const OrderListPage(
        items: [],
        counts: {},
        page: 1,
        hasMore: false,
        total: 0,
      ),
    );
    final checkout = CheckoutView(
      id: 'checkout-1',
      reference: 'CHK-2026-ZX12CV34',
      submittedAt: DateTime.utc(2026, 10, 5, 1),
      notice: 'Each Vendor reviews its own order request.',
      orders: const [],
    );
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const Scaffold(
                      body: Center(child: Text('Cart page')),
                    ),
                  ),
                ),
                child: const Text('Home'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) =>
            OrderSubmittedScreen(checkout: checkout, repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('View my orders'));
    await tester.pumpAndSettle();
    expect(find.byType(OrdersScreen), findsOneWidget);

    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('Cart page'), findsNothing);
    expect(find.text('Home'), findsOneWidget);
  });
}
