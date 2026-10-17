import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/count_badge.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/notifications/navigation_counts_controller.dart';
import 'package:materyalph/features/notifications/navigation_refresh_binding.dart';
import 'package:materyalph/features/notifications/notification_scope.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/orders/order_fulfillment_sections.dart';
import 'package:materyalph/features/orders/order_models.dart';
import 'package:materyalph/features/orders/orders_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'orders_fakes.dart';

NotificationsRepository notifications() {
  final client = api.MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final Object data;
          if (options.path.endsWith('/navigation-updates')) {
            data = {
              'sections': <String, int>{},
              'cart_quantity': '0',
              'cart_version': 0,
            };
          } else if (options.path.endsWith('/realtime')) {
            data = {
              'enabled': false,
              'key': null,
              'channel': null,
              'host': null,
              'port': null,
              'scheme': null,
            };
          } else {
            data = <Object>[];
          }
          handler.resolve(
            Response<Object>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'data': data,
                'meta': <String, Object>{},
                'errors': <Object>[],
              },
            ),
          );
        },
      ),
    ],
  );
  return NotificationsRepository(
    client,
    () async => fail('Session must remain active'),
  );
}

Widget app(NotificationsRepository repository, Widget child) => MaterialApp(
  theme: BuyerTheme.light,
  home: NotificationScope(repository: repository, child: child),
);

OrderListPage pageWithUnread(int count) => OrderListPage(
  items: [
    orderSummary(
      state: 'CONFIRMED',
      nextAction: null,
      conversation: OrderConversationRefView(
        id: 'thread-1',
        readOnly: false,
        unreadCount: count,
      ),
    ),
  ],
  counts: const {},
  page: 1,
  hasMore: false,
  total: 1,
);

FulfillmentView fulfillment(int count) => FulfillmentView(
  method: 'PICKUP',
  state: 'PENDING',
  late: false,
  steps: const [],
  trackingNotice: 'Recorded milestones only.',
  receipt: const FulfillmentReceiptView(paused: false, windowHours: 48),
  thread: FulfillmentThreadView(
    available: true,
    readOnly: false,
    conversationId: 'thread-1',
    unreadCount: count,
  ),
  nextAction: 'NONE',
);

class DelayedOrders extends FakeOrdersRepository {
  Future<OrderListPage>? pending;
  @override
  Future<OrderListPage> orders({
    required String group,
    String? procurementType,
    int page = 1,
  }) =>
      pending ??
      super.orders(group: group, procurementType: procurementType, page: page);
}

class PagedOrders extends FakeOrdersRepository {
  final Map<int, OrderListPage> pages = {};
  @override
  Future<OrderListPage> orders({
    required String group,
    String? procurementType,
    int page = 1,
  }) async {
    calls.add('page:$page');
    return pages[page]!;
  }
}

class Counts implements NavigationCountsTransport {
  @override
  Future<BuyerNavigationCounts> counts() async => const BuyerNavigationCounts();
  @override
  Future<void Function()> watchCounts(void Function() refresh) async => () {};
}

void main() {
  testWidgets(
    'private delivery invalidations refresh the assigned staff and delivered proof without a manual reload',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final notices = notifications();
      const proofId = '01a0fb55-e5f2-7081-a9ee-314ee8596f70';
      const proof = FulfillmentProofView(
        milestone: 'DELIVERED',
        receiverName: 'Site Foreman',
        receiverKind: 'AUTHORIZED_RECEIVER',
        handoverConfirmed: true,
        recordedBy: 'Delivery Staff',
        photoPath: '/buyers/orders/order-1/files/$proofId',
      );
      FulfillmentView delivery({
        bool dispatched = false,
        bool delivered = false,
      }) => FulfillmentView(
        method: 'DELIVERY',
        state: delivered
            ? 'DELIVERED'
            : dispatched
            ? 'OUT_FOR_DELIVERY'
            : 'PROCESSING',
        late: false,
        steps: [
          FulfillmentStepView(
            key: 'OUT_FOR_DELIVERY',
            label: 'Out for delivery',
            status: dispatched ? 'COMPLETE' : 'CURRENT',
            proofRequired: false,
          ),
          FulfillmentStepView(
            key: 'DELIVERED',
            label: 'Delivered',
            status: delivered
                ? 'COMPLETE'
                : dispatched
                ? 'CURRENT'
                : 'UPCOMING',
            proofRequired: true,
            actorRole: delivered ? 'FULFILLMENT' : null,
            proof: delivered ? proof : null,
          ),
        ],
        trackingNotice: 'Recorded milestones only.',
        receipt: const FulfillmentReceiptView(paused: false, windowHours: 48),
        thread: const FulfillmentThreadView(
          available: true,
          readOnly: false,
          conversationId: 'delivery-thread',
        ),
        nextAction: delivered ? 'CONFIRM_RECEIPT' : 'NONE',
        assigneeName: dispatched ? 'Delivery Staff' : null,
        vehicleName: dispatched ? 'Accepted truck' : null,
        proof: delivered ? proof : null,
      );
      final orders = FakeOrdersRepository(
        detail: orderDetail(
          state: 'PROCESSING',
          fulfillment: 'DELIVERY',
          fulfillmentView: delivery(),
        ),
      );
      orders.files[proofId] = Uint8List(0);
      await tester.pumpWidget(
        app(
          notices,
          OrderDetailsScreen(orderId: 'order-1', repository: orders),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Delivery vehicle: Accepted truck'), findsNothing);
      expect(find.text('Proof of delivery'), findsNothing);

      orders.detail = orderDetail(
        state: 'OUT_FOR_DELIVERY',
        fulfillment: 'DELIVERY',
        fulfillmentView: delivery(dispatched: true),
      );
      notices.navigation.invalidate();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Delivery Staff · Fulfillment Staff'), findsOneWidget);
      expect(find.text('Delivery vehicle: Accepted truck'), findsOneWidget);
      expect(find.text('Confirm receipt'), findsNothing);

      orders.detail = orderDetail(
        state: 'DELIVERED',
        fulfillment: 'DELIVERY',
        actions: const {'CONFIRM_RECEIPT', 'REPORT_PROBLEM'},
        fulfillmentView: delivery(dispatched: true, delivered: true),
      );
      notices.navigation.invalidate();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Proof of delivery'), findsOneWidget);
      expect(
        find.text('Received by Site Foreman (authorized receiver)'),
        findsOneWidget,
      );
      expect(orders.calls, contains('orderFile:$proofId'));
      expect(find.text('Confirm receipt'), findsOneWidget);
      expect(orders.calls.where((call) => call == 'confirmReceipt'), isEmpty);
      await tester.pumpWidget(const SizedBox());
      notices.dispose();
    },
  );

  testWidgets(
    'order card fulfillment badges update and clear on private account synchronization',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final notices = notifications();
      final orders = FakeOrdersRepository(list: pageWithUnread(120));
      await tester.pumpWidget(
        app(
          notices,
          OrdersScreen(repository: orders, openConversation: (_, _) async {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byTooltip('Fulfillment messages, 120 unread'),
        findsOneWidget,
      );
      expect(find.text('99+'), findsOneWidget);
      orders.list = pageWithUnread(2);
      unawaited(notices.navigation.refresh());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Fulfillment messages, 2 unread'), findsOneWidget);
      orders.list = pageWithUnread(0);
      unawaited(notices.navigation.refresh());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Fulfillment messages'), findsOneWidget);
      expect(find.text('99+'), findsNothing);
      final count = tester.widget<CountBadge>(find.byType(CountBadge).last);
      expect(count.quantity, '0');
      expect(
        orders.calls.where(
          (call) => call.startsWith('openFulfillmentConversation'),
        ),
        isEmpty,
      );
      await tester.pumpWidget(const SizedBox());
      notices.dispose();
    },
  );

  testWidgets(
    'order detail fulfillment icon uses server counts without leaving the page',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final notices = notifications();
      final orders = FakeOrdersRepository(
        detail: orderDetail(fulfillmentView: fulfillment(1)),
      );
      await tester.pumpWidget(
        app(
          notices,
          OrderDetailsScreen(
            orderId: 'order-1',
            repository: orders,
            openConversation: (_, _) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      final entry = find.byType(FulfillmentThreadEntry);
      expect(
        find.descendant(of: entry, matching: find.text('1')),
        findsOneWidget,
      );
      orders.detail = orderDetail(fulfillmentView: fulfillment(5));
      unawaited(notices.navigation.refresh());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: entry, matching: find.text('5')),
        findsOneWidget,
      );
      orders.detail = orderDetail(fulfillmentView: fulfillment(0));
      unawaited(notices.navigation.refresh());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: entry, matching: find.text('5')),
        findsNothing,
      );
      expect(find.text('Fulfillment Messages'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      notices.dispose();
    },
  );

  testWidgets(
    'resuming an initially loading order list discards its old response and recovers automatically',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final notices = notifications();
      final old = Completer<OrderListPage>();
      final orders = DelayedOrders()
        ..pending = old.future
        ..list = pageWithUnread(2);
      await tester.pumpWidget(
        app(
          notices,
          OrdersScreen(repository: orders, openConversation: (_, _) async {}),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      orders.pending = null;
      old.complete(pageWithUnread(120));
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Fulfillment messages, 2 unread'), findsOneWidget);
      expect(find.text('99+'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      notices.dispose();
    },
  );

  testWidgets('refreshing unread messages preserves every loaded order page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final notices = notifications();
    final orders = PagedOrders();
    OrderListPage page(int number, int count) => OrderListPage(
      items: [
        orderSummary(
          id: 'order-$number',
          state: 'CONFIRMED',
          nextAction: null,
          conversation: OrderConversationRefView(
            id: 'thread-$number',
            readOnly: false,
            unreadCount: count,
          ),
        ),
      ],
      counts: const {},
      page: number,
      hasMore: number == 1,
      total: 2,
    );
    orders.pages.addAll({1: page(1, 1), 2: page(2, 2)});
    await tester.pumpWidget(
      app(
        notices,
        OrdersScreen(repository: orders, openConversation: (_, _) async {}),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show more orders'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Fulfillment messages, 2 unread'), findsOneWidget);
    orders.pages.addAll({1: page(1, 5), 2: page(2, 7)});
    unawaited(notices.navigation.refresh());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Fulfillment messages, 5 unread'), findsOneWidget);
    expect(find.byTooltip('Fulfillment messages, 7 unread'), findsOneWidget);
    expect(orders.calls.sublist(orders.calls.length - 2), ['page:1', 'page:2']);
    await tester.pumpWidget(const SizedBox());
    notices.dispose();
  });

  testWidgets(
    'read synchronization coalesces events and ignores local cart publications',
    (tester) async {
      final controller = NavigationCountsController(Counts())..setActive(true);
      await tester.pump();
      var calls = 0;
      final pending = Completer<void>();
      final binding = NavigationRefreshBinding(() async {
        calls++;
        if (calls == 1) await pending.future;
      }, () {});
      binding.bind(controller);
      await controller.refresh();
      await tester.pump(const Duration(milliseconds: 100));
      expect(calls, 1);
      await controller.refresh();
      await controller.refresh();
      pending.complete();
      await tester.pump();
      expect(calls, 2);
      await tester.pump(const Duration(milliseconds: 100));
      controller.publishCart('2', 1);
      await tester.pump(const Duration(milliseconds: 100));
      expect(calls, 2);
      binding.dispose();
      controller.dispose();
    },
  );

  testWidgets(
    'changing account repositories cancels the previous pending clear',
    (tester) async {
      final previous = NavigationCountsController(Counts())..setActive(true);
      final current = NavigationCountsController(Counts())..setActive(true);
      await tester.pump();
      var clears = 0;
      var refreshes = 0;
      final binding = NavigationRefreshBinding(
        () async => refreshes++,
        () => clears++,
      );
      binding.bind(previous);
      final old = binding.stamp;
      previous.setActive(false, clear: true);
      binding.bind(current);
      await tester.pump(const Duration(milliseconds: 1));
      expect(clears, 0);
      expect(binding.isCurrent(old), isFalse);
      await current.refresh();
      await tester.pump(const Duration(milliseconds: 100));
      expect(refreshes, 1);
      binding.dispose();
      previous.dispose();
      current.dispose();
    },
  );

  testWidgets(
    'account switching and background resume invalidate delayed order reads',
    (tester) async {
      final controller = NavigationCountsController(Counts())..setActive(true);
      await tester.pump();
      var clears = 0;
      final binding = NavigationRefreshBinding(() async {}, () => clears++);
      binding.bind(controller);
      final request = binding.stamp;
      controller.setActive(false, clear: true);
      await tester.pump(const Duration(milliseconds: 1));
      expect(clears, 1);
      expect(binding.isCurrent(request), isFalse);
      expect(binding.isSameScope(request), isFalse);
      controller.setActive(true);
      await tester.pump();
      expect(binding.isCurrent(request), isFalse);
      final resumed = binding.stamp;
      controller.setActive(false);
      controller.setActive(true);
      await tester.pump();
      expect(binding.isCurrent(resumed), isFalse);
      expect(binding.isSameScope(resumed), isTrue);
      binding.dispose();
      controller.dispose();
    },
  );
}
