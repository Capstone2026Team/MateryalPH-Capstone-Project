import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/buyer_delete_account_screen.dart';
import 'package:materyalph/screens/buyer_two_factor_screen.dart';
import 'package:materyalph/screens/two_factor_sign_in_screen.dart';
import 'package:materyalph/widgets/buyer_account_widgets.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import 'package:qr_flutter/qr_flutter.dart';

const _secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
const _uri =
    'otpauth://totp/MateryalPH%3Abuyer%40example.test?secret=$_secret&issuer=MateryalPH&algorithm=SHA1&digits=6&period=30';

/// Routes `METHOD /path` to queued JSON responses (status, data). The last response repeats.
class _FakeApi {
  _FakeApi(this.routes);
  final Map<String, List<(int, Object?)>> routes;
  final requests = <String>[];
  final bodies = <String, Object?>{};
  final store = _MemoryStore();

  AuthRepository repository() {
    final client = MateryalphApiClient(
      dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      interceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final key = '${options.method} ${options.path}';
            requests.add(key);
            bodies[key] = options.data;
            final queue = routes[key];
            final (status, data) = queue == null || queue.isEmpty
                ? (404, null)
                : queue.length == 1
                ? queue.first
                : queue.removeAt(0);
            final body = status < 300
                ? {
                    'data': data,
                    'meta': <String, dynamic>{},
                    'errors': <dynamic>[],
                  }
                : {
                    'data': null,
                    'meta': <String, dynamic>{},
                    'errors': [
                      {'code': data, 'message': 'Server said $data'},
                    ],
                  };
            final response = Response<dynamic>(
              requestOptions: options,
              statusCode: status,
              data: body,
            );
            if (status < 300) {
              handler.resolve(response);
            } else {
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: response,
                  type: DioExceptionType.badResponse,
                ),
              );
            }
          },
        ),
      ],
    );
    return AuthRepository(tokenStore: store, apiClient: client);
  }
}

class _MemoryStore implements TokenStore {
  AuthTokens? tokens;
  @override
  Future<void> clear() async => tokens = null;
  @override
  Future<AuthTokens?> read() async => tokens;
  @override
  Future<void> write(AuthTokens value) async => tokens = value;
}

Widget _app(Widget home) => MaterialApp(theme: BuyerTheme.light, home: home);

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

/// Pumps frames for a second; an indeterminate progress bar behind a sheet never settles.
Future<void> _pumpWhileBusy(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('profile photo uses an edit badge instead of an upload button', (
    tester,
  ) async {
    var edits = 0;
    final profile = AccountProfile(
      (b) => b
        ..id = 'buyer'
        ..fullName = 'Buyer fixture'
        ..email = 'b***@example.test'
        ..accountType = 'BUYER'
        ..accountStatus = 'ACTIVE'
        ..lockVersion = 1
        ..createdAt = '2026-09-01T00:00:00Z'
        ..role = 'BUYER'
        ..canManageStaff = false,
    );
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: BuyerIdentity(
            profile: profile,
            centered: true,
            onUploadPhoto: () => edits++,
          ),
        ),
      ),
    );
    expect(find.text('Upload photo'), findsNothing);
    expect(
      find.byTooltip('Change photo · JPEG, PNG or WebP, up to 2 MB'),
      findsOneWidget,
    );
    final badge = tester.getSize(
      find
          .ancestor(
            of: find.byIcon(LucideIcons.pencil),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(badge.width, greaterThanOrEqualTo(44));
    await tester.tap(find.byIcon(LucideIcons.pencil));
    expect(edits, 1);
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: BuyerIdentity(
            profile: profile,
            centered: true,
            onUploadPhoto: () => edits++,
            uploadingPhoto: true,
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(LucideIcons.pencil));
    expect(edits, 1, reason: 'No second upload while one is running.');
    expect(find.bySemanticsLabel('Uploading profile photo'), findsOneWidget);
  });

  testWidgets(
    '2FA setup asks for identity, offers app link, QR and copyable key, then shows recovery codes',
    (tester) async {
      final clipboard = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboard.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final launched = <Uri>[];
      final api = _FakeApi({
        'GET /buyers/account/security': [
          (
            200,
            {'totp_enrolled': false, 'recent_authentication_expires_at': null},
          ),
        ],
        'POST /buyers/account/two-factor': [
          (403, 'RECENT_AUTHENTICATION_REQUIRED'),
          (
            200,
            {
              'secret': _secret,
              'provisioning_uri': _uri,
              'issuer': 'MateryalPH',
              'account_name': 'buyer@example.test',
            },
          ),
        ],
        'POST /buyers/account/reauthentication': [
          (200, {'verified': true}),
        ],
        'POST /buyers/account/two-factor/confirm': [
          (422, 'MFA_CODE_INVALID'),
          (
            200,
            {
              'recovery_codes': ['AAAA-BBBB-CCCC', 'DDDD-EEEE-FFFF'],
              'sign_in_required': false,
            },
          ),
        ],
      });
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          BuyerTwoFactorScreen(
            repository: api.repository(),
            onSignedOut: () {},
            launchAuthenticator: (uri) async {
              launched.add(uri);
              return true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Set up authenticator'));
      await _pumpWhileBusy(tester);
      expect(find.text('Confirm it’s you'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, 'Current password'),
        'CorrectPassword123',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Verify'));
      await tester.pumpAndSettle();

      expect(
        api.requests.where((r) => r == 'POST /buyers/account/two-factor'),
        hasLength(2),
      );
      expect(find.byType(QrImageView), findsOneWidget);
      expect(
        find.text('JBSW Y3DP EHPK 3PXP JBSW Y3DP EHPK 3PXP'),
        findsOneWidget,
      );
      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(clipboard, [_secret]);
      await tester.tap(find.text('Open authenticator app'));
      await tester.pump();
      expect(launched.single.toString(), _uri);

      await _scrollTo(tester, find.text('Turn on 2FA'));
      await tester.enterText(
        find.widgetWithText(TextField, 'Authenticator code'),
        '111111',
      );
      await tester.pumpAndSettle();
      expect(find.text('Server said MFA_CODE_INVALID'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, 'Authenticator code'),
        '222222',
      );
      await tester.pumpAndSettle();

      expect(find.text('Save your recovery codes'), findsOneWidget);
      expect(find.text('AAAA-BBBB-CCCC'), findsOneWidget);
      final done = find.widgetWithText(FilledButton, 'Done');
      expect(tester.widget<FilledButton>(done).onPressed, isNull);
      await tester.tap(find.text('I saved my recovery codes'));
      await tester.pump();
      await tester.tap(done);
      await tester.pumpAndSettle();
      expect(find.text('Two-factor authentication is on'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('turning 2FA off needs a code and returns to the off state', (
    tester,
  ) async {
    final api = _FakeApi({
      'GET /buyers/account/security': [
        (
          200,
          {'totp_enrolled': true, 'recent_authentication_expires_at': null},
        ),
      ],
      'POST /buyers/account/two-factor/disable': [
        (200, {'changed': true}),
      ],
    });
    await tester.pumpWidget(
      _app(
        BuyerTwoFactorScreen(repository: api.repository(), onSignedOut: () {}),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Turn off two-factor authentication'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Authenticator code'),
      '123456',
    );
    await tester.pumpAndSettle();
    expect(
      api.bodies['POST /buyers/account/two-factor/disable'],
      containsPair('code', '123456'),
    );
    expect(find.text('Add a second step to sign in'), findsOneWidget);
  });

  testWidgets('deletion is blocked while orders are open', (tester) async {
    final api = _FakeApi({
      'GET /buyers/account/deletion': [
        (
          200,
          {
            'can_delete': false,
            'blockers': {
              'active_orders': 2,
              'active_disputes': 0,
              'pending_refunds': 1,
            },
            'retained_records': [
              {'category': 'Orders, quotations and invoices', 'purpose': 'Tax'},
            ],
            'confirmation_phrase': 'DELETE',
          },
        ),
      ],
    });
    await tester.pumpWidget(
      _app(
        BuyerDeleteAccountScreen(
          repository: api.repository(),
          onSignedOut: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('2 open orders, 1 refund in progress'),
      findsOneWidget,
    );
    await _scrollTo(tester, find.text('Delete my account'));
    final field = tester.widget<TextField>(
      find.widgetWithText(TextField, 'Type DELETE to confirm'),
    );
    expect(field.enabled, isFalse);
    expect(api.requests, isNot(contains('POST /buyers/account/deletion')));
  });

  testWidgets(
    'deletion needs the phrase, confirms, re-verifies identity and signs out',
    (tester) async {
      var signedOut = false;
      final api = _FakeApi({
        'GET /buyers/account/deletion': [
          (
            200,
            {
              'can_delete': true,
              'blockers': {
                'active_orders': 0,
                'active_disputes': 0,
                'pending_refunds': 0,
              },
              'retained_records': [
                {
                  'category': 'Payments and refunds',
                  'purpose': 'Reconciliation',
                },
              ],
              'confirmation_phrase': 'DELETE',
            },
          ),
        ],
        'POST /buyers/account/deletion': [
          (403, 'RECENT_AUTHENTICATION_REQUIRED'),
          (
            200,
            {
              'reference': 'PR-2026-ABC123',
              'deleted_at': '2026-10-13T00:00:00Z',
              'sign_in_required': true,
            },
          ),
        ],
        'POST /buyers/account/reauthentication': [
          (200, {'verified': true}),
        ],
      });
      final repository = api.repository();
      await tester.binding.setSurfaceSize(const Size(390, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          BuyerDeleteAccountScreen(
            repository: repository,
            onSignedOut: () => signedOut = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Payments and refunds'), findsOneWidget);
      await _scrollTo(tester, find.text('Delete my account'));
      await tester.enterText(
        find.widgetWithText(TextField, 'Type DELETE to confirm'),
        'delete',
      );
      await tester.pump();
      await tester.tap(find.text('Delete my account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Delete your account?'),
        findsNothing,
        reason: 'Disabled until the exact phrase is typed.',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Type DELETE to confirm'),
        'DELETE',
      );
      await tester.pump();
      await tester.tap(find.text('Delete my account'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete account'));
      await _pumpWhileBusy(tester);
      await tester.enterText(
        find.widgetWithText(TextField, 'Current password'),
        'CorrectPassword123',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Verify'));
      await tester.pumpAndSettle();
      expect(find.textContaining('PR-2026-ABC123'), findsOneWidget);
      expect(
        api.bodies['POST /buyers/account/deletion'],
        containsPair('confirmation', 'DELETE'),
      );
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(signedOut, isTrue);
    },
  );

  test(
    'password sign-in with 2FA returns a challenge and the code saves the session',
    () async {
      final api = _FakeApi({
        'POST /mobile/auth/login': [
          (
            200,
            {
              'mfa_required': true,
              'mfa_enrollment_required': false,
              'challenge_expires_in': 300,
              'challenge_token': 'challenge-1',
            },
          ),
        ],
        'POST /mobile/auth/mfa/challenge': [
          (
            200,
            {
              'access_token': 'access',
              'refresh_token': 'refresh',
              'session_id': 's',
            },
          ),
        ],
      });
      final repository = api.repository();
      late BuyerTwoFactorRequired challenge;
      try {
        await repository.login(email: 'buyer@example.test', password: 'secret');
        fail('Expected a two-factor challenge.');
      } on BuyerTwoFactorRequired catch (error) {
        challenge = error;
      }
      expect(challenge.challengeToken, 'challenge-1');
      expect(
        api.store.tokens,
        isNull,
        reason: 'No session before the second factor.',
      );
      await repository.completeTwoFactorSignIn(challenge, '123456');
      expect(api.bodies['POST /mobile/auth/mfa/challenge'], {
        'challenge_token': 'challenge-1',
        'code': '123456',
      });
      expect(api.store.tokens?.accessToken, 'access');
    },
  );

  testWidgets(
    'recovery-code sign-in shows the replacement codes before continuing',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeApi({
        'POST /mobile/auth/mfa/recovery': [
          (
            200,
            {
              'access_token': 'access',
              'refresh_token': 'refresh',
              'recovery_codes': ['NEW1-NEW1-NEW1'],
            },
          ),
        ],
      });
      bool? result;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await completeTwoFactorSignIn(
                context,
                api.repository(),
                const BuyerTwoFactorRequired('challenge-1', 300),
              ),
              child: const Text('start'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('start'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lost your phone? Use a recovery code'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Recovery code'),
        'abcd-efgh-ijkl',
      );
      await tester.tap(find.text('Verify and sign in'));
      await tester.pumpAndSettle();
      expect(find.text('NEW1-NEW1-NEW1'), findsOneWidget);
      await tester.tap(find.text('I saved my new recovery codes'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
      expect(api.store.tokens?.accessToken, 'access');
    },
  );
}
