import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph/screens/buyer_profile_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  testWidgets(
    'settings requests the photo while the security summary is pending',
    (tester) async {
      RequestInterceptorHandler? security;
      RequestOptions? securityRequest;
      var photoRequested = false;
      final client = MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
      );
      final repository = AuthRepository(
        tokenStore: _Store(),
        apiClient: client,
      );
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/security')) {
              security = handler;
              securityRequest = options;
              return;
            }
            if (options.path.endsWith('/photo')) {
              photoRequested = true;
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response<dynamic>(
                    requestOptions: options,
                    statusCode: 403,
                  ),
                ),
              );
              return;
            }
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': _profileData,
                  'meta': <String, dynamic>{},
                  'errors': <dynamic>[],
                },
              ),
            );
          },
        ),
      );
      var signedOut = false;
      final profile = standardSerializers.deserializeWith(
        AccountProfile.serializer,
        _profileData,
      )!;
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerSettingsScreen(
            profile: profile,
            repository: repository,
            onSignedOut: () => signedOut = true,
          ),
        ),
      );
      for (var attempt = 0; attempt < 20 && security == null; attempt++) {
        await tester.pump(const Duration(milliseconds: 10));
      }
      expect(security, isNotNull);
      expect(
        photoRequested,
        isTrue,
        reason: 'A slow security request must not delay the photo request.',
      );
      security!.resolve(
        Response<dynamic>(
          requestOptions: securityRequest!,
          statusCode: 200,
          data: {
            'data': {
              'totp_enrolled': true,
              'recent_authentication_expires_at': null,
            },
            'meta': <String, dynamic>{},
            'errors': <dynamic>[],
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(
        signedOut,
        isFalse,
        reason: 'A signed-photo 403 stays local to the photo.',
      );
      expect(find.text('Account Setting'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}

const _profileData = <String, dynamic>{
  'id': 'buyer-fixture',
  'full_name': 'Buyer fixture',
  'email': 'b***@example.test',
  'account_type': 'BUYER',
  'account_status': 'ACTIVE',
  'lock_version': 2,
  'role': 'BUYER',
  'can_manage_staff': false,
  'permissions': <String>[],
  'avatar_url':
      'https://api.example.test/api/v1/buyers/account/photo?expires=2000000000&owner=buyer-fixture&version=2&signature=test-signature',
};

class _Store implements TokenStore {
  @override
  Future<void> clear() async {}
  @override
  Future<AuthTokens?> read() async => null;
  @override
  Future<void> write(AuthTokens tokens) async {}
}
