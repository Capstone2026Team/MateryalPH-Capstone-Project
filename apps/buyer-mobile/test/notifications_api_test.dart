import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  test(
    'a late unauthorized response cannot expire a replaced notification session',
    () async {
      final requested = Completer<void>(), release = Completer<void>();
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            requested.complete();
            await release.future;
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<Object?>(
                  requestOptions: options,
                  statusCode: 401,
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );
      var expired = false;
      final repository = NotificationsRepository(
        MateryalphApiClient(dio: dio),
        () async {
          expired = true;
        },
      );
      final response = repository.list();
      final check = expectLater(response, throwsA(isA<DiscoveryFailure>()));
      await requested.future;
      repository.inbox.setActive(false, clear: true);
      release.complete();
      await check;
      expect(expired, isFalse);
      repository.inbox.dispose();
      dio.close(force: true);
    },
  );

  test(
    'session expiry uses the mounted private-store cleanup and detaches safely',
    () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<Object?>(
                  requestOptions: options,
                  statusCode: 401,
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );
      var fallbackCalls = 0, shellCalls = 0;
      final repository = NotificationsRepository(
        MateryalphApiClient(dio: dio),
        () async {
          fallbackCalls++;
        },
      );
      final detach = repository.attachSessionExpiry(() async {
        shellCalls++;
      });
      await expectLater(repository.list(), throwsA(isA<DiscoveryFailure>()));
      expect(shellCalls, 1);
      expect(fallbackCalls, 0);
      detach();
      await expectLater(repository.list(), throwsA(isA<DiscoveryFailure>()));
      expect(fallbackCalls, 1);
      dio.close(force: true);
    },
  );

  test(
    'bulk read sends a captured category cutoff and decodes authoritative read time',
    () async {
      final client = MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              expect(options.path, '/buyers/notifications/read-all');
              expect(options.data, {
                'through_id': 'captured-notice',
                'category': 'ORDERS',
              });
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': {
                      'read': true,
                      'read_count': 2,
                      'read_at': '2026-10-09T01:00:00Z',
                    },
                    'meta': <String, Object?>{},
                    'errors': <Object?>[],
                  },
                ),
              );
            },
          ),
        ],
      );
      final repository = NotificationsRepository(
        client,
        () async => fail('Session must remain active'),
      );
      final result = await repository.readAll('captured-notice', 'ORDERS');
      expect(result.readCount, 2);
      expect(result.readAt, '2026-10-09T01:00:00Z');
    },
  );

  test(
    'export download decodes bytes and explains revoked or expired access',
    () async {
      var status = 200;
      final client = MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              expect(options.responseType, ResponseType.bytes);
              final response = Response<Object>(
                requestOptions: options,
                statusCode: status,
                data: status == 200
                    ? Uint8List.fromList([37, 80, 68, 70])
                    : Uint8List.fromList(
                        utf8.encode(
                          jsonEncode({
                            'data': null,
                            'meta': {},
                            'errors': [
                              {
                                'code': status == 403
                                    ? 'EXPORT_ACCESS_REVOKED'
                                    : 'EXPORT_EXPIRED',
                                'message': status == 403
                                    ? 'You no longer have access to this export.'
                                    : 'This export has expired.',
                              },
                            ],
                          }),
                        ),
                      ),
              );
              if (status == 200) {
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
      final repository = NotificationsRepository(
        client,
        () async => fail('Permission denial must not expire the session'),
      );
      expect(await repository.download('export-one'), [37, 80, 68, 70]);
      status = 403;
      await expectLater(
        repository.download('export-one'),
        throwsA(
          isA<DiscoveryFailure>().having(
            (e) => e.message,
            'message',
            'You no longer have access to this export.',
          ),
        ),
      );
      status = 410;
      await expectLater(
        repository.download('export-one'),
        throwsA(
          isA<DiscoveryFailure>().having(
            (e) => e.code,
            'code',
            'EXPORT_EXPIRED',
          ),
        ),
      );
    },
  );
  test(
    'notification and export transport decodes optional fields and sends authorization request',
    () async {
      final paths = <String>[];
      final client = MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              paths.add(options.path);
              final Object data;
              if (options.path.endsWith('/resolve')) {
                data = {'path': '/orders/order-one'};
              } else if (options.path.endsWith('/read')) {
                data = {'read': true};
              } else if (options.path.endsWith('/reports')) {
                data = [
                  {
                    'id': 'export-one',
                    'type': 'PURCHASE_ORDER',
                    'format': 'PDF',
                    'state': 'QUEUED',
                    'purpose': 'Procurement review',
                    'filters': <String, Object?>{},
                    'source_hash': 'source-hash',
                    'source_versions': {'version': 1},
                    'checksum': null,
                    'created_at': '2026-10-05T00:00:00Z',
                    'expires_at': null,
                    'failure_code': null,
                    'access_record': <Object?>[],
                  },
                ];
              } else {
                data = [
                  {
                    'id': 'notice-one',
                    'category': 'SECURITY',
                    'title': 'Account update',
                    'body': 'Review your account.',
                    'mandatory': true,
                    'read_at': null,
                    'created_at': '2026-10-05T00:00:00Z',
                  },
                ];
              }
              handler.resolve(
                Response<Object?>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': data,
                    'meta': <String, Object?>{},
                    'errors': <Object?>[],
                  },
                ),
              );
            },
          ),
        ],
      );
      final repository = NotificationsRepository(
        client,
        () async => fail('Session must remain active'),
      );
      expect((await repository.list()).data.single.mandatory, isTrue);
      expect(await repository.resolve('notice-one'), '/orders/order-one');
      expect(paths, contains('/buyers/notifications/notice-one/resolve'));
      expect((await repository.reports()).data.single.checksum, isNull);
    },
  );
  test('PDF popup history is scoped before pagination', () async {
    final client = MateryalphApiClient(
      dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
      interceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, '/buyers/reports');
            expect(
              options.queryParameters,
              containsPair('resource_id', 'source-order'),
            );
            expect(
              options.queryParameters,
              containsPair('type', 'PURCHASE_ORDER'),
            );
            expect(options.queryParameters, containsPair('format', 'PDF'));
            expect(options.queryParameters, containsPair('page', 2));
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': <Object?>[],
                  'meta': {'has_more': false},
                  'errors': <Object?>[],
                },
              ),
            );
          },
        ),
      ],
    );
    final repository = NotificationsRepository(
      client,
      () async => fail('Session must remain active'),
    );
    final result = await repository.reports(
      page: 2,
      type: 'PURCHASE_ORDER',
      resourceId: 'source-order',
      format: 'PDF',
    );
    expect(result.data, isEmpty);
  });
}
