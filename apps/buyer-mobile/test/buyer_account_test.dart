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
      await tester.scrollUntilVisible(
        find.text('Email: b***@example.test'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Email: b***@example.test'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, 2000));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Security'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Send email verification instead'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Send email verification instead'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

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

AuthRepository repository({bool expired = false}) {
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
          final data = options.path.endsWith('/profile')
              ? <String, dynamic>{
                  'id': 'buyer-fixture',
                  'full_name': 'Buyer fixture',
                  'email': 'b***@example.test',
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
