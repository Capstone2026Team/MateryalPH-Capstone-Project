import 'dart:async';
import 'package:materyalph/core/api_guard.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  test(
    'sign-out during a refreshed-token write cannot restore the old session',
    () async {
      final store = MemoryTokens();
      final adapter = SessionAdapter();
      final client = MateryalphApiClient(
        basePathOverride: 'https://api.example.test',
      );
      client.dio.httpClientAdapter = adapter;
      final auth = AuthRepository(tokenStore: store, apiClient: client);
      await auth.restoreSession();
      store.writeStarted = Completer<void>();
      store.releaseWrite = Completer<void>();
      adapter.expired = true;
      final request = expectLater(
        client.dio.get<Object>('/buyers/test', options: protectedOptions()),
        throwsA(isA<DioException>()),
      );
      await store.writeStarted!.future;
      final signedOut = auth.clearAccountSession();
      store.releaseWrite!.complete();
      await Future.wait([request, signedOut]);
      expect(store.tokens, isNull);
      expect(auth.sessionOffline, isFalse);
      expect(adapter.refreshes, 1);
    },
  );
  test(
    'a resource 401 after successful refresh does not end the session',
    () async {
      final store = MemoryTokens();
      final adapter = SessionAdapter();
      final client = MateryalphApiClient(
        basePathOverride: 'https://api.example.test',
      );
      client.dio.httpClientAdapter = adapter;
      final auth = AuthRepository(tokenStore: store, apiClient: client);
      await auth.restoreSession();
      adapter
        ..expired = true
        ..rejectResource = true;
      var ended = 0;
      final guard = ApiGuard(() async {
        ended++;
      });
      await expectLater(
        guard.call(
          () => client.dio.get<Object>(
            '/buyers/test',
            options: protectedOptions(),
          ),
        ),
        throwsA(
          isA<DiscoveryFailure>().having(
            (f) => f.kind,
            'kind',
            DiscoveryFailureKind.forbidden,
          ),
        ),
      );
      expect(adapter.refreshes, 1);
      expect(store.tokens, isNotNull);
      expect(ended, 0);
    },
  );
  test(
    'concurrent expired access requests share one refresh and keep the session',
    () async {
      final store = MemoryTokens();
      final adapter = SessionAdapter();
      final client = MateryalphApiClient(
        basePathOverride: 'https://api.example.test',
      );
      client.dio.httpClientAdapter = adapter;
      final auth = AuthRepository(tokenStore: store, apiClient: client);
      expect(await auth.restoreSession(), isTrue);
      adapter.expired = true;
      final responses = await Future.wait(
        List.generate(
          5,
          (_) => client.dio.get<Object>(
            '/buyers/test',
            options: protectedOptions(),
          ),
        ),
      );
      expect(responses.every((r) => r.statusCode == 200), isTrue);
      expect(adapter.refreshes, 1);
      expect(store.tokens?.accessToken, 'replacement-access');
      expect(store.clears, 0);
    },
  );

  test(
    'offline cold start preserves encrypted tokens until revalidation succeeds',
    () async {
      final store = MemoryTokens();
      final adapter = SessionAdapter()..offline = true;
      final client = MateryalphApiClient(
        basePathOverride: 'https://api.example.test',
      );
      client.dio.httpClientAdapter = adapter;
      final auth = AuthRepository(tokenStore: store, apiClient: client);
      expect(await auth.restoreSession(), isTrue);
      expect(auth.sessionOffline, isTrue);
      expect(store.clears, 0);
      adapter.offline = false;
      expect(await auth.revalidateSession(), isTrue);
      expect(auth.sessionOffline, isFalse);
    },
  );

  test(
    'a provider failure during refresh preserves the session and is not exposed as 401',
    () async {
      final store = MemoryTokens();
      final adapter = SessionAdapter();
      final client = MateryalphApiClient(
        basePathOverride: 'https://api.example.test',
      );
      client.dio.httpClientAdapter = adapter;
      final auth = AuthRepository(tokenStore: store, apiClient: client);
      await auth.restoreSession();
      adapter
        ..expired = true
        ..refreshStatus = 503;
      await expectLater(
        client.dio.get<Object>('/buyers/test', options: protectedOptions()),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            503,
          ),
        ),
      );
      expect(store.tokens, isNotNull);
      expect(store.clears, 0);
    },
  );

  test('a rejected refresh expires the stored session', () async {
    final store = MemoryTokens();
    final adapter = SessionAdapter();
    final client = MateryalphApiClient(
      basePathOverride: 'https://api.example.test',
    );
    client.dio.httpClientAdapter = adapter;
    final auth = AuthRepository(tokenStore: store, apiClient: client);
    await auth.restoreSession();
    adapter
      ..expired = true
      ..refreshStatus = 401;
    await expectLater(
      client.dio.get<Object>('/buyers/test', options: protectedOptions()),
      throwsA(isA<DioException>()),
    );
    expect(store.tokens, isNull);
  });

  test('a secure-storage failure exits restoration without throwing', () async {
    final store = MemoryTokens()..failRead = true;
    expect(await AuthRepository(tokenStore: store).restoreSession(), isFalse);
    expect(store.clears, 1);
  });
}

Options protectedOptions() => Options(
  extra: {
    'secure': [
      {'type': 'http', 'scheme': 'bearer', 'name': 'passportBearer'},
    ],
  },
);

final class MemoryTokens implements TokenStore {
  AuthTokens? tokens = const AuthTokens(
    accessToken: 'initial-access',
    refreshToken: 'initial-refresh',
  );
  bool failRead = false;
  int clears = 0;
  Completer<void>? writeStarted;
  Completer<void>? releaseWrite;
  @override
  Future<AuthTokens?> read() async {
    if (failRead) throw StateError('Unavailable storage');
    return tokens;
  }

  @override
  Future<void> write(AuthTokens value) async {
    writeStarted?.complete();
    await releaseWrite?.future;
    tokens = value;
  }

  @override
  Future<void> clear() async {
    clears++;
    tokens = null;
  }
}

final class SessionAdapter implements HttpClientAdapter {
  bool expired = false;
  bool rejectResource = false;
  bool offline = false;
  int refreshes = 0;
  int refreshStatus = 200;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (offline) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }
    if (options.path == '/mobile/auth/refresh') {
      refreshes++;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      if (refreshStatus == 200) {
        return body(200, {
          'data': {
            'access_token': 'replacement-access',
            'refresh_token': 'replacement-refresh',
          },
          'meta': {},
          'errors': [],
        });
      }
      return body(refreshStatus, {'data': null, 'meta': {}, 'errors': []});
    }
    if (rejectResource ||
        (expired &&
            options.headers['Authorization'] != 'Bearer replacement-access')) {
      return body(401, {'data': null, 'meta': {}, 'errors': []});
    }
    return body(200, {
      'data': {'id': 'fixture-buyer', 'account_type': 'BUYER'},
      'meta': {},
      'errors': [],
    });
  }

  ResponseBody body(int status, Object data) => ResponseBody.fromString(
    jsonEncode(data),
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
  @override
  void close({bool force = false}) {}
}
