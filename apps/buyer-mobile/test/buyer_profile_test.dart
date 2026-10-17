import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/buyer_home_screen.dart';
import 'package:materyalph/widgets/buyer_account_widgets.dart';
import 'buyer_account_test.dart' as fixtures;

void main() {
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
          expect(find.text('b***@example.test'), findsOneWidget);
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
    'notifications open the inbox and deletion opens its confirmation page',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: BuyerHomeScreen(
            repository: fixtures.repository(),
            onSignOut: () async {},
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Notifications'));
      await tester.pumpAndSettle();
      expect(find.text('Inbox'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Not yet implemented'), findsNothing);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
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
