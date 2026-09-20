import 'package:materyalph/screens/login_screen.dart';
import 'package:materyalph/screens/register_screen.dart';
import 'package:materyalph/screens/welcome_screen.dart';
import 'package:materyalph/screens/terms_screen.dart';
import 'package:materyalph/screens/buyer_account_screen.dart';
import 'terms_fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/buyer_home_screen.dart';
import 'buyer_account_test.dart' as fixtures;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
    await (FontLoader('packages/lucide_icons_flutter/Lucide')..addFont(
          rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
        ))
        .load();
  });
  testWidgets('capture Buyer profile, account settings and unavailable view', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: BuyerTheme.light,
        home: BuyerHomeScreen(
          repository: fixtures.repository(),
          onSignOut: () async {},
        ),
      ),
    );
    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/ui-refinement/buyer-profile.png',
      ),
    );
    await tester.scrollUntilVisible(find.text('Account Setting'), 180);
    await Scrollable.ensureVisible(
      tester.element(find.text('Account Setting')),
      alignment: .5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Account Setting'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/ui-refinement/buyer-settings.png',
      ),
    );
    await tester.tap(find.byTooltip('Edit profile picture'));
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => precacheImage(
        const AssetImage('assets/states/not-implemented.png'),
        tester.element(find.byType(Image)),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/ui-refinement/buyer-unavailable.png',
      ),
    );
  });
  testWidgets('capture refined Buyer authentication and account pages', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = (await tester.runAsync(reviewedRepository))!;
    final screens = <String, Widget>{
      'welcome': WelcomeScreen(
        onLogin: () {},
        onRegister: () {},
        onGoogle: () async {},
      ),
      'login': LoginScreen(
        authRepository: repository,
        onAuthenticated: () {},
        onRegister: () {},
        onForgotPassword: () {},
        onBack: () {},
        onGoogle: () async {},
      ),
      'registration': RegisterScreen(
        authRepository: repository,
        onVerificationRequired: (_) {},
        onGoogleRegister: () {},
        onLogin: () {},
        onBack: () {},
      ),
      'terms': TermsScreen(
        repository: termsRepository(),
        onAccepted: () {},
        onBack: () {},
      ),
      for (final section in ['Profile', 'Security', 'Sessions', 'Agreements'])
        'account-${section.toLowerCase()}': BuyerAccountScreen(
          repository: fixtures.repository(verified: true),
          initialSection: section,
          onSignedOut: () {},
        ),
    };
    for (final entry in screens.entries) {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: BuyerTheme.light,
          home: KeyedSubtree(key: ValueKey(entry.key), child: entry.value),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          '../../../docs/design/evidence/buyer-account-refinement/${entry.key}.png',
        ),
      );
    }
  });
}
