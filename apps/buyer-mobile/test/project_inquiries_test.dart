import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/messaging/messaging_screen.dart';
import 'package:materyalph/features/messaging/project_inquiries_screen.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'messaging_layout_test.dart'
    show LayoutMessagingRepository, layoutConversation;

class ProjectMessagingRepository extends LayoutMessagingRepository {
  bool failProjects = false;
  int? failProjectPage;
  Object? projectFailure;
  Completer<void>? moreGate;
  final projectAttempts = <int>[];
  final pageOverrides = <int, List<api.ConversationView>>{};
  final opened = <String>[];
  @override
  Future<api.ConversationPage> projectInquiries(
    String id, {
    int page = 1,
  }) async {
    projectAttempts.add(page);
    if (failProjects || failProjectPage == page) {
      throw projectFailure ?? StateError('Offline');
    }
    var value = await super.projectInquiries(id, page: page);
    if (pageOverrides[page] case final rows?) {
      value = value.rebuild((b) => b..items.replace(rows));
    }
    if (page > 1) await moreGate?.future;
    return value;
  }

  @override
  Future<api.ConversationDetail> conversation(
    String id, {
    String? before,
    int page = 1,
    int legacyPage = 1,
  }) async {
    opened.add(id);
    final value = await super.conversation(
      id,
      before: before,
      page: page,
      legacyPage: legacyPage,
    );
    return id == 'one'
        ? value
        : value.rebuild(
            (b) => b
              ..conversation.replace(
                projectRows.firstWhere((row) => row.id == id),
              ),
          );
  }
}

api.ConversationView projectRow(int index) =>
    layoutConversation('project-$index', 'Supply').rebuild(
      (b) => b
        ..contextType = api.ConversationViewContextTypeEnum.PROJECT_BASED
        ..inquiryLabel = 'Foundation $index'
        ..mainConversationId = 'one'
        ..unreadCount = 2,
    );

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  testWidgets(
    'project picker opens its own thread and returning preserves the main item draft',
    (tester) async {
      final repository = ProjectMessagingRepository()
        ..projectRows.add(projectRow(1));
      repository.stores[0] = repository.stores.first.rebuild(
        (b) => b..projectUnreadCount = 2,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: MessagingScreen(repository: repository, conversationId: 'one'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Item inquiry'), findsNothing);
      expect(find.text('Project inquiries'), findsNothing);
      expect(find.byTooltip('Notifications'), findsNothing);
      final composer = find.byType(TextField).last;
      await tester.enterText(composer, 'Keep this item inquiry draft');
      await tester.tap(find.byTooltip('Project inquiries, 2 unread'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Foundation 1'));
      await tester.pumpAndSettle();
      expect(repository.opened, contains('project-1'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Keep this item inquiry draft'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'project picker retries an initial failure and scrolls continuously into later records',
    (tester) async {
      final repository = ProjectMessagingRepository()
        ..projectRows.addAll(List.generate(26, projectRow))
        ..failProjects = true;
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: ProjectInquiriesScreen(
            repository: repository,
            inquiryId: 'one',
            onOpen: (id) async => selected = id,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Unable to load project inquiries'),
        findsOneWidget,
      );
      repository.failProjects = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Previous'), findsNothing);
      expect(find.text('Page 1'), findsNothing);
      expect(find.text('Next'), findsNothing);
      await tester.scrollUntilVisible(find.text('Foundation 25'), 600);
      await tester.pumpAndSettle();
      expect(repository.projectPages, [1, 2]);
      await tester.tap(find.text('Foundation 25'));
      await tester.pumpAndSettle();
      expect(selected, 'project-25');
      await tester.fling(find.byType(ListView), const Offset(0, 5000), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Foundation 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'loading later inquiries keeps existing rows, blocks duplicate requests and deduplicates overlapping pages',
    (tester) async {
      final repository = ProjectMessagingRepository()
        ..projectRows.addAll(List.generate(26, projectRow))
        ..pageOverrides[2] = [projectRow(24), projectRow(25)]
        ..moreGate = Completer<void>();
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: ProjectInquiriesScreen(
            repository: repository,
            inquiryId: 'one',
            onOpen: (_) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.fling(find.byType(ListView), const Offset(0, -5000), 3000);
      await tester.pump(const Duration(seconds: 1));
      expect(repository.projectAttempts, [1, 2]);
      expect(find.text('Foundation 24'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump(const Duration(milliseconds: 100));
      expect(repository.projectAttempts, [1, 2]);
      repository.moreGate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Foundation 24'), findsOneWidget);
      expect(find.text('Foundation 25'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(repository.projectAttempts, [1, 2]);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'a later page failure preserves records and retries the same request inline',
    (tester) async {
      final repository = ProjectMessagingRepository()
        ..projectRows.addAll(List.generate(26, projectRow))
        ..failProjectPage = 2;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: ProjectInquiriesScreen(
            repository: repository,
            inquiryId: 'one',
            onOpen: (_) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.fling(find.byType(ListView), const Offset(0, -5000), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Foundation 24'), findsOneWidget);
      expect(
        find.textContaining('Unable to load more project inquiries'),
        findsOneWidget,
      );
      expect(repository.projectAttempts, [1, 2]);
      repository.failProjectPage = null;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(repository.projectAttempts, [1, 2, 2]);
      expect(find.text('Foundation 25'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('realtime refresh retains the loaded range and scroll position', (
    tester,
  ) async {
    final repository = ProjectMessagingRepository()
      ..projectRows.addAll(List.generate(26, projectRow));
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: ProjectInquiriesScreen(
          repository: repository,
          inquiryId: 'one',
          onOpen: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Foundation 25'), 600);
    await tester.pumpAndSettle();
    final position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    final offset = position.pixels;
    repository.projectRows[25] = repository.projectRows[25].rebuild(
      (b) => b..lastMessagePreview = 'Updated project reply',
    );
    repository.inboxChanged!();
    await tester.pumpAndSettle();
    expect(repository.projectAttempts, [1, 2, 1, 2]);
    expect(find.text('Updated project reply'), findsOneWidget);
    expect(position.pixels, closeTo(offset, 1));
    expect(find.text('Foundation 25'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'a revoked conversation clears loaded private records instead of retaining a cached list',
    (tester) async {
      final repository = ProjectMessagingRepository()
        ..projectRows.addAll(List.generate(26, projectRow))
        ..failProjectPage = 2
        ..projectFailure = const DiscoveryFailure(
          DiscoveryFailureKind.forbidden,
          'Conversation access changed.',
        );
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: ProjectInquiriesScreen(
            repository: repository,
            inquiryId: 'one',
            onOpen: (_) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.fling(find.byType(ListView), const Offset(0, -5000), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Conversation access changed.'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('Foundation 24'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
