import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/messaging_components.dart';
import 'package:materyalph/design_system/components/procurement_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/messaging/messaging_repository.dart';
import 'package:materyalph/features/messaging/messaging_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

// Synthetic UI fixtures. These do not represent live stores or provider data.
api.ConversationView layoutConversation(
  String id,
  String store, {
  int unread = 0,
}) => api.ConversationView(
  (b) => b
    ..id = id
    ..purpose = api.ConversationViewPurposeEnum.SALES
    ..contextType = api.ConversationViewContextTypeEnum.ITEM_BASED
    ..lockVersion = 1
    ..store.update(
      (s) => s
        ..id = id
        ..name = store
        ..verified = true,
    )
    ..handler.update(
      (h) => h
        ..displayName = 'Alex'
        ..role = 'CUSTOMER_SERVICE',
    )
    ..unreadCount = unread
    ..channel = 'private-test-$id'
    ..updatedAt = '2026-09-30T01:22:00Z'
    ..canTransfer = false
    ..fulfillmentEntryEnabled = false,
);

api.ChatMessage message(String id, String body, {bool mine = false}) =>
    api.ChatMessage(
      (b) => b
        ..id = id
        ..clientMessageId = id
        ..body = body
        ..kind = api.ChatMessageKindEnum.TEXT
        ..sender.update(
          (s) => s
            ..displayName = mine ? 'Buyer' : 'Alex'
            ..role = mine ? 'BUYER' : 'CUSTOMER_SERVICE',
        )
        ..sentAt = '2026-09-30T01:22:00Z'
        ..mine = mine
        ..readByRecipient = mine,
    );

class LayoutMessagingRepository implements MessagingRepository {
  final stores = [
    layoutConversation('one', 'Sampaloc Lumber Hardware', unread: 2),
    layoutConversation('two', 'L&D Hardware & Construction Supplies'),
  ];
  int inboxCalls = 0;
  bool failSend = false;
  bool failInbox = false;
  bool hasMore = false;
  final sendKeys = <String>[];
  VoidCallback? inboxChanged;
  VoidCallback? conversationChanged;
  bool inboxStopped = false;
  Completer<void>? inboxGate;
  final messages = [
    message('m1', 'Hello! Is this material available for pickup?', mine: true),
    message(
      'm2',
      'Hi! Let me check availability and prepare a quotation for you.',
    ),
    message('m3', 'Thank you. I need 12 pieces, please.', mine: true),
  ];

  @override
  Future<api.ConversationPage> inbox({int page = 1}) async {
    inboxCalls++;
    if (failInbox) throw StateError('fixture offline');
    final snapshot = api.ConversationPage(
      (b) => b
        ..items.addAll(stores)
        ..page = page
        ..hasMore = hasMore,
    );
    await inboxGate?.future;
    return snapshot;
  }

  @override
  Future<api.ConversationDetail> conversation(
    String id, {
    String? before,
    int page = 1,
  }) async => api.ConversationDetail(
    (b) => b
      ..conversation.replace(stores.first)
      ..messages.update(
        (m) => m
          ..items.addAll(messages)
          ..hasMore = false,
      )
      ..quotations.update((q) => q..hasMore = false),
  );

  @override
  Future<void> send(String id, String body, String key) async {
    sendKeys.add(key);
    if (failSend) throw StateError('fixture offline');
    messages.add(message('sent', body, mine: true));
  }

  @override
  Future<void> read(String id, String through) async {}
  @override
  Future<void Function()> watch(String channel, void Function() refresh) async {
    conversationChanged = refresh;
    return () => conversationChanged = null;
  }

  @override
  Future<void Function()> watchInbox(void Function() refresh) async {
    inboxChanged = refresh;
    inboxStopped = false;
    return () {
      inboxChanged = null;
      inboxStopped = true;
    };
  }

  @override
  Future<Uint8List> avatar(String id, int userId) async => Uint8List(0);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> mount(
  WidgetTester tester,
  LayoutMessagingRepository repository, {
  bool thread = false,
  double width = 390,
  double scale = 1,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 844));
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    return tester.binding.setSurfaceSize(null);
  });
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: BuyerTheme.light,
      home: MessagingScreen(
        repository: repository,
        conversationId: thread ? 'one' : null,
        onOpenCart: () {},
        onOpenNotifications: () {},
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('invalidation during a fetch is queued instead of dropped', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository();
    await mount(tester, repository);
    repository.inboxGate = Completer<void>();
    repository.inboxChanged!();
    await tester.pump();
    repository.stores.add(
      layoutConversation('queued', 'Arrived during refresh'),
    );
    repository.inboxChanged!();
    repository.inboxGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Arrived during refresh'), findsOneWidget);
    expect(repository.inboxCalls, 3);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'background pauses the inbox subscription and resume resynchronizes',
    (tester) async {
      final repository = LayoutMessagingRepository();
      await mount(tester, repository);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(repository.inboxStopped, isTrue);
      repository.stores.add(
        layoutConversation('resumed', 'Received while away'),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(repository.inboxStopped, isFalse);
      expect(find.text('Received while away'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'inbox updates from private invalidations and reuses shared states',
    (tester) async {
      final repository = LayoutMessagingRepository()..stores.clear();
      await mount(tester, repository);
      expect(find.byTooltip('Refresh messages'), findsNothing);
      expect(find.byType(StateMessage), findsOneWidget);
      expect(find.byType(PillSearchField), findsOneWidget);
      expect(find.byTooltip('Cart'), findsOneWidget);
      expect(find.byTooltip('Notifications'), findsOneWidget);
      repository.stores.add(
        layoutConversation('new', 'New conversation', unread: 1),
      );
      repository.inboxChanged!();
      await tester.pumpAndSettle();
      expect(find.text('New conversation'), findsOneWidget);
      expect(find.byType(StateMessage), findsNothing);
      await tester.pumpWidget(const SizedBox());
      expect(repository.inboxStopped, isTrue);
    },
  );

  testWidgets(
    'open conversation updates on an incoming message without manual refresh',
    (tester) async {
      final repository = LayoutMessagingRepository();
      await mount(tester, repository, thread: true);
      repository.messages.add(message('incoming', 'Your quotation is ready.'));
      repository.conversationChanged!();
      await tester.pumpAndSettle();
      expect(find.text('Your quotation is ready.'), findsOneWidget);
      expect(find.byTooltip('Refresh messages'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      expect(repository.conversationChanged, isNull);
    },
  );
  testWidgets('search filters stores locally and opens a conversation', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository()..hasMore = true;
    await mount(tester, repository);
    expect(find.text('Search applies to this page.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'sampaloc');
    await tester.pump();
    expect(find.text('L&D Hardware & Construction Supplies'), findsNothing);
    expect(repository.inboxCalls, 1);
    await tester.enterText(find.byType(TextField), 'unmatched');
    await tester.pump();
    expect(find.text('No matching conversations'), findsOneWidget);
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    await tester.tap(find.text('Sampaloc Lumber Hardware'));
    await tester.pumpAndSettle();
    expect(find.byType(ConversationMessageBubble), findsNWidgets(3));
    expect(find.textContaining('Handled by Alex'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('failed send preserves draft and retry identity', (tester) async {
    final repository = LayoutMessagingRepository()..failSend = true;
    await mount(tester, repository, thread: true);
    await tester.enterText(
      find.byType(TextField),
      'Please confirm the dimensions.',
    );
    await tester.pump();
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(find.text('Please confirm the dimensions.'), findsOneWidget);
    repository.failSend = false;
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(repository.sendKeys, hasLength(2));
    expect(repository.sendKeys[0], repository.sendKeys[1]);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('empty inbox and load failure provide recovery', (tester) async {
    final repository = LayoutMessagingRepository()
      ..stores.clear()
      ..failInbox = true;
    await mount(tester, repository);
    expect(find.text('Retry'), findsOneWidget);
    repository.failInbox = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No conversations yet'), findsOneWidget);
    expect(find.text('Previous'), findsNothing);
    expect(find.text('Next'), findsNothing);
    expect(find.text('Retry'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  for (final width in [320.0, 390.0, 768.0]) {
    testWidgets('inbox and thread fit at $width with large text', (
      tester,
    ) async {
      final repository = LayoutMessagingRepository();
      await mount(tester, repository, width: width, scale: 2);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Sampaloc Lumber Hardware'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byTooltip('Send message'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('capture inbox and conversation reference layouts', (
    tester,
  ) async {
    for (final font in {
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
      'Inter': 'assets/fonts/Inter-Variable.ttf',
      'packages/lucide_icons_flutter/Lucide':
          'packages/lucide_icons_flutter/assets/lucide.ttf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
    final repository = LayoutMessagingRepository();
    await mount(tester, repository);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/buyer-messaging/inbox.png',
      ),
    );
    await tester.tap(find.text('Sampaloc Lumber Hardware'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/buyer-messaging/conversation.png',
      ),
    );
    await tester.pumpWidget(const SizedBox());
    repository.stores.clear();
    await mount(tester, repository);
    await tester.runAsync(() async {
      await precacheImage(
        const AssetImage('assets/states/inbox.png'),
        tester.element(find.byType(StateMessage)),
      );
    });
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/buyer-messaging/empty-inbox.png',
      ),
    );
    await tester.pumpWidget(const SizedBox());
  });
}
