import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/procurement_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  test(
    'product delivery preview uses the generated API and preserves the fee range and blockers',
    () async {
      var manual = false;
      var requests = 0;
      final client = MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests++;
              expect(options.path, '/buyers/cart/delivery-preview');
              expect(options.data, {
                'listing_variant_id': '01995000-0000-7000-8000-000000000001',
                'quantity': '100',
              });
              handler.resolve(
                Response<Object?>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': {
                      'status': manual ? 'MANUAL_REVIEW' : 'ADVISORY_ESTIMATE',
                      'issues': manual
                          ? [
                              {
                                'code': 'DELIVERY_MANUAL_REVIEW',
                                'severity': 'INFO',
                                'message': 'Product weight is missing.',
                              },
                            ]
                          : [],
                      'endpoint': 'ALTERNATE_DROP_OFF',
                      'route': {
                        'distance_meters': 4200,
                        'duration_seconds': 600,
                        'basis': 'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF',
                        'source': 'GOOGLE_ROUTES',
                        'computed_at': '2026-10-07T06:00:00Z',
                        'cached': false,
                      },
                      'straight_line_meters': 3000,
                      'coverage_km': 40,
                      'estimate': manual
                          ? null
                          : {
                              'fee_min_centavos': 121000,
                              'fee_max_centavos': 140000,
                              'trips_min': 2,
                              'trips_max': 2,
                              'vehicles_min': 1,
                              'vehicles_max': 2,
                              'options': [
                                {
                                  'load_key': 'selected-product',
                                  'vehicle_name': 'Box truck',
                                  'vehicle_type': 'BOX_TRUCK',
                                  'vehicles': 2,
                                  'trips': 2,
                                  'fee_centavos': 121000,
                                  'fee_per_trip_centavos': 60500,
                                },
                              ],
                            },
                      'manual_review_reasons': manual ? ['WEIGHT_UNKNOWN'] : [],
                      'confirmed_offer': null,
                      'calculation_version': 'delivery-v1',
                      'notice':
                          'Estimate only. The Vendor confirms the final fee.',
                    },
                    'meta': {},
                    'errors': [],
                  },
                ),
              );
            },
          ),
        ],
      );
      final repository = ApiProcurementRepository(
        client: client,
        onSessionExpired: () async => fail('Session remains active'),
      );
      final estimate = await repository.productDeliveryPreview(
        variantId: '01995000-0000-7000-8000-000000000001',
        quantity: '100',
      );
      expect(estimate.estimate!.feeMinCentavos, 121000);
      expect(estimate.estimate!.feeMaxCentavos, 140000);
      expect(estimate.estimate!.options.single.trips, 2);
      expect(estimate.endpoint, 'ALTERNATE_DROP_OFF');
      expect(estimate.confirmedOffer, false);
      manual = true;
      final unavailable = await repository.productDeliveryPreview(
        variantId: '01995000-0000-7000-8000-000000000001',
        quantity: '100',
      );
      expect(unavailable.estimate, isNull);
      expect(unavailable.manualReviewReasons, ['WEIGHT_UNKNOWN']);
      expect(unavailable.issues.single.message, 'Product weight is missing.');
      expect(
        requests,
        2,
        reason: 'Preview never adds a cart line or places an order.',
      );
    },
  );

  test('generated client decodes an empty cart response', () async {
    final client = MateryalphApiClient(
      dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      interceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.resolve(
            Response<Object?>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'data': {
                  'id': '01995000-0000-7000-8000-000000000001',
                  'lock_version': 1,
                  'current_as_of': '2026-09-30T06:00:00+00:00',
                  'destination': {
                    'intended': null,
                    'heavy_vehicle_restriction': 'UNANSWERED',
                    'alternate_drop_off': null,
                    'vehicle_endpoint': null,
                    'access_instructions': null,
                    'labels': {
                      'intended': 'Intended destination / Project site',
                      'vehicle_endpoint': 'Actual vehicle drop-off',
                    },
                  },
                  'groups': <Object?>[],
                  'saved_for_later': <Object?>[],
                  'summary': {
                    'line_count': 0,
                    'vendor_count': 0,
                    'materials_subtotal_centavos': 0,
                    'notice': 'Nothing is reserved until the Vendor confirms.',
                    'reserves_stock': false,
                  },
                },
                'meta': {'correlation_id': 'cart-regression'},
                'errors': <Object?>[],
              },
            ),
          ),
        ),
      ],
    );
    final response = await client.getBuyerCartApi().getBuyerCart();
    expect(response.data!.data.summary.lineCount, 0);
    expect(response.data!.data.destination.intended, isNull);
    final controller = CartController(
      repository: ApiProcurementRepository(
        client: client,
        onSessionExpired: () async => fail('The session must remain active'),
      ),
    );
    addTearDown(controller.dispose);
    await controller.load();
    expect(controller.phase, LoadPhase.ready);
    expect(controller.failure, isNull);
    expect(controller.cart!.empty, isTrue);
  });

  test('checkout preview boolean constants round trip as JSON booleans', () {
    final json = <String, Object?>{
      'group_count': 1,
      'ready_groups': 1,
      'action_required_groups': 0,
      'blocked_groups': 0,
      'requires_split_confirmation': false,
      'creates_orders': false,
      'reserves_stock': false,
      'notice': 'Preview only.',
    };
    final summary = standardSerializers.deserializeWith(
      CheckoutPreviewSummary.serializer,
      json,
    )!;
    expect(
      summary.createsOrders,
      CheckoutPreviewSummaryCreatesOrdersEnum.false_,
    );
    expect(
      summary.reservesStock,
      CheckoutPreviewSummaryReservesStockEnum.false_,
    );
    expect(
      standardSerializers.serializeWith(
        CheckoutPreviewSummary.serializer,
        summary,
      ),
      json,
    );
  });

  test('boolean constants reject strings and the opposite boolean', () {
    for (final invalid in <Object>['false', 'true', true, 0]) {
      expect(
        () => standardSerializers.deserialize(
          invalid,
          specifiedType: const FullType(CartSummaryReservesStockEnum),
        ),
        throwsA(isA<DeserializationError>()),
      );
    }
  });

  test('true constants serialize as booleans and retain const validation', () {
    const type = FullType(NrpcAcceptRequestAcknowledgedEnum);
    expect(
      standardSerializers.serialize(
        NrpcAcceptRequestAcknowledgedEnum.true_,
        specifiedType: type,
      ),
      true,
    );
    expect(
      standardSerializers.deserialize(true, specifiedType: type),
      NrpcAcceptRequestAcknowledgedEnum.true_,
    );
    for (final invalid in <Object>['true', false]) {
      expect(
        () => standardSerializers.deserialize(invalid, specifiedType: type),
        throwsA(isA<DeserializationError>()),
      );
    }
  });
}
