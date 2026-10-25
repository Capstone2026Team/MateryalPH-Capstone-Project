import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/api_guard.dart';
import 'package:materyalph/core/file_upload_transport.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

const _packageId = '01995000-0000-7000-8000-000000000001';
const _emptyPage = {
  'estimate': null,
  'items': <Object?>[],
  'page': 1,
  'has_more': false,
  'total': 0,
  'unfiltered_total': 0,
};

void main() {
  test('a hosted scan can respond after the old three-second limit', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final client = api.MateryalphApiClient(
      basePathOverride: 'http://127.0.0.1:${server.port}/api/v1',
    );
    addTearDown(() => client.dio.close(force: true));
    client.setBearerAuth('passportBearer', 'fixture-access');
    final requests = <String>[];
    final bodies = <Object?>[];
    final authorizations = <String?>[];
    server.listen((request) async {
      requests.add(request.uri.path);
      authorizations.add(request.headers.value('Authorization'));
      final body = await utf8.decoder.bind(request).join();
      bodies.add(body.isEmpty ? null : jsonDecode(body));
      await Future<void>.delayed(const Duration(milliseconds: 3300));
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode({
          'data': _emptyPage,
          'meta': <String, Object?>{},
          'errors': <Object?>[],
        }),
      );
      await request.response.close();
    });
    var expired = false;
    final repository = ProjectsRepository(
      client: client,
      onSessionExpired: () async => expired = true,
    );

    expect((await repository.compile(_packageId, 3)).items, isEmpty);
    expect((await repository.arrangementOptions(_packageId)).items, isEmpty);
    expect(requests, [
      '/api/v1/buyers/work-packages/$_packageId/estimates',
      '/api/v1/buyers/work-packages/$_packageId/arrangement-options',
    ]);
    expect(bodies.first, {'lock_version': 3});
    expect(authorizations, everyElement('Bearer fixture-access'));
    expect(expired, isFalse);
  });

  test(
    'both repository entry points use the shared hosted API policy once',
    () async {
      final client = api.MateryalphApiClient(
        basePathOverride: 'https://api.example.test/api/v1',
      );
      addTearDown(() => client.dio.close(force: true));
      final initialInterceptors = client.dio.interceptors.length;
      ProjectsRepository.withGuard(
        client: client,
        guard: ApiGuard(() async {}),
      );
      ProjectsRepository(client: client, onSessionExpired: () async {});
      expect(client.dio.interceptors.length, initialInterceptors + 1);
      configureFileUploads(client.dio);
      final requests = <RequestOptions>[];
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.resolve(
              Response<void>(requestOptions: options, statusCode: 204),
            );
          },
        ),
      );
      for (final path in [
        '/buyers/projects',
        '/buyers/projects/project-id/work-package-estimate',
        '/buyers/work-packages/$_packageId',
        '/buyers/work-packages/$_packageId/estimates',
        '/buyers/work-packages/$_packageId/arrangement-options',
        '/buyers/work-packages/$_packageId/candidates/candidate-id/route',
      ]) {
        await client.dio.get<void>(path);
      }
      expect(
        requests.map((r) => r.connectTimeout),
        everyElement(const Duration(seconds: 30)),
      );
      expect(
        requests.map((r) => r.receiveTimeout),
        everyElement(const Duration(seconds: 60)),
      );

      await client.dio.get<void>('/buyers/orders');
      expect(requests.last.receiveTimeout, const Duration(seconds: 60));
      expect(requests.last.connectTimeout, const Duration(seconds: 30));

      await client.dio.post<void>(
        '/buyers/work-packages/import-preview',
        data: FormData.fromMap({
          'files': [
            MultipartFile.fromBytes([1], filename: 'fixture.csv'),
          ],
        }),
      );
      expect(requests.last.receiveTimeout, const Duration(seconds: 90));
      expect(requests.last.sendTimeout, const Duration(seconds: 90));
    },
  );
}
