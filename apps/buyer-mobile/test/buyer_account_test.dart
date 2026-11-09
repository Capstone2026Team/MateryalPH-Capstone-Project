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
            repository: repository(masked: true),
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

  testWidgets(
    'profile save waits for a change and full email links to Security',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerAccountScreen(
            repository: repository(),
            onSignedOut: () {},
          ),
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
      expect(find.widgetWithText(TextButton, 'Change'), findsNWidgets(2));
      expect(
        find.text('buyer.with.a.long.email.address@example.test'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Account created Sep 1, 2026'),
        findsOneWidget,
      );
    },
  );

  testWidgets('an unmasked email offers a change action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerAccountScreen(repository: repository(), onSignedOut: () {}),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('buyer.with.a.long.email.address@example.test'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Change').first);
    await tester.pumpAndSettle();
    expect(find.text('Verify your identity'), findsOneWidget);
  });

  testWidgets(
    'phone change saves the normalized contact and preserves a name draft',
    (tester) async {
      final updates = <Map<String, dynamic>>[];
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerAccountScreen(
            repository: repository(onProfileUpdate: updates.add),
            onSignedOut: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Full name'),
        'Unsaved name',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('edit-buyer-phone')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('edit-buyer-phone')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        '9171234567',
      );
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Save phone number'),
            )
            .onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextFormField), '0918 765 4321');
      await tester.pump();
      await tester.ensureVisible(find.text('Save phone number'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save phone number'));
      await tester.pumpAndSettle();
      expect(updates.single, {
        'full_name': 'Buyer fixture',
        'lock_version': 1,
        'mobile_e164': '+639187654321',
      });
      expect(find.text('+639187654321'), findsOneWidget);
      expect(find.text('Phone number saved.'), findsOneWidget);
      expect(find.text('Unsaved name'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);

      await tester.ensureVisible(
        find.byKey(const ValueKey('edit-buyer-phone')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('edit-buyer-phone')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '9170000000');
      await tester.ensureVisible(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(updates, hasLength(1));
      expect(find.text('+639187654321'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'adding a phone validates input and retains it after a failed save for explicit retry',
    (tester) async {
      final updates = <Map<String, dynamic>>[];
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerAccountScreen(
            repository: repository(
              phone: null,
              onProfileUpdate: updates.add,
              profileUpdateFailures: 1,
            ),
            onSignedOut: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('edit-buyer-phone')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('edit-buyer-phone')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '123');
      await tester.pump();
      await tester.ensureVisible(find.text('Save phone number'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save phone number'));
      await tester.pumpAndSettle();
      expect(
        find.text('Enter a valid mobile number for the selected country code.'),
        findsOneWidget,
      );
      expect(updates, isEmpty);
      await tester.enterText(find.byType(TextFormField), '0917 000 0001');
      await tester.pump();
      await tester.ensureVisible(find.text('Save phone number'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save phone number'));
      await tester.pumpAndSettle();
      expect(updates, hasLength(1));
      expect(find.text('Phone number saved.'), findsNothing);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        '09170000001',
      );
      await tester.tap(find.text('Save phone number'));
      await tester.pumpAndSettle();
      expect(updates, hasLength(2));
      expect(updates.last['mobile_e164'], '+639170000001');
      expect(updates.last['lock_version'], 1);
      expect(find.text('+639170000001'), findsOneWidget);
      expect(find.text('Phone number saved.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

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
  bool masked = false,
  bool verified = true,
  bool emailVerified = true,
  String? phone = "+639171234567",
  String name = "Buyer fixture",
  void Function(Map<String, dynamic>)? onProfileUpdate,
  int profileUpdateFailures = 0,
}) {
  var lockVersion = 1;
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
          if (options.path.endsWith('/profile') && options.method == 'PATCH') {
            final input = Map<String, dynamic>.from(options.data as Map);
            onProfileUpdate?.call(input);
            if (profileUpdateFailures > 0) {
              profileUpdateFailures--;
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response<dynamic>(
                    requestOptions: options,
                    statusCode: 503,
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
              return;
            }
            phone = input['mobile_e164'] as String? ?? phone;
            name = input['full_name'] as String;
            lockVersion++;
          }
          final receivedRatings = options.path.endsWith('/buyers/ratings');
          final dynamic data = receivedRatings
              ? <dynamic>[]
              : options.path.endsWith('/profile')
              ? <String, dynamic>{
                  'id': 'buyer-fixture',
                  'full_name': name,
                  'email': masked || !verified
                      ? 'b***@example.test'
                      : 'buyer.with.a.long.email.address@example.test',
                  'email_masked': masked || !verified,
                  'email_verified': emailVerified,
                  'mobile_e164': phone,
                  'account_type': 'BUYER',
                  'account_status': 'ACTIVE',
                  'lock_version': lockVersion,
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
                'meta': receivedRatings
                    ? <String, dynamic>{
                        'page': 1,
                        'per_page': 20,
                        'total': 0,
                        'summary': <String, dynamic>{
                          'score': null,
                          'count': 0,
                          'minimum_count': 5,
                          'window_days': 90,
                          'inquiry_seriousness': null,
                          'communication_quality': null,
                          'payment_reliability': null,
                        },
                      }
                    : <String, dynamic>{},
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
