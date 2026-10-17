import 'dart:async';
import 'package:built_value/json_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/notifications/notification_inbox_controller.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

api.NotificationItem notice(String id, String category, {String? readAt}) =>
    api.NotificationItem(
      (b) => b
        ..id = id
        ..category = category
        ..title = 'Order ORD-$id updated'
        ..body = 'Review the current record.'
        ..mandatory = true
        ..createdAt = '2026-10-09T00:00:00Z'
        ..readAt = readAt,
    );

api.ListNotifications200Response page(
  List<api.NotificationItem> items, [
  String? cursor,
]) => api.ListNotifications200Response(
  (b) => b
    ..data.replace(items)
    ..meta.addAll({'next_cursor': cursor == null ? null : JsonObject(cursor)}),
);

class FakeTransport implements NotificationInboxTransport {
  List<api.NotificationItem> items = [];
  Future<api.ListNotifications200Response> Function(String? cursor)? onList;
  Completer<api.NotificationBulkReadAction>? reads;
  Completer<String>? destination;
  void Function()? invalidated;
  String? through, category;
  int stopped = 0;
  @override
  Future<api.ListNotifications200Response> list([String? cursor]) async =>
      onList == null ? page(items) : onList!(cursor);
  @override
  Future<api.NotificationBulkReadAction> readAll(
    String throughId,
    String? selectedCategory,
  ) async {
    through = throughId;
    category = selectedCategory;
    final result = await reads!.future;
    items = items
        .map(
          (item) =>
              item.readAt == null &&
                  item.id.compareTo(throughId) <= 0 &&
                  (selectedCategory == null ||
                      item.category == selectedCategory)
              ? item.rebuild((b) => b..readAt = result.readAt)
              : item,
        )
        .toList();
    return result;
  }

  @override
  Future<String> resolve(String id) async {
    final result = await destination!.future;
    items = items
        .map(
          (item) => item.id == id
              ? item.rebuild((b) => b..readAt = '2026-10-09T01:00:00Z')
              : item,
        )
        .toList();
    return result;
  }

  @override
  Future<void Function()> watch(void Function() refresh) async {
    invalidated = refresh;
    return () {
      stopped++;
      invalidated = null;
    };
  }
}

Future<NotificationInboxController> loaded(FakeTransport transport) async {
  final inbox = NotificationInboxController(transport);
  addTearDown(inbox.dispose);
  inbox.setActive(true);
  await inbox.refresh();
  await Future<void>.delayed(Duration.zero);
  return inbox;
}

void main() {
  test(
    'categories group order titles and the inbox lists unread notices only',
    () async {
      final source = FakeTransport()
        ..items = [
          notice('03', 'ORDERS'),
          notice('02', 'ORDERS'),
          notice('01', 'SECURITY', readAt: '2026-10-09T01:00:00Z'),
          notice('00', 'NEW_CATEGORY'),
        ];
      final inbox = await loaded(source);
      expect(inbox.visible.map((item) => item.id), ['03', '02', '00']);
      expect(inbox.categories, contains('SECURITY'));
      expect(
        inbox.categories.where((category) => category == 'ORDERS'),
        hasLength(1),
      );
      expect(notificationCategoryLabel('ORDERS'), 'Order updates');
      expect(notificationCategoryLabel('NEW_CATEGORY'), 'New category');
      inbox.filter(type: 'ORDERS');
      expect(inbox.filteredUnreadCount, 2);
      expect(inbox.unreadCount, 3);
      inbox.setActive(false);
      inbox.setActive(true);
      await inbox.refresh();
      expect(inbox.category, 'ORDERS');
      inbox.filter(type: 'SECURITY');
      expect(inbox.visible, isEmpty);
      inbox.clearFilters();
      expect(inbox.category, isNull);
    },
  );

  test(
    'read-all marks matching unread instantly and keeps later arrivals unread',
    () async {
      final source = FakeTransport()
        ..items = [
          notice('03', 'ORDERS'),
          notice('02', 'SECURITY'),
          notice('01', 'ORDERS'),
        ]
        ..reads = Completer<api.NotificationBulkReadAction>();
      final inbox = await loaded(source);
      inbox.filter(type: 'ORDERS');
      final action = inbox.markAllRead();
      expect(inbox.visible, isEmpty);
      expect(inbox.unreadCount, 1);
      expect(source.through, '03');
      expect(source.category, 'ORDERS');
      source.items.insert(0, notice('04', 'ORDERS'));
      await inbox.refresh();
      expect(inbox.visible.single.id, '04');
      source.reads!.complete(
        api.NotificationBulkReadAction(
          (b) => b
            ..read = true
            ..readCount = 2
            ..readAt = '2026-10-09T01:00:00Z',
        ),
      );
      await action;
      await inbox.refresh();
      expect(inbox.visible.single.id, '04');
      expect(inbox.filteredUnreadCount, 1);
      expect(inbox.canMarkAll, isTrue);
    },
  );

  test(
    'failed bulk read rolls back only captured notices and retains error and new arrivals',
    () async {
      final source = FakeTransport()
        ..items = [notice('02', 'ORDERS'), notice('01', 'SECURITY')]
        ..reads = Completer<api.NotificationBulkReadAction>();
      final inbox = await loaded(source);
      inbox.filter(type: 'ORDERS');
      final action = inbox.markAllRead();
      source.items.insert(0, notice('03', 'ORDERS'));
      await inbox.refresh();
      source.reads!.completeError(
        const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You are offline.',
        ),
      );
      await action;
      await inbox.refresh();
      expect(inbox.visible.map((item) => item.id), ['03', '02']);
      expect(inbox.unreadCount, 3);
      expect(inbox.error, 'You are offline.');
    },
  );

  test(
    'view details keeps notice unread until authoritative success and then marks it read',
    () async {
      final source = FakeTransport()
        ..items = [notice('01', 'SECURITY')]
        ..destination = Completer<String>();
      final inbox = await loaded(source);
      final opening = inbox.open('01');
      expect(inbox.unreadCount, 1);
      source.destination!.complete('/settings');
      expect(await opening, '/settings');
      expect(inbox.unreadCount, 0);
      expect(inbox.visible, isEmpty);
    },
  );

  test(
    'all cursor pages including revoked empty pages load atomically and stale responses cannot restore reads',
    () async {
      final source = FakeTransport();
      final last = Completer<api.ListNotifications200Response>();
      source.onList = (cursor) async => switch (cursor) {
        null => page([notice('03', 'ORDERS')], 'second'),
        'second' => page([], 'last'),
        _ => last.future,
      };
      final inbox = NotificationInboxController(source);
      addTearDown(inbox.dispose);
      inbox.setActive(true);
      await Future<void>.delayed(Duration.zero);
      expect(inbox.loaded, isFalse);
      expect(inbox.items, isEmpty);
      last.complete(page([notice('01', 'SECURITY')]));
      await inbox.refresh();
      expect(inbox.unreadCount, 2);
      final stale = Completer<api.ListNotifications200Response>();
      source.onList = (_) => stale.future;
      source.destination = Completer<String>()..complete('/settings');
      final refreshing = inbox.refresh();
      await inbox.open('03');
      stale.complete(page([notice('03', 'ORDERS'), notice('01', 'SECURITY')]));
      source.onList = (_) async => page([
        notice('03', 'ORDERS', readAt: '2026-10-09T01:00:00Z'),
        notice('01', 'SECURITY'),
      ]);
      await refreshing;
      await inbox.refresh();
      expect(inbox.unreadCount, 1);
    },
  );

  test(
    'partial page failure preserves full snapshot and access denial clears badges and filters',
    () async {
      final source = FakeTransport()..items = [notice('01', 'SECURITY')];
      final inbox = await loaded(source);
      inbox.filter(type: 'SECURITY');
      source.onList = (cursor) async {
        if (cursor == null) return page([notice('02', 'ORDERS')], 'next');
        throw const DiscoveryFailure(DiscoveryFailureKind.offline, 'Offline');
      };
      await inbox.refresh();
      expect(inbox.items.single.id, '01');
      source.onList = (_) async => throw const DiscoveryFailure(
        DiscoveryFailureKind.forbidden,
        'Access changed.',
      );
      await inbox.refresh();
      expect(inbox.items, isEmpty);
      expect(inbox.unreadCount, 0);
      expect(inbox.category, isNull);
      expect(inbox.error, 'Access changed.');
      expect(source.stopped, 1);
    },
  );

  test(
    'background pause disposes realtime, unlocks pending reads and rejects old private snapshots',
    () async {
      final source = FakeTransport()
        ..items = [notice('01', 'SECURITY')]
        ..reads = Completer<api.NotificationBulkReadAction>();
      final inbox = await loaded(source);
      final reading = inbox.markAllRead();
      inbox.setActive(false);
      expect(inbox.marking, isFalse);
      expect(inbox.unreadCount, 1);
      source.reads!.complete(
        api.NotificationBulkReadAction(
          (b) => b
            ..read = true
            ..readCount = 1
            ..readAt = '2026-10-09T01:00:00Z',
        ),
      );
      await reading;
      inbox.setActive(true);
      await inbox.refresh();
      expect(inbox.unreadCount, 0);
      final stale = Completer<api.ListNotifications200Response>();
      source.onList = (_) => stale.future;
      final refreshing = inbox.refresh();
      inbox.setActive(false, clear: true);
      stale.complete(page([notice('03', 'ORDERS')]));
      await refreshing;
      expect(inbox.items, isEmpty);
      expect(inbox.unreadCount, 0);
      expect(inbox.loaded, isFalse);
    },
  );
}
