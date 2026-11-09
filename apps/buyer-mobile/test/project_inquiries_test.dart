import 'package:built_value/json_object.dart';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:materyalph/design_system/theme.dart';

import 'package:materyalph/features/messaging/messaging_screen.dart';

import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'messaging_layout_test.dart'
    show LayoutMessagingRepository, layoutConversation, message;

api.ConversationView packageThread() =>
    layoutConversation('package-one', 'Package supplier').rebuild(
      (b) => b
        ..contextType = api.ConversationViewContextTypeEnum.PROJECT_BASED
        ..inquiryLabel = 'Foundation materials'
        ..lockedReference.addAll({
          'work_package': JsonObject({
            'name': 'Foundation materials',
            'lines': [
              {
                'name': 'Cement requirement',
                'quantity': '10',
                'unit_code': 'BAG',
              },
            ],
          }),

          'working_duplicate': JsonObject({
            'lines': [
              {
                'description': 'Proposed cement',
                'quantity': '10',
                'unit_code': 'BAG',
              },
            ],
          }),
        }),
    );

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  testWidgets('Work Packages appear directly in the unified inbox', (
    tester,
  ) async {
    final repository = LayoutMessagingRepository();

    repository.stores.insert(0, packageThread());

    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: MessagingScreen(repository: repository),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Foundation materials'), findsOneWidget);

    expect(find.byTooltip('Project inquiries'), findsNothing);

    await tester.tap(find.text('Foundation materials'));

    await tester.pumpAndSettle();

    expect(find.text('Foundation materials'), findsOneWidget);

    expect(find.byTooltip('Quotations'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'a Work Package message attachment opens without losing the store chat draft',
    (tester) async {
      final repository = LayoutMessagingRepository();

      repository.messages.clear();
      repository.messages.add(
        message('package-card', 'Work Package').rebuild(
          (b) => b
            ..kind = api.ChatMessageKindEnum.WORK_PACKAGE
            ..conversationId = 'one'
            ..workPackageAttachment.update(
              (attachment) => attachment
                ..inquiryId = 'package-one'
                ..reference.replace(packageThread().lockedReference)
                ..canPrepareQuotation = false,
            ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: MessagingScreen(repository: repository, conversationId: 'one'),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).last,
        'Keep this package draft',
      );

      await tester.tap(find.text('Foundation materials'));

      await tester.pumpAndSettle();

      expect(find.text('Locked Buyer original'), findsOneWidget);

      expect(find.text('Cement requirement'), findsOneWidget);

      expect(find.text('Proposed cement'), findsOneWidget);

      await tester.tap(find.byTooltip('Close work package attachment'));

      await tester.pumpAndSettle();

      expect(find.text('Keep this package draft'), findsOneWidget);

      expect(find.text('Cement requirement'), findsNothing);

      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'saved automated options submit an explicit selection and keep the composer open',
    (tester) async {
      final repository = LayoutMessagingRepository();

      repository.messages.clear();

      repository.messages.add(
        message('welcome-one', 'Welcome to our store.').rebuild(
          (b) => b
            ..kind = api.ChatMessageKindEnum.SYSTEM
            ..sender.update(
              (s) => s
                ..displayName = 'Supplier · Automated response'
                ..role = 'SYSTEM',
            )
            ..automatedReply.options.add(
              api.ChatAutomatedOption(
                (o) => o
                  ..index = 0
                  ..label = 'Store hours'
                  ..available = true,
              ),
            ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: MessagingScreen(repository: repository, conversationId: 'one'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome to our store.'), findsOneWidget);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Store hours'));

      await tester.pumpAndSettle();

      expect(repository.automatedChoices, [('welcome-one', 0)]);

      expect(find.byType(TextField), findsOneWidget);

      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox());
    },
  );
}
