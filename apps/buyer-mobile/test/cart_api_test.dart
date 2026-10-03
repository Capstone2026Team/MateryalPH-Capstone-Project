import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/procurement_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
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
