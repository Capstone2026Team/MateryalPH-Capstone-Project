import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/api_guard.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

void main() {
  for (final type in [
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
  ]) {
    test(
      '$type explains the timeout and preserves safe mutation retries',
      () async {
        var expired = false;
        final guard = ApiGuard(() async => expired = true);
        await expectLater(
          guard.call<void>(() async {
            throw DioException(requestOptions: RequestOptions(), type: type);
          }),
          throwsA(
            isA<DiscoveryFailure>()
                .having((e) => e.code, 'code', 'REQUEST_TIMEOUT')
                .having((e) => e.message, 'message', contains('timed out'))
                .having((e) => e.message, 'message', isNot(contains('offline')))
                .having((e) => e.kind, 'kind', DiscoveryFailureKind.timeout)
                .having(
                  (e) => e.isTransportFailure,
                  'retain retry key',
                  isTrue,
                ),
          ),
        );
        expect(expired, isFalse);
      },
    );
  }

  test('an unreachable connection still offers the offline retry', () async {
    await expectLater(
      ApiGuard(() async {}).call<void>(() async {
        throw DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        );
      }),
      throwsA(
        isA<DiscoveryFailure>()
            .having((e) => e.kind, 'kind', DiscoveryFailureKind.offline)
            .having((e) => e.message, 'message', contains('offline')),
      ),
    );
  });

  test(
    'an unexpected payload is sanitized without claiming to be offline',
    () async {
      await expectLater(
        ApiGuard(() async {}).call<void>(() async {
          throw const FormatException('private payload');
        }),
        throwsA(
          isA<DiscoveryFailure>()
              .having((e) => e.kind, 'kind', DiscoveryFailureKind.unknown)
              .having(
                (e) => e.message,
                'message',
                contains('unexpected response'),
              )
              .having((e) => e.message, 'message', isNot(contains('private'))),
        ),
      );
    },
  );

  for (final status in [401, 500]) {
    test(
      'malformed HTTP $status errors preserve safe session handling',
      () async {
        var expired = false;
        final guard = ApiGuard(() async => expired = true);
        final options = RequestOptions(path: '/buyers/orders');
        await expectLater(
          guard.call<void>(() async {
            throw DioException(
              requestOptions: options,
              response: Response<Object?>(
                requestOptions: options,
                statusCode: status,
                data: {
                  'errors': [
                    {
                      'code': 123,
                      'message': ['private malformed payload'],
                    },
                  ],
                },
              ),
            );
          }),
          throwsA(
            isA<DiscoveryFailure>()
                .having(
                  (error) => error.kind,
                  'kind',
                  status == 401
                      ? DiscoveryFailureKind.sessionExpired
                      : DiscoveryFailureKind.provider,
                )
                .having(
                  (error) => error.message,
                  'safe message',
                  isNot(contains('private')),
                ),
          ),
        );
        expect(expired, status == 401);
      },
    );
  }
}
