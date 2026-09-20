import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/register_screen.dart';
import 'package:materyalph/screens/terms_screen.dart';
import 'terms_fixtures.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'Terms gate at 320px scale $scale requires the actual end, then opens registration',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(() {
          tester.platformDispatcher.clearTextScaleFactorTestValue();
          return tester.binding.setSurfaceSize(null);
        });
        final semantics = tester.ensureSemantics();

        final repository = termsRepository();
        await tester.pumpWidget(
          MaterialApp(
            theme: BuyerTheme.light,
            home: RegisterScreen(
              authRepository: repository,
              onVerificationRequired: (_) {},
              onGoogleRegister: () {},
              onLogin: () {},
              onBack: () {},
            ),
          ),
        );
        // Even constructing the registration widget directly cannot skip Terms.
        expect(find.byType(TermsScreen), findsOneWidget);
        FilledButton cta() => tester.widget(
          find.widgetWithText(FilledButton, 'Accept and continue'),
        );
        expect(cta().onPressed, isNull);
        await tester.pumpAndSettle();
        expect(cta().onPressed, isNull);
        expect(
          tester.getSemantics(
            find.widgetWithText(FilledButton, 'Accept and continue'),
          ),
          matchesSemantics(
            isButton: true,
            hasEnabledState: true,
            isEnabled: false,
            label: 'Accept and continue',
          ),
        );
        await tester.drag(
          find.byKey(const Key('terms-content')),
          const Offset(0, -160),
        );
        await tester.pumpAndSettle();
        expect(cta().onPressed, isNull);
        await tester.pump(const Duration(seconds: 30));
        expect(cta().onPressed, isNull);
        final scroll = tester
            .widget<SingleChildScrollView>(
              find.byKey(const Key('terms-content')),
            )
            .controller!;
        scroll.jumpTo(scroll.position.maxScrollExtent - 1);
        await tester.pumpAndSettle();
        expect(cta().onPressed, isNotNull);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Accept and continue'));
        await tester.pumpAndSettle();
        expect(find.text('Get started now'), findsOneWidget);
        expect(repository.hasReviewedTerms, isTrue);
        expect(tester.takeException(), isNull);
        // A new flow or process does not inherit the review.
        repository.clearTermsReview();
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(
          MaterialApp(
            home: RegisterScreen(
              authRepository: repository,
              onVerificationRequired: (_) {},
              onGoogleRegister: () {},
              onLogin: () {},
              onBack: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(TermsScreen), findsOneWidget);
        expect(cta().onPressed, isNull);
        semantics.dispose();
      },
    );
  }
  test(
    'repository rejects registration and Google signup without review',
    () async {
      var requests = 0;
      final repository = termsRepository(onRequest: (_) => requests++);
      await expectLater(
        repository.register(
          fullName: 'Test Buyer',
          email: 'buyer@example.test',
          mobileE164: '+639171234567',
          password: 'ExamplePassword123',
          buyerType: 'INDIVIDUAL',
        ),
        throwsA(isA<BuyerAuthException>()),
      );
      await expectLater(
        repository.startGoogleSignIn(signUp: true),
        throwsA(isA<BuyerAuthException>()),
      );
      expect(requests, 0);
    },
  );
  test(
    'reviewed version and source hash reach the generated registration contract',
    () async {
      Map<String, dynamic>? submission;
      final repository = termsRepository(
        onRequest: (options) {
          if (options.path.endsWith('/register')) {
            submission = Map<String, dynamic>.from(options.data as Map);
          }
        },
      );
      repository.acceptReviewedTerms(await repository.loadRegistrationTerms());
      await repository.register(
        fullName: 'Test Buyer',
        email: 'buyer@example.test',
        mobileE164: '+639171234567',
        password: 'ExamplePassword123',
        passwordConfirmation: 'ExamplePassword123',
        buyerType: 'INDIVIDUAL',
      );
      expect(submission?['terms_version_id'], termsId);
      expect(submission?['terms_content_hash'], termsHash);
      expect(submission?['terms_accepted'], anyOf(true, 'true'));
      expect(submission?['privacy_accepted'], anyOf(true, 'true'));
    },
  );
  testWidgets('unavailable legal content fails closed with retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TermsScreen(
          repository: termsRepository(unavailable: true),
          onAccepted: () {},
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });
}
