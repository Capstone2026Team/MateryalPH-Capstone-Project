import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph/screens/buyer_account_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  for (final size in [const Size(320, 568), const Size(844, 390)]) {
    testWidgets('account settings reflow at $size and large text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(() {
        tester.platformDispatcher.clearTextScaleFactorTestValue();
        return tester.binding.setSurfaceSize(null);
      });
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerAccountScreen(
            repository: repository(),
            onSignedOut: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ChoiceChip), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Verify your identity to view your full email address.'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('b***@example.test'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerAccountScreen(
            key: const ValueKey('security'),
            repository: repository(),
            onSignedOut: () {},
            initialSection: 'Security',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ChoiceChip), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Send email verification instead'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Send email verification instead'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('profile save waits for a change and email links to Security', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerAccountScreen(repository: repository(), onSignedOut: () {}),
      ),
    );
    await tester.pumpAndSettle();
    FilledButton save() =>
        tester.widget(find.widgetWithText(FilledButton, 'Save changes'));
    expect(save().onPressed, isNull);
    await tester.enterText(
      find.widgetWithText(TextField, 'Full name'),
      'Buyer renamed',
    );
    await tester.pump();
    expect(save().onPressed, isNotNull);
    await tester.enterText(find.widgetWithText(TextField, 'Full name'), ' ');
    await tester.pump();
    expect(save().onPressed, isNull);
    expect(find.text('Contact details'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Verify identity'), findsOneWidget);
    expect(find.textContaining('Account created Sep 1, 2026'), findsOneWidget);
  });

  testWidgets('an unmasked email offers a change action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerAccountScreen(
          repository: repository(verified: true),
          onSignedOut: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('buyer.with.a.long.email.address@example.test'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Change'));
    await tester.pumpAndSettle();
    expect(find.text('Verify your identity'), findsOneWidget);
  });

  testWidgets('security switches verification method and shows the window', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerAccountScreen(
          repository: repository(),
          onSignedOut: () {},
          initialSection: 'Security',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(TextField, 'Email verification code'),
      findsNothing,
    );
    await tester.tap(find.text('Send email verification instead'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(TextField, 'Email verification code'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(FilledButton, 'Verify email code'),
      findsOneWidget,
    );
    await tester.tap(find.text('Use password instead'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Current password'), findsOneWidget);
    await tester.tap(find.byTooltip('Show password').first);
    await tester.pump();
    expect(find.byTooltip('Hide password'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Current password'),
      'correct horse battery',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Verify identity'));
    await tester.pumpAndSettle();
    expect(find.text('Identity verified'), findsOneWidget);
    expect(find.textContaining('until'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Current password'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expired account access returns to sign-in', (tester) async {
    var signedOut = false;
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerAccountScreen(
          repository: repository(expired: true),
          onSignedOut: () => signedOut = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(signedOut, isTrue);
    expect(find.text('Email: b***@example.test'), findsNothing);
  });
}

AuthRepository repository({
  bool expired = false,
  bool verified = false,
  String? phone = "+639171234567",
  String name = "Buyer fixture",
}) {
  final client = MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (expired) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<dynamic>(
                  requestOptions: options,
                  statusCode: 401,
                ),
                type: DioExceptionType.badResponse,
              ),
            );
            return;
          }
          final dynamic data = options.path.endsWith('/profile')
              ? <String, dynamic>{
                  'id': 'buyer-fixture',
                  'full_name': name,
                  'email': verified
                      ? 'buyer.with.a.long.email.address@example.test'
                      : 'b***@example.test',
                  'email_masked': !verified,
                  'mobile_e164': phone,
                  'account_type': 'BUYER',
                  'account_status': 'ACTIVE',
                  'lock_version': 1,
                  'created_at': '2026-09-01T00:00:00Z',
                  'buyer_type': 'INDIVIDUAL',
                  'company_name': null,
                  'organization_name': null,
                  'role': 'BUYER',
                  'organization_id': null,
                  'membership_id': null,
                  'can_manage_staff': false,
                  'permissions': <String>[],
                }
              : options.path.endsWith('/sessions')
              ? <dynamic>[
                  {
                    'id': 'session-fixture',
                    'description': 'Buyer mobile app',
                    'current': true,
                    'created_at': '2026-09-20T00:00:00Z',
                    'last_active_at': '2026-09-20T00:01:00Z',
                  },
                ]
              : options.path.endsWith('/agreements')
              ? <dynamic>[
                  {
                    'id': 'terms-fixture',
                    'code': 'TERMS_OF_SERVICE',
                    'title': 'Terms of Service',
                    'version': 2,
                    'content':
                        '# Terms of Service\n\n## Account security\n\nMaintained test agreement content.',
                    'content_available': true,
                    'accepted_at': '2026-09-20T00:00:00Z',
                    'requires_acceptance': false,
                  },
                ]
              : <String, dynamic>{'queued': true};
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: <String, dynamic>{
                'data': data,
                'meta': <String, dynamic>{},
                'errors': <dynamic>[],
              },
            ),
          );
        },
      ),
    ],
  );
  return AuthRepository(tokenStore: _Store(), apiClient: client);
}

class _Store implements TokenStore {
  @override
  Future<void> clear() async {}
  @override
  Future<AuthTokens?> read() async => null;
  @override
  Future<void> write(AuthTokens tokens) async {}
}
