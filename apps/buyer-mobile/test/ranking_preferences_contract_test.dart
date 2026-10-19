import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/procurement_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

void main() {
  test(
    'Item API saves raw values and a new repository restores a total of 350',
    () async {
      final client = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      );
      const raw = RankingWeights(
        distance: 80,
        price: 60,
        vps: 70,
        stock: 90,
        productRating: 50,
      );
      var persisted = RankingWeights.approvedDefault.toMap();
      var version = 0;
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, '/buyers/ranking-preferences/item-based');
            if (options.method == 'PUT') {
              final body = Map<String, Object?>.from(options.data as Map);
              expect(body['weights'], raw.toMap());
              expect(body['version'], 0);
              persisted = Map<String, int>.from(body['weights']! as Map);
              version++;
            }
            handler.resolve(
              Response<Object?>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {
                    'procurement_type': 'ITEM_BASED',
                    'weights': persisted,
                    'default_weights': RankingWeights.approvedDefault.toMap(),
                    'defaults_version': 1,
                    'personalized': version > 0,
                    'version': version,
                    'total_percent': persisted.values.reduce((a, b) => a + b),
                    'algorithm_version': 'srs.normalized-weighted-sum.v2',
                  },
                  'meta': <String, Object?>{},
                  'errors': <Object?>[],
                },
              ),
            );
          },
        ),
      );
      ApiProcurementRepository repository() => ApiProcurementRepository(
        client: client,
        onSessionExpired: () async {},
      );
      expect(
        (await repository().savePreferences(raw, version: 0)).weights,
        raw,
      );
      expect((await repository().preferences()).weights, raw);
    },
  );

  test(
    'generated ranking explanations retain fractional effective percentages',
    () {
      final serializers = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      ).serializers;
      final component = serializers
          .deserializeWith(api.RankingComponent.serializer, {
            'key': 'distance',
            'label': 'Distance',
            'weight_percent': 22.8571,
            'score': '80.00',
            'weighted': '18.29',
            'basis': 'Within your radius',
          })!;
      expect(component.weightPercent, 22.8571);
      final wire =
          serializers.serializeWith(api.RankingComponent.serializer, component)
              as Map;
      expect(wire['weight_percent'], 22.8571);
    },
  );
}
