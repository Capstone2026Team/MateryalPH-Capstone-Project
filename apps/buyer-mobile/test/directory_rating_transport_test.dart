import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/discovery_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

class _DiscoveryAdapter implements HttpClientAdapter {
  final bodies = <Map<String, dynamic>>[];
  List<Map<String, Object?>> items = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancelFuture,
  ) async {
    final bytes = await body!.fold<List<int>>(
      [],
      (bytes, chunk) => bytes..addAll(chunk),
    );
    bodies.add(jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>);
    expect(options.path, '/buyers/discovery/search');
    return ResponseBody.fromString(
      jsonEncode({
        'data': items,
        'meta': {
          'scope': {
            'audience': 'BUYER',
            'kind': 'RADIUS',
            'origin_kind': 'MAP_PIN',
            'origin_version': 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            'radius_km': 5,
            'radius_meters': 5000,
            'distance_basis': 'GEODESIC_STRAIGHT_LINE',
          },
          'current_as_of': '2026-10-24T12:00:00Z',
          'eligibility_version': 'fixture',
          'projection_version': 'fixture',
          'counts': {
            'verified_vendors': 0,
            'directory_suppliers': 0,
            'favorite_suppliers': 0,
          },
          'directory': {
            'status': 'AVAILABLE',
            'as_of': null,
            'attribution': {
              'provider': 'GOOGLE',
              'text': 'Source: Google Maps.',
            },
            'coverage_note': 'Fixture',
          },
          'expansion': {
            'eligible_verified_count': 0,
            'suggested_radius_km': null,
            'at_maximum': false,
            'reason': null,
            'requires_confirmation': true,
          },
          'page': 1,
          'per_page': 100,
          'total': 0,
          'has_more': false,
        },
        'errors': [],
      }),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const origin = DiscoveryOrigin.point(
    point: GeoPoint(14.6, 121),
    source: OriginSource.mapPin,
    label: 'Fixture origin',
  );

  test(
    'discovery carries public badge codes, rule text and scope into selection',
    () async {
      final adapter = _DiscoveryAdapter()
        ..items = [
          {
            'result_id': '01995000-0000-7000-8000-0000000000c1',
            'tier': 'VERIFIED_VENDOR',
            'tier_label': 'Verified Vendor',
            'rank': 1,
            'name': 'Sample Supplier',
            'marker': {'latitude': 14.6, 'longitude': 121.0},
            'distance_meters': 1000,
            'score_label': {'kind': 'VPS', 'value': '4.6', 'text': 'VPS 4.6'},
            'is_favorite': false,
            'directory': null,
            'vendor': {
              'logo_url': null,
              'supplier_type': null,
              'niches': [],
              'fulfillment_method': 'BOTH',
              'vacation_mode': false,
              'public_phone': null,
              'address': {
                'formatted_address': 'Manila',
                'city_municipality': 'Manila',
                'province': 'Metro Manila',
              },
              'open_status': {
                'status': 'OPEN',
                'opens_at': '08:00',
                'closes_at': '17:00',
                'basis': 'SAVED_SCHEDULE',
              },
              'serviceability': {
                'pickup_available': true,
                'delivery': 'WITHIN_STATED_AREA',
                'delivery_maximum_km': 10,
                'basis': 'STRAIGHT_LINE_ADVISORY',
              },
              'badges': [
                {
                  'code': 'MOST_ORDERED',
                  'name': 'Most Ordered',
                  'scope_label': 'Cement · Metro Manila',
                  'description': 'Public rule from server.',
                  'earned_at': '2026-11-06T00:00:00Z',
                },
              ],
            },
          },
        ];
      final dio = Dio()..httpClientAdapter = adapter;
      addTearDown(() => dio.close(force: true));
      final repository = ApiDiscoveryRepository(
        client: api.MateryalphApiClient(dio: dio),
        onSessionExpired: () async {},
      );
      final page = await repository.search(
        origin: origin,
        radiusKm: 5,
        filters: const DiscoveryFilters(),
      );
      final supplier = page.items.single;
      expect(supplier.scoreValue, '4.6');
      expect(supplier.badges.single.code, 'MOST_ORDERED');
      expect(supplier.badges.single.scopeLabel, 'Cement · Metro Manila');
      expect(supplier.badges.single.description, 'Public rule from server.');
      expect(supplier.withFavorite(true).badges.single.name, 'Most Ordered');
    },
  );

  test(
    'all minimum Google ratings reach the HTTP body as JSON numbers',
    () async {
      final adapter = _DiscoveryAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      addTearDown(() => dio.close(force: true));
      final repository = ApiDiscoveryRepository(
        client: api.MateryalphApiClient(dio: dio),
        onSessionExpired: () async =>
            fail('Successful discovery must retain the session'),
      );
      for (final minimum in [3.0, 3.5, 4.0, 4.5]) {
        final page = await repository.search(
          origin: origin,
          radiusKm: 5,
          filters: DiscoveryFilters(directoryMinRating: minimum),
        );
        expect(page.items, isEmpty);
        expect(adapter.bodies.last['directory_min_rating'], isA<num>());
        expect(adapter.bodies.last['directory_min_rating'], minimum);
      }
      await repository.search(
        origin: origin,
        radiusKm: 5,
        filters: const DiscoveryFilters(),
      );
      expect(adapter.bodies.last.containsKey('directory_min_rating'), isFalse);
      await repository.search(
        origin: origin,
        radiusKm: 5,
        filters: const DiscoveryFilters(
          directoryMinRating: 3.0,
          favoritesOnly: true,
        ),
      );
      // Favorites include Directory Suppliers, so their rating minimum still applies.
      expect(adapter.bodies.last['directory_min_rating'], 3.0);
      await repository.search(
        origin: origin,
        radiusKm: 5,
        filters: const DiscoveryFilters(
          directoryMinRating: 3.0,
          supplierType: 'OTHER',
        ),
      );
      expect(adapter.bodies.last.containsKey('directory_min_rating'), isFalse);
    },
  );

  test('numeric rating enums round-trip and reject unsupported values', () {
    for (final entry in {
      api.DiscoverySearchRequestDirectoryMinRatingEnum.number3Period0: 3.0,
      api.DiscoverySearchRequestDirectoryMinRatingEnum.number3Period5: 3.5,
      api.DiscoverySearchRequestDirectoryMinRatingEnum.number4Period0: 4.0,
      api.DiscoverySearchRequestDirectoryMinRatingEnum.number4Period5: 4.5,
    }.entries) {
      final wire = api.standardSerializers.serializeWith(
        api.DiscoverySearchRequestDirectoryMinRatingEnum.serializer,
        entry.key,
      );
      expect(wire, isA<num>());
      expect(wire, entry.value);
      expect(
        api.standardSerializers.deserializeWith(
          api.DiscoverySearchRequestDirectoryMinRatingEnum.serializer,
          wire,
        ),
        entry.key,
      );
    }
    for (final invalid in [2.5, 3.1, 5.0, '3.0']) {
      expect(
        () => api.standardSerializers.deserializeWith(
          api.DiscoverySearchRequestDirectoryMinRatingEnum.serializer,
          invalid,
        ),
        throwsA(anything),
      );
    }
  });
}
