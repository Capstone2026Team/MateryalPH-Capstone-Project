import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/buyer_account_screen.dart';
import 'package:materyalph/screens/buyer_profile_screen.dart';
import 'package:materyalph/widgets/legal_content.dart';
import 'buyer_account_test.dart' as fixtures;

void main() {
  testWidgets(
    'Profile search is labelled, announces its placeholder and keeps notifications',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: BuyerProfileScreen(
            repository: fixtures.repository(),
            onSignedOut: () {},
            onSignOut: () async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('Search'), findsOneWidget);
      expect(find.byTooltip('Notifications'), findsOneWidget);
      expect(find.text('+639171234567'), findsOneWidget);
      await tester.tap(find.byTooltip('Search'));
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(SnackBar, 'Not yet implemented.'),
        findsOneWidget,
      );
      expect(find.byType(BuyerProfileScreen), findsOneWidget);
      final snackSemantics = find.descendant(
        of: find.byType(SnackBar),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.liveRegion == true,
        ),
      );
      expect(snackSemantics, findsWidgets);
    },
  );

  for (final section in ['Profile', 'Security', 'Sessions', 'Agreements']) {
    testWidgets(
      '$section is standalone at 320px, enlarged text, with working content',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(() {
          tester.platformDispatcher.clearTextScaleFactorTestValue();
          return tester.binding.setSurfaceSize(null);
        });
        await tester.pumpWidget(
          MaterialApp(
            theme: BuyerTheme.light,
            home: BuyerAccountScreen(
              repository: fixtures.repository(
                verified: true,
                name:
                    'Buyer with a very long registered family name and given names',
              ),
              onSignedOut: () {},
              initialSection: section,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ChoiceChip), findsNothing);
        expect(find.byType(TabBar), findsNothing);
        if (section == 'Profile') {
          await tester.scrollUntilVisible(
            find.text('buyer.with.a.long.email.address@example.test'),
            180,
            scrollable: find.byType(Scrollable).first,
          );
          expect(
            find.text('buyer.with.a.long.email.address@example.test'),
            findsOneWidget,
          );
          await tester.scrollUntilVisible(
            find.text('+639171234567'),
            180,
            scrollable: find.byType(Scrollable).first,
          );
          expect(find.text('+639171234567'), findsOneWidget);
        } else if (section == 'Security') {
          expect(find.text('Verify your identity'), findsOneWidget);
          await tester.scrollUntilVisible(
            find.text('Change password'),
            180,
            scrollable: find.byType(Scrollable).first,
          );
        } else if (section == 'Sessions') {
          expect(find.textContaining('Current device'), findsOneWidget);
          await tester.scrollUntilVisible(
            find.text('Revoke session'),
            180,
            scrollable: find.byType(Scrollable).first,
          );
          await Scrollable.ensureVisible(
            tester.element(find.text('Revoke session')),
            alignment: .5,
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('Revoke session'));
          await tester.pumpAndSettle();
          expect(find.byType(AlertDialog), findsOneWidget);
        } else {
          expect(find.byType(LegalContent), findsOneWidget);
          expect(find.textContaining('Accepted'), findsOneWidget);
          expect(find.text('# Terms of Service'), findsNothing);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('genuinely missing phone displays the not-added state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerProfileScreen(
          repository: fixtures.repository(phone: null),
          onSignedOut: () {},
          onSignOut: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Phone number not added'), findsOneWidget);
  });
}
