import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/messaging_components.dart';
import 'package:materyalph/design_system/components/procurement_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/messaging/messaging_repository.dart';
import 'package:materyalph/features/messaging/conversation_timeline.dart';
import 'package:materyalph/features/messaging/conversation_quotations_screen.dart';
import 'package:materyalph/features/messaging/messaging_screen.dart';
import 'package:materyalph/features/orders/orders_repository.dart';
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

api.ChatQuotationVersion layoutQuotation({
  int version = 1,
  bool latest = true,
}) => api.ChatQuotationVersion(
  (b) => b
    ..id = 'version-$version'
    ..version = version
    ..latest = latest
    ..state = latest ? 'PUBLISHED' : 'SUPERSEDED'
    ..publishedAt = '2026-09-30T00:00:00Z'
    ..expiresAt = '2099-09-30T00:00:00Z'
    ..contentHash = 'hash-$version'
    ..viewed = true
    ..availablePaymentMethods.addAll(['ONLINE', 'IN_STORE'])
    ..actions.addAll(latest ? ['view', 'accept', 'reject', 'counter'] : [])
    ..content.update(
      (c) => c
        ..fulfillmentMethod = 'PICKUP'
        ..paymentMethod = 'ONLINE'
        ..fulfillmentDate = '2099-10-01'
        ..priceSource =
            api.ChatQuotationContentPriceSourceEnum.PRIVATE_TRANSACTION
        ..processingFeeStatus = 'PENDING_PAYMENT_CHANNEL'
        ..lines.add(
          api.ChatQuotationLine(
            (l) => l
              ..variantId = 'variant'
              ..quantity = '1.0000'
              ..unitPriceCentavos = 28550
              ..description = 'Rerolled steel bar'
              ..unitCode = 'PC'
              ..taxCategory = 'VAT_12'
              ..sourcePriceVersionId = 'price'
              ..sourceTaxVersionId = 'tax',
          ),
        )
        ..commercial.update(
          (m) => m
            ..materialsPayableCentavos = 28550
            ..materialsVatCentavos = 3059
            ..vendorDiscountCentavos = 0
            ..deliveryCentavos = 0
            ..nrpcCentavos = 0
            ..commercialTotalCentavos = 28550,
        ),
    ),
);

class LayoutMessagingRepository implements MessagingRepository {
  final quotationVersions = <api.ChatQuotationVersion>[];
  final quotationPages = <int>[];
  bool paginateQuotations = false;
  final projectRows = <api.ConversationView>[];
  final projectPages = <int>[];
  @override
  Future<api.ConversationPage> projectInquiries(
    String id, {
    int page = 1,
  }) async {
    projectPages.add(page);
    return api.ConversationPage(
      (b) => b
        ..items.addAll(projectRows.skip((page - 1) * 25).take(25))
        ..page = page
        ..hasMore = projectRows.length > page * 25,
    );
  }

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
    quotationPages.add(page);
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
        ..quotations.update(
          (q) => q
            ..versions.addAll(
              paginateQuotations
                  ? quotationVersions.skip((page - 1) * 10).take(10)
                  : quotationVersions,
            )
            ..page = page
            ..hasMore =
                paginateQuotations && quotationVersions.length > page * 10,
        ),
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

  final attachmentCalls = <String>[];

  final decisions = <({String action, String? paymentMethod})>[];
  @override
  Future<String?> decide(
    String id,
    String action,
    api.ChatQuotationVersion version,
    String key, {
    String? reason,
    bool nrpcAcknowledged = false,
    String? termsId,
    String? budgetOverrideReason,
    String? paymentMethod,
  }) async {
    decisions.add((action: action, paymentMethod: paymentMethod));
    return action == 'accept' ? 'accepted-order' : null;
  }

  @override
  Future<Uint8List> attachment(String id, String attachmentId) async {
    attachmentCalls.add(attachmentId);
    return base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx0gAAAABJRU5ErkJggg==',
    );
  }

  @override
  Future<Uint8List> avatar(String id, int userId) async => Uint8List(0);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class UnusedOrdersRepository implements OrdersRepository {
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
  OrdersRepository? orders,
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
        orders: orders,
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
    'accepted orders are reached through their quotation without repeated thread actions',
    (tester) async {
      final repository = LayoutMessagingRepository();
      repository.quotationVersions.addAll([
        for (final number in [2, 1])
          layoutQuotation(version: number, latest: false).rebuild(
            (b) => b
              ..state = 'ACCEPTED'
              ..acceptedOrderId = 'order-$number'
              ..actions.clear(),
          ),
      ]);
      await mount(
        tester,
        repository,
        thread: true,
        orders: UnusedOrdersRepository(),
      );
      expect(find.text('Open Order Details'), findsNothing);
      await tester.ensureVisible(find.text('Requested quotation v2'));
      await tester.tap(find.text('Requested quotation v2'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Open Order Details'),
        300,
        scrollable: find
            .descendant(
              of: find.byType(ConversationQuotationDetailScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Open Order Details'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
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
      // A reader at the bottom stays on the newest message.
      expect(find.text('Gap message 76'), findsOneWidget);
      repository.conversationChanged!();
      await tester.pumpAndSettle();
      expect(find.text('Gap message 76'), findsOneWidget);
      // Scrolling up reaches the filled gap and the message before it.
      for (final text in ['Gap message 2', 'Before disconnect']) {
        await tester.scrollUntilVisible(
          find.text(text),
          600,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(text), findsOneWidget);
      }
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
    'product entry replaces an older draft product and keeps the draft text',
    (tester) async {
      final repository = LayoutMessagingRepository();
      await mount(
        tester,
        repository,
        thread: true,
        initialProductId: 'product-one',
      );
      await tester.enterText(find.byType(TextField), 'Please quote');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpWidget(const SizedBox());
      await mount(
        tester,
        repository,
        thread: true,
        initialProductId: 'product-two',
      );
      expect(find.text('Fixture sand'), findsOneWidget);
      expect(find.text('Fixture cement'), findsNothing);
      expect(find.text('Please quote'), findsOneWidget);
      expect(repository.sendKeys, isEmpty);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('an ineligible product entry explains why nothing attached', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository();
    await mount(
      tester,
      repository,
      thread: true,
      initialProductId: 'product-retired',
    );
    expect(
      find.text('This product is no longer available to attach.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'latest attached product is prepared again unsent and typing expires without history',
    (tester) async {
      final repository = LayoutMessagingRepository()
        ..latestProduct = 'product-one';
      await mount(
        tester,
        repository,
        thread: true,
        initialProductId: 'product-one',
      );
      expect(find.text('Fixture cement'), findsOneWidget);
      expect(repository.sendKeys, isEmpty);
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
  test('quotations stay between messages at their publication time', () {
    final earlier = message(
      'before',
      'Before',
    ).rebuild((b) => b..sentAt = '2026-09-30T00:00:00Z');
    final later = message(
      'after',
      'After',
    ).rebuild((b) => b..sentAt = '2026-09-30T02:00:00Z');
    final quote = layoutQuotation().rebuild(
      (b) => b..publishedAt = '2026-09-30T01:00:00Z',
    );
    final entries = conversationTimeline([later, earlier], [quote]);
    expect(entries.map((e) => e.id), [
      'message-before',
      'quotation-version-1',
      'message-after',
    ]);
    final accepted = quote.rebuild(
      (b) => b
        ..state = 'ACCEPTED'
        ..actions.clear(),
    );
    expect(
      conversationTimeline([later, earlier], [accepted]).map((e) => e.id),
      entries.map((e) => e.id),
    );
  });
  for (final method in ['IN_STORE', 'ONLINE', 'CASH_ON_DELIVERY']) {
    testWidgets(
      'quotation acceptance requires the Buyer to choose $method explicitly',
      (tester) async {
        final delivery = method == 'CASH_ON_DELIVERY';
        final quote = layoutQuotation().rebuild(
          (b) => b
            ..availablePaymentMethods.replace([
              'ONLINE',
              delivery ? 'CASH_ON_DELIVERY' : 'IN_STORE',
            ])
            ..content.fulfillmentMethod = delivery ? 'DELIVERY' : 'PICKUP',
        );
        final repository = LayoutMessagingRepository()
          ..messages.clear()
          ..quotationVersions.add(quote);
        await mount(tester, repository, thread: true);
        await tester.tap(find.text('Requested quotation v1'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Review & accept'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Review & accept'));
        await tester.pumpAndSettle();
        final accept = find.widgetWithText(FilledButton, 'Accept version 1');
        expect(tester.widget<FilledButton>(accept).onPressed, isNull);
        expect(find.text('Choose payment method'), findsOneWidget);
        expect(
          find.text(delivery ? 'In-Store Payment' : 'Cash on Delivery (COD)'),
          findsNothing,
        );
        final label = method == 'ONLINE'
            ? 'Online payment'
            : method == 'IN_STORE'
            ? 'In-Store Payment'
            : 'Cash on Delivery (COD)';
        await tester.ensureVisible(find.text(label));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(tester.widget<FilledButton>(accept).onPressed, isNotNull);
        await tester.ensureVisible(accept);
        await tester.pumpAndSettle();
        await tester.tap(accept);
        await tester.pumpAndSettle();
        expect(
          repository.decisions
              .where((d) => d.action == 'accept')
              .single
              .paymentMethod,
          method,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
  testWidgets(
    'quotation history modal keeps list and details above the thread and preserves the draft',
    (tester) async {
      final repository = LayoutMessagingRepository()
        ..messages.clear()
        ..quotationVersions.addAll([
          layoutQuotation(version: 2),
          layoutQuotation(version: 1, latest: false),
        ]);
      await mount(tester, repository, thread: true);
      await tester.enterText(
        find.byType(TextField).last,
        'Keep my quotation draft',
      );
      expect(find.byTooltip('Cart'), findsNothing);
      expect(find.text('Rerolled steel bar'), findsNothing);
      await tester.tap(find.text('Requested quotation v2'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Quotation history'), findsOneWidget);
      expect(find.text('Quotation details'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byTooltip('Back'),
        ),
        findsNothing,
      );
      expect(find.text('Quotation v2'), findsOneWidget);
      expect(find.text('Review & accept'), findsOneWidget);
      await tester.ensureVisible(find.text('Counter-offer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Counter-offer'));
      await tester.pumpAndSettle();
      expect(find.text('Request changes'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Send request'),
            )
            .onPressed,
        isNull,
      );
      final requestedChanges = find.widgetWithText(
        TextField,
        'Requested changes',
      );
      await tester.enterText(requestedChanges, 'Please adjust the quantity.');
      tester.view.viewInsets = FakeViewPadding(
        bottom: 300 * tester.view.devicePixelRatio,
      );
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(FilledButton, 'Send request').hitTestable(),
        findsOneWidget,
      );
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Send request'),
            )
            .onPressed,
        isNotNull,
      );
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      tester.view.resetViewInsets();
      await tester.pumpAndSettle();
      expect(find.text('Quotation details'), findsOneWidget);
      await tester.tap(find.byTooltip('Close quotation history'));
      await tester.pumpAndSettle();
      expect(find.text('Keep my quotation draft'), findsOneWidget);

      await tester.tap(find.byTooltip('Quotations, 1 awaiting your response'));
      await tester.pumpAndSettle();
      final dialog = find.byType(Dialog);
      Finder inDialog(String label) =>
          find.descendant(of: dialog, matching: find.text(label));
      expect(inDialog('Requested quotation v2'), findsOneWidget);
      expect(inDialog('Requested quotation v1'), findsOneWidget);
      expect(find.text('Rerolled steel bar'), findsNothing);
      await tester.tap(inDialog('Requested quotation v1'));
      await tester.pumpAndSettle();
      expect(find.text('Quotation v1'), findsOneWidget);
      expect(find.text('Review & accept'), findsNothing);
      tester
          .state<NavigatorState>(
            find.descendant(of: dialog, matching: find.byType(Navigator)),
          )
          .pop();
      await tester.pumpAndSettle();
      expect(inDialog('Requested quotation v2'), findsOneWidget);
      await tester.tap(find.byTooltip('Close quotation history'));
      await tester.pumpAndSettle();
      expect(find.text('Keep my quotation draft'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('quotation list retries older pages and clears revoked details', (
    tester,
  ) async {
    final current = layoutQuotation(version: 2);
    final older = layoutQuotation(version: 1, latest: false);
    final pages = ValueNotifier<api.ChatQuotationPage?>(
      api.ChatQuotationPage(
        (b) => b
          ..versions.add(current)
          ..hasMore = true
          ..page = 1,
      ),
    );
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: ConversationQuotationsScreen(
          quotations: pages,
          onDecide: (_, _) async => null,
          onLoadOlder: () async {
            attempts++;
            if (attempts == 1) throw StateError('fixture offline');
            pages.value = api.ChatQuotationPage(
              (b) => b
                ..versions.addAll([current, older])
                ..hasMore = false
                ..page = 2,
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Older quotations'));
    await tester.pumpAndSettle();
    expect(find.text('Requested quotation v2'), findsOneWidget);
    expect(find.text('Retry older quotations'), findsOneWidget);
    await tester.tap(find.text('Retry older quotations'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.text('Requested quotation v1'), findsOneWidget);
    await tester.tap(find.text('Requested quotation v1'));
    await tester.pumpAndSettle();
    expect(find.text('Quotation v1'), findsOneWidget);
    expect(find.text('Review & accept'), findsNothing);
    pages.value = null;
    await tester.pumpAndSettle();
    expect(find.text('Quotation unavailable'), findsOneWidget);
    expect(find.text('Rerolled steel bar'), findsNothing);
    expect(find.text('Quotation v2'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    pages.dispose();
  });
  testWidgets('refresh keeps an open quotation from an older history page', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository()
      ..paginateQuotations = true
      ..messages.clear()
      ..quotationVersions.addAll([
        for (var i = 11; i >= 1; i--)
          layoutQuotation(version: i, latest: i == 11),
      ]);
    await mount(tester, repository, thread: true);
    await tester.tap(find.byTooltip('Quotations, 1 awaiting your response'));
    await tester.pumpAndSettle();
    final dialog = find.byType(Dialog);
    Finder inDialog(String label) =>
        find.descendant(of: dialog, matching: find.text(label));
    final historyScroll = find
        .descendant(of: dialog, matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(
      inDialog('Older quotations'),
      500,
      scrollable: historyScroll,
    );
    await tester.tap(inDialog('Older quotations'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      inDialog('Requested quotation v1'),
      500,
      scrollable: historyScroll,
    );
    await tester.tap(inDialog('Requested quotation v1'));
    await tester.pumpAndSettle();
    expect(find.text('Quotation v1'), findsOneWidget);
    final calls = repository.quotationPages.length;
    repository.conversationChanged!();
    await tester.pumpAndSettle();
    expect(repository.quotationPages.skip(calls), [1, 2]);
    expect(find.text('Quotation v1'), findsOneWidget);
    expect(find.text('Quotation unavailable'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('a thread without quotations still offers the quotations page', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository();
    await mount(tester, repository, thread: true);
    expect(find.byTooltip('Cart'), findsNothing);
    await tester.tap(find.byTooltip('Quotations'));
    await tester.pumpAndSettle();
    expect(find.text('No quotation yet'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
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

  testWidgets(
    'a clean photo previews inline with Download; a PDF stays a file row',
    (tester) async {
      api.ChatAttachment file(String id, String type, String name) =>
          api.ChatAttachment(
            (b) => b
              ..id = id
              ..displayName = name
              ..mediaType = type
              ..sizeBytes = 49152
              ..scanState = api.ChatAttachmentScanStateEnum.CLEAN,
          );
      final repository = LayoutMessagingRepository();
      repository.messages.addAll([
        message('p1', 'Attachment').rebuild(
          (b) => b
            ..kind = api.ChatMessageKindEnum.ATTACHMENT
            ..attachments.add(file('photo', 'image/png', 'Attachment.png')),
        ),
        message('p2', 'Attachment').rebuild(
          (b) => b
            ..kind = api.ChatMessageKindEnum.ATTACHMENT
            ..attachments.add(file('pdf', 'application/pdf', 'Attachment.pdf')),
        ),
      ]);
      await mount(tester, repository, thread: true);
      expect(find.byType(ChatImageAttachment), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('Photo Attachment.png')),
        findsOneWidget,
      );
      expect(find.text('Download'), findsOneWidget);
      expect(find.textContaining('Attachment.pdf'), findsOneWidget);
      // Only the photo is fetched, once, however often the thread rebuilds or polls.
      repository.conversationChanged!();
      await tester.pumpAndSettle();
      expect(repository.attachmentCalls, ['photo']);
      // The server's "Attachment" placeholder body is not repeated above the photo.
      expect(find.text('Attachment'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );

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
