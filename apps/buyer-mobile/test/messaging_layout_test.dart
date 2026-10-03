import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    ..fulfillmentEntryEnabled = false
    ..readOnly = false,
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
  bool paginateMessages = false;
  final requestedCursors = <String?>[];
  final sendKeys = <String>[];
  final sentProducts = <String?>[];
  final typingEvents = <bool>[];
  void Function(bool, int)? typingChanged;
  Completer<void>? sendGate;
  String? latestProduct;
  final catalog = [
    api.ChatProduct(
      (b) => b
        ..productId = 'product-one'
        ..listingId = 'listing-one'
        ..name = 'Fixture cement'
        ..priceCentavos = 1800
        ..available = true,
    ),
    api.ChatProduct(
      (b) => b
        ..productId = 'product-two'
        ..listingId = 'listing-two'
        ..name = 'Fixture sand'
        ..priceCentavos = 2200
        ..available = true,
    ),
  ];
  @override
  Future<api.ChatProductPage> products(
    String id, {
    String? query,
    String? productId,
    int page = 1,
  }) async => api.ChatProductPage(
    (b) => b
      ..items.addAll(
        catalog.where(
          (p) =>
              (productId == null || productId == p.productId) &&
              (query == null ||
                  p.name.toLowerCase().contains(query.toLowerCase())),
        ),
      )
      ..page = page
      ..hasMore = false,
  );
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

  final archivedStores = <api.ConversationView>[];
  bool failArchive = false;
  final archiveCalls = <String>[];

  @override
  Future<api.ConversationPage> inbox({
    int page = 1,
    bool archived = false,
  }) async {
    inboxCalls++;
    if (failInbox) throw StateError('fixture offline');
    final snapshot = api.ConversationPage(
      (b) => b
        ..items.addAll(archived ? archivedStores : stores)
        ..page = page
        ..hasMore = hasMore,
    );
    await inboxGate?.future;
    return snapshot;
  }

  @override
  Future<void> archive(String id) async {
    archiveCalls.add('archive:$id');
    if (failArchive) throw StateError('fixture offline');
    final index = stores.indexWhere((c) => c.id == id);
    if (index >= 0) archivedStores.add(stores.removeAt(index));
  }

  @override
  Future<void> restore(String id) async {
    archiveCalls.add('restore:$id');
    if (failArchive) throw StateError('fixture offline');
    final index = archivedStores.indexWhere((c) => c.id == id);
    if (index >= 0) stores.add(archivedStores.removeAt(index));
  }

  @override
  Future<api.ConversationDetail> conversation(
    String id, {
    String? before,
    int page = 1,
    int legacyPage = 1,
  }) async {
    requestedCursors.add(before);
    final eligible = messages
        .where((m) => before == null || m.id.compareTo(before) < 0)
        .toList();
    final pageItems = paginateMessages && eligible.length > 50
        ? eligible.sublist(eligible.length - 50)
        : eligible;
    return api.ConversationDetail(
      (b) => b
        ..conversation.replace(
          stores.first.rebuild((c) => c..latestProductId = latestProduct),
        )
        ..messages.update(
          (m) => m
            ..items.addAll(pageItems)
            ..hasMore = paginateMessages && eligible.length > 50
            ..nextBefore = paginateMessages && eligible.length > 50
                ? pageItems.first.id
                : null,
        )
        ..quotations.update((q) => q..hasMore = false),
    );
  }

  @override
  Future<void> send(
    String id,
    String body,
    String key, {
    String? productId,
  }) async {
    sendKeys.add(key);
    sentProducts.add(productId);
    await sendGate?.future;
    if (failSend) throw StateError('fixture offline');
    messages.add(message(key, body, mine: true));
  }

  @override
  Future<void> read(String id, String through) async {}
  @override
  Future<void> typing(String id, bool typing) async {
    typingEvents.add(typing);
  }

  @override
  Future<void Function()> watch(
    String channel,
    void Function() refresh, {
    void Function(bool, int)? onTyping,
    void Function(bool)? onLive,
  }) async {
    typingChanged = onTyping;
    conversationChanged = refresh;
    liveChanged = onLive;
    return () => conversationChanged = null;
  }

  void Function(bool)? liveChanged;

  @override
  Future<void Function()> watchInbox(
    void Function() refresh, {
    void Function(bool)? onLive,
  }) async {
    inboxChanged = refresh;
    liveChanged = onLive;
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
  String? initialProductId,
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
        initialProductId: initialProductId,
        conversationId: thread ? 'one' : null,
        onOpenCart: () {},
        onOpenNotifications: () {},
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  testWidgets(
    'reconnect fills a gap larger than one page without duplicate messages',
    (tester) async {
      final repository = LayoutMessagingRepository()..paginateMessages = true;
      repository.messages.clear();
      repository.messages.add(message('000001', 'Before disconnect'));
      await mount(tester, repository, thread: true);
      for (var i = 2; i <= 76; i++) {
        repository.messages.add(
          message(i.toString().padLeft(6, '0'), 'Gap message $i'),
        );
      }
      repository.conversationChanged!();
      await tester.pumpAndSettle();
      expect(repository.requestedCursors, contains('000027'));
      expect(find.text('Before disconnect'), findsOneWidget);
      expect(find.text('Gap message 2'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Gap message 76'),
        600,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Gap message 76'), findsOneWidget);
      repository.conversationChanged!();
      await tester.pumpAndSettle();
      expect(find.text('Gap message 76'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'product entry is an unsent persistent removable draft and picker adds another product',
    (tester) async {
      final repository = LayoutMessagingRepository();
      await mount(
        tester,
        repository,
        thread: true,
        initialProductId: 'product-one',
      );
      expect(find.text('Fixture cement'), findsOneWidget);
      expect(repository.sendKeys, isEmpty);
      await tester.enterText(find.byType(TextField), 'Please quote');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpWidget(const SizedBox());
      await mount(tester, repository, thread: true);
      expect(find.text('Fixture cement'), findsOneWidget);
      expect(find.text('Please quote'), findsOneWidget);
      await tester.tap(find.byTooltip('Remove product'));
      expect(find.text('Attach product'), findsNothing);
      await tester.tap(find.byTooltip('More actions'));
      await tester.pump();
      await tester.tap(find.text('Attach product'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'sand');
      await tester.tap(find.byTooltip('Search products'));
      await tester.pumpAndSettle();
      expect(find.text('Fixture cement'), findsNothing);
      await tester.tap(find.text('Fixture sand'));
      await tester.pumpAndSettle();
      repository.sendGate = Completer<void>();
      await tester.tap(find.byTooltip('Send message'));
      await tester.pump();
      expect(find.text('Sending…'), findsOneWidget);
      expect(repository.sentProducts, ['product-two']);
      repository.sendGate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Sending…'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'latest attached product is not reattached and typing expires without history',
    (tester) async {
      final repository = LayoutMessagingRepository()
        ..latestProduct = 'product-one';
      await mount(
        tester,
        repository,
        thread: true,
        initialProductId: 'product-one',
      );
      expect(find.text('Fixture cement'), findsNothing);
      repository.typingChanged!(true, 2);
      repository.typingChanged!(false, 1);
      await tester.pump();
      expect(find.byType(TypingIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.byType(TypingIndicator), findsNothing);
      expect(repository.messages, hasLength(3));
      await tester.pumpWidget(const SizedBox());
    },
  );
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
  testWidgets(
    'composer actions hide behind a toggle and history links are gone',
    (tester) async {
      final repository = LayoutMessagingRepository();
      await mount(tester, repository, thread: true);
      expect(find.text('Attach product'), findsNothing);
      expect(find.text('Earlier inquiry history'), findsNothing);
      await tester.tap(find.byTooltip('More actions'));
      await tester.pump();
      expect(find.text('Attach product'), findsOneWidget);
      expect(find.text('Attach file (JPG, PNG, PDF)'), findsOneWidget);
      await tester.tap(find.byTooltip('Hide actions'));
      await tester.pump();
      expect(find.text('Attach product'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'store typing shows an animated indicator until its message lands',
    (tester) async {
      final repository = LayoutMessagingRepository();
      await mount(tester, repository, thread: true);
      expect(find.byType(TypingIndicator), findsNothing);
      repository.typingChanged!(true, 1);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(TypingIndicator), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('is typing')), findsOneWidget);

      repository.messages.add(message('typed', 'Here is the price.'));
      repository.conversationChanged!();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Here is the price.'), findsOneWidget);
      expect(find.byType(TypingIndicator), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('thread polls every few seconds until realtime is live', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository();
    await mount(tester, repository, thread: true);
    repository.messages.add(message('polled', 'Polled reply'));
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Polled reply'), findsOneWidget);

    repository.liveChanged!(true);
    await tester.pumpAndSettle();
    final calls = repository.requestedCursors.length;
    await tester.pump(const Duration(seconds: 12));
    expect(repository.requestedCursors.length, calls);

    repository.liveChanged!(false);
    await tester.pumpAndSettle();
    expect(repository.requestedCursors.length, greaterThan(calls));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('thread opens at and follows the newest message', (tester) async {
    final repository = LayoutMessagingRepository();
    for (var i = 0; i < 30; i++) {
      repository.messages.add(
        message('n${i.toString().padLeft(3, '0')}', 'Filler $i'),
      );
    }
    await mount(tester, repository, thread: true);
    expect(find.text('Filler 29'), findsOneWidget);
    expect(
      find.text('Hello! Is this material available for pickup?'),
      findsNothing,
    );

    repository.messages.add(message('o000', 'Newest reply'));
    repository.conversationChanged!();
    await tester.pumpAndSettle();
    expect(find.text('Newest reply'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('swipe left archives, Archived lists it and swipe restores', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository();
    await mount(tester, repository);
    await tester.drag(
      find.text('Sampaloc Lumber Hardware'),
      const Offset(-400, 0),
    );
    await tester.pumpAndSettle();
    expect(repository.archiveCalls, ['archive:one']);
    expect(find.text('Sampaloc Lumber Hardware'), findsNothing);
    expect(find.text('Conversation archived'), findsOneWidget);

    await tester.tap(find.text('Archived'));
    await tester.pumpAndSettle();
    expect(find.text('Archived messages'), findsOneWidget);
    expect(find.text('Sampaloc Lumber Hardware'), findsOneWidget);

    await tester.drag(
      find.text('Sampaloc Lumber Hardware'),
      const Offset(-400, 0),
    );
    await tester.pumpAndSettle();
    expect(repository.archiveCalls.last, 'restore:one');
    expect(find.text('No archived messages'), findsOneWidget);

    await tester.tap(find.text('Back to messages'));
    await tester.pumpAndSettle();
    expect(find.text('Sampaloc Lumber Hardware'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a failed archive keeps the conversation and explains why', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository()..failArchive = true;
    await mount(tester, repository);
    await tester.drag(
      find.text('Sampaloc Lumber Hardware'),
      const Offset(-400, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sampaloc Lumber Hardware'), findsOneWidget);
    expect(
      find.text('Unable to archive this conversation. Please retry.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

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
    await tester.ensureVisible(find.text('Failed to send · Retry'));
    await tester.tap(find.text('Failed to send · Retry'));
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
    expect(find.text('No messages yet'), findsOneWidget);
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
