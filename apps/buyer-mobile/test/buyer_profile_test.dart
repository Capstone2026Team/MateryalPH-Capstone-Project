import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/notifications/notification_scope.dart';
import 'package:materyalph/features/notifications/notification_settings_screen.dart';
import 'package:materyalph/features/notifications/notifications_screen.dart';
import 'package:materyalph/screens/buyer_home_screen.dart';
import 'package:materyalph/screens/buyer_profile_screen.dart';
import 'package:materyalph/features/trust/buyer_ratings_section.dart';
import 'package:materyalph/features/trust/trust_models.dart';
import 'package:materyalph/widgets/buyer_account_widgets.dart';
import 'buyer_account_test.dart' as fixtures;
import 'fulfillment_badges_test.dart' show notifications;
import 'trust_fakes.dart';

void main() {
  setUpAll(() async {
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    await (FontLoader('packages/lucide_icons_flutter/Lucide')..addFont(
          rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
        ))
        .load();
  });
  testWidgets('Profile stays navigable when no repository is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: BuyerHomeScreen(onSignOut: () async {}),
      ),
    );
    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Not yet implemented'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'profile and separate settings reflow at $size scale $scale',
        (tester) async {
          await tester.binding.setSurfaceSize(size);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(() {
            tester.platformDispatcher.clearTextScaleFactorTestValue();
            return tester.binding.setSurfaceSize(null);
          });
          await tester.pumpWidget(
            MaterialApp(
              theme: BuyerTheme.light,
              home: BuyerHomeScreen(
                repository: fixtures.repository(),
                onSignOut: () async {},
              ),
            ),
          );
          await tester.pumpAndSettle();
          final positions = [
            for (final label in [
              'Map',
              'Explore',
              'Projects',
              'Messages',
              'Profile',
            ])
              tester.getCenter(find.bySemanticsLabel(label)),
          ];
          for (final label in ['Explore', 'Projects', 'Messages', 'Profile']) {
            await tester.tap(find.bySemanticsLabel(label));
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          }
          expect(find.text('Buyer fixture'), findsOneWidget);
          expect(
            find.text('buyer.with.a.long.email.address@example.test'),
            findsOneWidget,
          );
          expect(find.text('+639171234567'), findsOneWidget);
          for (var i = 0; i < positions.length; i++) {
            expect(
              tester.getCenter(
                find.bySemanticsLabel(
                  ['Map', 'Explore', 'Projects', 'Messages', 'Profile'][i],
                ),
              ),
              positions[i],
            );
          }
          await reveal(tester, 'Account Setting');
          await tester.tap(find.text('Account Setting'));
          await tester.pumpAndSettle();
          expect(find.text('Upload photo'), findsNothing);
          expect(find.bySemanticsLabel('Change profile photo'), findsOneWidget);
          expect(find.text('+639171234567'), findsOneWidget);
          await reveal(tester, 'Edit Account Details');
          await tester.tap(find.text('Edit Account Details'));
          await tester.pumpAndSettle();
          await reveal(tester, 'Full name');
          expect(find.widgetWithText(TextField, 'Full name'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.tap(find.byTooltip('Back'));
          await tester.pumpAndSettle();
          await reveal(tester, 'Password Manager');
          await tester.tap(find.text('Password Manager'));
          await tester.pumpAndSettle();
          await reveal(tester, 'Verify identity');
          expect(
            find.widgetWithText(FilledButton, 'Verify identity'),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'Profile has an inline score and opens Your rating below Account Setting',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final reviews = FakeReviewsRepository()
        ..received = BuyerReceivedRatingsView(
          summary: const BuyerRatingSummaryView(count: 5, score: 4.25),
          items: [
            BuyerReceivedRatingView(
              id: 'received-rating',
              storeName: 'Sample Supply',
              orderReference: 'ORD-SAMPLE',
              ratings: const ReviewRatingsView(
                inquirySeriousness: 4,
                communicationQuality: 5,
                paymentReliability: 4,
              ),
              submittedAt: DateTime.utc(2026, 11, 5),
            ),
          ],
          total: 1,
        );
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('buyer-profile-preview'),
          child: MaterialApp(
            theme: BuyerTheme.light,
            home: BuyerProfileScreen(
              repository: fixtures.repository(),
              reviewsRepository: reviews,
              onSignedOut: () {},
              onSignOut: () async {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Your Buyer rating'), findsNothing);
      expect(find.text('4.25'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Your Buyer rating: 4.25 of 5'),
        findsOneWidget,
      );
      expect(find.byTooltip('Email verified'), findsOneWidget);
      expect(
        find.text('buyer.with.a.long.email.address@example.test'),
        findsOneWidget,
      );
      expect(
        (tester.getTopLeft(find.text('Buyer fixture')).dy -
                tester.getTopLeft(find.text('4.25')).dy)
            .abs(),
        lessThan(16),
      );
      await captureProfile(tester, 'profile');
      await reveal(tester, 'Your rating');
      final rows = tester
          .widgetList<BuyerMenuRow>(find.byType(BuyerMenuRow))
          .map((row) => row.label)
          .toList();
      expect(rows.indexOf('Your rating'), rows.indexOf('Account Setting') + 1);
      await tester.tap(find.text('Your rating'));
      await tester.pumpAndSettle();
      expect(find.byType(BuyerRatingsScreen), findsOneWidget);
      expect(find.text('Your rating'), findsOneWidget);
      expect(find.text('4.25 / 5'), findsOneWidget);
      expect(find.text('Sample Supply'), findsOneWidget);
      await captureProfile(tester, 'buyer-rating');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.byType(BuyerRatingsScreen), findsNothing);
    },
  );

  testWidgets(
    'Profile does not show an email check without email verification',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerProfileScreen(
            repository: fixtures.repository(emailVerified: false),
            onSignedOut: () {},
            onSignOut: () async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('Email verified'), findsNothing);
    },
  );

  testWidgets(
    'notifications open the inbox and deletion opens its confirmation page',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: NotificationScope(
            repository: notifications(),
            child: BuyerHomeScreen(
              repository: fixtures.repository(),
              onSignOut: () async {},
            ),
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Notifications'));
      await tester.pumpAndSettle();
      expect(find.byType(NotificationsScreen), findsOneWidget);
      expect(find.text('Not yet implemented'), findsNothing);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      // Preferences have their own profile row.
      await reveal(tester, 'Notification Settings');
      await tester.tap(find.text('Notification Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(NotificationSettingsScreen), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      // Account Setting sits above the Notification Settings row.
      await tester.scrollUntilVisible(
        find.text('Account Setting'),
        -180,
        scrollable: find.byType(Scrollable).first,
      );
      await reveal(tester, 'Account Setting');
      await tester.tap(find.text('Account Setting'));
      await tester.pumpAndSettle();
      await reveal(tester, 'Delete Account');
      final row = tester.widget<BuyerMenuRow>(
        find.widgetWithText(BuyerMenuRow, 'Delete Account'),
      );
      expect(row.destructive, isTrue);
      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();
      expect(find.text('Not yet implemented'), findsNothing);
      expect(find.text('Delete your MateryalPH account'), findsOneWidget);
      // Nothing is deleted from merely opening the page.
      expect(
        find.widgetWithText(FilledButton, 'Delete my account'),
        findsNothing,
      );
    },
  );

  test(
    'light system overlays preserve visible Android and iOS status information',
    () {
      expect(BuyerTheme.systemUi.statusBarIconBrightness, Brightness.dark);
      expect(BuyerTheme.systemUi.statusBarBrightness, Brightness.light);
      expect(
        BuyerTheme.light.appBarTheme.systemOverlayStyle,
        BuyerTheme.systemUi,
      );
      expect(BuyerTheme.systemUi, isA<SystemUiOverlayStyle>());
    },
  );
}

Future<void> captureProfile(WidgetTester tester, String name) async {
  if (!const bool.fromEnvironment('CAPTURE_BUYER_PROFILE')) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('buyer-profile-preview')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('../../.tmp/buyer-profile-review/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

Future<void> reveal(WidgetTester tester, String label) async {
  final finder = label == 'Verify identity'
      ? find.widgetWithText(FilledButton, label)
      : find.text(label);
  await tester.scrollUntilVisible(
    finder,
    180,
    scrollable: find.byType(Scrollable).first,
  );
  await Scrollable.ensureVisible(tester.element(finder), alignment: .5);
  await tester.pumpAndSettle();
}
