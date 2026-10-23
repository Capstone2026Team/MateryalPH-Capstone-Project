import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/buyer_transport.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/procurement_repository.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

void main() {
  test(
    'catalog receives a delayed server response without a false offline failure',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      final client = api.MateryalphApiClient(
        basePathOverride: 'http://127.0.0.1:${server.port}/api/v1',
      );
      addTearDown(() => client.dio.close(force: true));
      client.setBearerAuth('passportBearer', 'fixture-access');
      final bodies = <Map<String, Object?>>[];
      final headers = <String?>[];
      server.listen((request) async {
        expect(request.uri.path, '/api/v1/buyers/listings/search');
        bodies.add(
          Map<String, Object?>.from(
            jsonDecode(await utf8.decoder.bind(request).join()) as Map,
          ),
        );
        headers.add(request.headers.value('Authorization'));
        await Future<void>.delayed(const Duration(milliseconds: 3300));
        request.response.statusCode = 503;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'data': null,
            'meta': <String, Object?>{},
            'errors': [
              {'code': 'CATALOG_RETRY', 'message': 'Please retry the catalog.'},
            ],
          }),
        );
        await request.response.close();
      });
      var expired = false;
      final repository = ApiProcurementRepository(
        client: client,
        onSessionExpired: () async => expired = true,
      );
      await expectLater(
        repository.search(
          origin: const DiscoveryOrigin.point(
            point: GeoPoint(14.6, 121),
            label: 'Project site',
            source: OriginSource.mapPin,
          ),
          radiusKm: 50,
          query: '',
          filters: const ListingFilters(),
        ),
        throwsA(
          isA<DiscoveryFailure>()
              .having((e) => e.kind, 'kind', DiscoveryFailureKind.provider)
              .having((e) => e.code, 'code', 'CATALOG_RETRY'),
        ),
      );
      expect(headers, ['Bearer fixture-access']);
      expect(bodies.single['radius_km'], 50);
      expect(expired, isFalse);
    },
  );

  test(
    'shared budgets cover other Buyer calls and preserve longer configured limits and upload budgets',
    () async {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.example.test',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
      addTearDown(() => dio.close(force: true));
      configureBuyerTransport(dio);
      configureBuyerTransport(dio);
      expect(dio.options.connectTimeout, const Duration(seconds: 30));
      expect(dio.options.sendTimeout, const Duration(seconds: 30));
      expect(dio.options.receiveTimeout, const Duration(seconds: 60));
      final requests = <RequestOptions>[];
      dio.interceptors.add(
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
        '/buyers/cart',
        '/buyers/orders',
        '/buyers/notifications',
      ]) {
        await dio.get<void>(path);
      }
      expect(
        requests.map((r) => r.receiveTimeout),
        everyElement(const Duration(seconds: 60)),
      );
      await dio.post<void>(
        '/buyers/uploads',
        data: FormData.fromMap({
          'files': List.generate(
            3,
            (_) => MultipartFile.fromBytes([1], filename: 'fixture.bin'),
          ),
        }),
      );
      expect(requests.last.receiveTimeout, const Duration(seconds: 270));
      expect(requests.last.sendTimeout, const Duration(seconds: 90));
      dio.options.receiveTimeout = const Duration(seconds: 120);
      configureBuyerTransport(dio);
      expect(dio.options.receiveTimeout, const Duration(seconds: 120));
    },
  );
}
