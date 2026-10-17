import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

const _signedPhoto =
    'https://api.example.test/api/v1/buyers/account/photo?expires=2000000000&owner=buyer-fixture&version=2&signature=test-signature';

void main() {
  test(
    'upload uses Buyer bearer auth, multipart data and returned version',
    () async {
      final client = _client((options, handler) {
        expect(options.path, '/buyers/account/photo');
        expect(options.method, 'POST');
        expect(options.sendTimeout, const Duration(seconds: 30));
        expect(options.receiveTimeout, const Duration(seconds: 45));
        expect(options.headers['Authorization'], 'Bearer fixture-access');
        final form = options.data as FormData;
        expect(Map.fromEntries(form.fields), {'lock_version': '1'});
        expect(form.files.single.key, 'photo');
        expect(form.files.single.value.filename, 'portrait.png');
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: {
              'data': _profileData(),
              'meta': <String, dynamic>{},
              'errors': [],
            },
          ),
        );
      });
      final profile = await _repository(
        client,
      ).uploadProfilePhoto(Uint8List.fromList([1, 2, 3]), 'portrait.png', 1);
      expect(profile.lockVersion, 2);
      expect(profile.avatarUrl, _signedPhoto);
    },
  );

  test(
    'invalid file type, empty data and oversized photos make no request',
    () async {
      var calls = 0;
      final repository = _repository(_client((options, handler) => calls++));
      for (final input in [
        (Uint8List.fromList([1]), 'portrait.svg'),
        (Uint8List(0), 'portrait.png'),
        (Uint8List(2 * 1024 * 1024 + 1), 'portrait.png'),
      ]) {
        await expectLater(
          repository.uploadProfilePhoto(input.$1, input.$2, 1),
          throwsA(isA<BuyerAuthException>()),
        );
      }
      expect(calls, 0);
    },
  );

  test(
    'stale profile upload surfaces the server conflict without retry',
    () async {
      var calls = 0;
      final repository = _repository(
        _client((options, handler) {
          calls++;
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response<dynamic>(
                requestOptions: options,
                statusCode: 409,
                data: {
                  'errors': [
                    {
                      'code': 'RESOURCE_VERSION_CONFLICT',
                      'message': 'Refresh before uploading.',
                    },
                  ],
                },
              ),
            ),
          );
        }),
      );
      await expectLater(
        repository.uploadProfilePhoto(
          Uint8List.fromList([1]),
          'portrait.png',
          1,
        ),
        throwsA(
          isA<BuyerAuthException>().having(
            (error) => error.message,
            'message',
            'Refresh before uploading.',
          ),
        ),
      );
      expect(calls, 1);
    },
  );

  test(
    'private photo fetch uses bearer auth and only the configured API host',
    () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final repository = _repository(
        _client((options, handler) {
          expect(options.uri.host, 'api.example.test');
          expect(options.path, '/buyers/account/photo');
          expect(options.method, 'GET');
          expect(options.responseType, ResponseType.bytes);
          expect(options.receiveTimeout, const Duration(seconds: 15));
          expect(
            options.uri.query,
            'expires=2000000000&owner=buyer-fixture&version=2&signature=test-signature',
          );
          expect(options.headers['Authorization'], 'Bearer fixture-access');
          expect(options.queryParameters, {
            'expires': 2000000000,
            'signature': 'test-signature',
            'version': 2,
            'owner': 'buyer-fixture',
          });
          handler.resolve(
            Response<Uint8List>(
              requestOptions: options,
              statusCode: 200,
              data: bytes,
            ),
          );
        }),
      );
      final profile = _profile(
        _signedPhoto.replaceFirst('api.example.test', 'untrusted.example.test'),
      );
      expect(await repository.profilePhoto(profile), bytes);
    },
  );

  test(
    'no avatar or a mismatched owner/version cannot fetch a private photo',
    () async {
      var calls = 0;
      final repository = _repository(_client((options, handler) => calls++));
      expect(await repository.profilePhoto(_profile(null)), isNull);
      for (final url in [
        _signedPhoto.replaceFirst('owner=buyer-fixture', 'owner=another-buyer'),
        _signedPhoto.replaceFirst('version=2', 'version=1'),
        'https://api.example.test/api/v1/buyers/account/photo',
      ]) {
        await expectLater(
          repository.profilePhoto(_profile(url)),
          throwsA(isA<BuyerAuthException>()),
        );
      }
      expect(calls, 0);
    },
  );

  for (final uploading in [true, false]) {
    test(
      'expired session during ${uploading ? 'upload' : 'photo read'} clears stored credentials',
      () async {
        final store = _Store();
        final repository = AuthRepository(
          tokenStore: store,
          apiClient: _client((options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response<dynamic>(
                  requestOptions: options,
                  statusCode: 401,
                ),
              ),
            );
          }),
        );
        await expectLater(
          uploading
              ? repository.uploadProfilePhoto(
                  Uint8List.fromList([1]),
                  'portrait.png',
                  1,
                )
              : repository.profilePhoto(_profile(_signedPhoto)),
          throwsA(isA<BuyerSessionExpired>()),
        );
        expect(store.cleared, isTrue);
      },
    );
  }

  test('ordinary account reads keep the original timeout', () async {
    final repository = _repository(
      _client((options, handler) {
        expect(options.path, '/buyers/account/profile');
        expect(options.receiveTimeout, const Duration(seconds: 3));
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: {
              'data': _profileData(),
              'meta': <String, dynamic>{},
              'errors': [],
            },
          ),
        );
      }),
    );
    await repository.accountOperation(
      (api) => api.getAccountProfile(accountPortal: 'buyers'),
    );
  });

  test(
    'upload timeout asks to check saved state without automatically retrying',
    () async {
      var calls = 0;
      final repository = _repository(
        _client((options, handler) {
          calls++;
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.receiveTimeout,
            ),
          );
        }),
      );
      await expectLater(
        repository.uploadProfilePhoto(
          Uint8List.fromList([1]),
          'portrait.png',
          1,
        ),
        throwsA(
          isA<BuyerAuthException>().having(
            (error) => error.message,
            'message',
            contains('check whether it finished before uploading again'),
          ),
        ),
      );
      expect(calls, 1);
    },
  );
}

Map<String, dynamic> _profileData() => {
  'id': 'buyer-fixture',
  'full_name': 'Buyer fixture',
  'email': 'b***@example.test',
  'account_type': 'BUYER',
  'account_status': 'ACTIVE',
  'lock_version': 2,
  'role': 'BUYER',
  'can_manage_staff': false,
  'permissions': <String>[],
  'avatar_url': _signedPhoto,
};

AccountProfile _profile(String? url) => standardSerializers.deserializeWith(
  AccountProfile.serializer,
  {..._profileData(), 'avatar_url': url},
)!;

MateryalphApiClient _client(
  void Function(RequestOptions, RequestInterceptorHandler) request,
) {
  final client = MateryalphApiClient(
    dio: Dio(
      BaseOptions(
        baseUrl: 'https://api.example.test/api/v1',
        receiveTimeout: const Duration(seconds: 3),
      ),
    ),
  );
  client.setBearerAuth('passportBearer', 'fixture-access');
  client.dio.interceptors.add(InterceptorsWrapper(onRequest: request));
  return client;
}

AuthRepository _repository(MateryalphApiClient client) =>
    AuthRepository(tokenStore: _Store(), apiClient: client);

class _Store implements TokenStore {
  bool cleared = false;
  @override
  Future<void> clear() async => cleared = true;
  @override
  Future<AuthTokens?> read() async => null;
  @override
  Future<void> write(AuthTokens tokens) async {}
}
