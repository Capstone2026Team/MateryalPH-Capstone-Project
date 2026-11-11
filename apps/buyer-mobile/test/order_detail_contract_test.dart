import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/orders/orders_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

/// The generated client must parse exactly what the API sends. An order with no payment attempt yet
/// returns `latest_attempt: null` and `verified_payment: null`; when the contract declared those as
/// non-null the client threw while parsing and Order Details showed "This order could not load".
OrdersRepository _repositoryReturning(Map<String, Object?> body) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
  final client = api.MateryalphApiClient(
    dio: dio,
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response<Object?>(
            requestOptions: options,
            statusCode: 200,
            data: body,
          ),
        ),
      ),
    ],
  );
  return ApiOrdersRepository(client: client, onSessionExpired: () async {});
}

Map<String, Object?> _envelope(void Function(Map<String, dynamic> data) edit) {
  final data =
      jsonDecode(
            File(
              'test/fixtures/order_detail_without_payment_attempt.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  edit(data);
  return {'data': data, 'meta': <String, Object?>{}, 'errors': <Object?>[]};
}

void main() {
  test(
    'milestone notes parse from the order response without requiring notes',
    () async {
      const note =
          'Collect at the loading entrance.\nBring your order reference.';
      final repository = _repositoryReturning(
        _envelope((data) {
          data['fulfillment'] = {
            'method': 'PICKUP',
            'state': 'READY_FOR_PICKUP',
            'late': false,
            'tracking_notice': 'No live GPS tracking.',
            'next_action': 'NONE',
            'steps': [
              for (var index = 0; index < 3; index++)
                {
                  'key': ['PROCESSING', 'READY_FOR_PICKUP', 'PICKED_UP'][index],
                  'label': [
                    'Preparing',
                    'Ready for pickup',
                    'Picked up',
                  ][index],
                  'status': index < 2 ? 'COMPLETE' : 'CURRENT',
                  'proof_required': false,
                  'proof_requirements': <String>[],
                  if (index < 2) 'note': index == 0 ? note : null,
                },
            ],
            'trips': [],
            'vehicle_issues': [],
            'receipt': {'paused': false, 'window_hours': 48},
            'thread': {'available': false, 'read_only': false},
          };
        }),
      );
      final order = await repository.order('order');
      expect(order.fulfillment!.steps.map((step) => step.note), [
        note,
        null,
        null,
      ]);
    },
  );

  test(
    'confirmed delivery parses the saved vehicle profile and photo',
    () async {
      final repository = _repositoryReturning(
        _envelope((data) {
          data['fulfillment_method'] = 'DELIVERY';
          data['delivery'] = {
            'status': 'CONFIRMED',
            'estimate': null,
            'confirmed': {
              'vehicles': [
                {
                  'name': 'Accepted mixer',
                  'vehicle_category': 'TRUCK',
                  'vehicle_type': 'CONCRETE_MIXER',
                  'custom_type_name': null,
                  'brand': 'Isuzu',
                  'capacity_kg': '14400',
                  'heavy_classification': 'HEAVY',
                  'configuration_version': 1,
                  'rate_version': 1,
                  'number_of_vehicles': 1,
                  'total_vehicle_trips': 2,
                  'per_trip_centavos': 25000,
                  'trip_total_centavos': 50000,
                  'vehicle_details': {
                    'name': 'Accepted mixer',
                    'vehicle_type': 'CONCRETE_MIXER',
                    'brand': 'Isuzu',
                    'image_file_id': 'accepted-photo',
                    'capacity_kg': '14400',
                    'mixer_capacity_m3': '6',
                    'heavy_classification': 'HEAVY',
                  },
                },
              ],
              'distance_meters': 4200,
              'route_source': 'GOOGLE_ROUTES',
              'basis': 'ADVISORY_CONFIRMED',
              'endpoint': 'INTENDED_LOCATION',
              'heavy_vehicle_restriction': false,
              'intended': null,
              'alternate_drop_off': null,
              'final_fee_centavos': 50000,
              'fulfillment_date': null,
              'arrangement': 'Unload at the gate',
              'calculation_version': 'fixture',
              'confirmed_by_role': 'OWNER',
              'confirmed_at': '2026-11-05T01:00:00Z',
            },
          };
        }),
      );
      final detail = await repository.order('order');
      final vehicle = detail.confirmedDelivery!.vehicles.single;
      expect(vehicle.name, 'Accepted mixer');
      expect(vehicle.imageFileId, 'accepted-photo');
      expect(vehicle.mixerCapacityM3, '6');
      expect(vehicle.capacityKg, '14400');
      expect(vehicle.trips, 2);
      expect(detail.recommendedVehicles, isEmpty);
    },
  );
  test(
    'submitted delivery recommendations parse vehicle photos and capacities without becoming confirmed',
    () async {
      final repository = _repositoryReturning(
        _envelope((data) {
          data['fulfillment_method'] = 'DELIVERY';
          data['delivery'] = {
            'status': 'ADVISORY_ESTIMATE',
            'confirmed': null,
            'estimate': {
              'fee_min_centavos': 50000,
              'fee_max_centavos': 50000,
              'trips_min': 2,
              'trips_max': 2,
              'options': [
                {
                  'load_key': 'line',
                  'vehicle_id': 'truck',
                  'vehicle_name': 'Mixer A',
                  'vehicle_type': 'CONCRETE_MIXER',
                  'vehicles': 1,
                  'trips': 2,
                  'fee_centavos': 50000,
                  'fee_per_trip_centavos': 25000,
                  'mobilization_fee_centavos': 0,
                  'mobilization_total_centavos': 0,
                  'vehicle_details': {
                    'name': 'Mixer A',
                    'brand': 'Isuzu',
                    'image_file_id': 'vehicle-photo',
                    'capacity_kg': '14400',
                    'mixer_capacity_m3': '6',
                    'vehicle_type': 'CONCRETE_MIXER',
                    'heavy_classification': 'HEAVY',
                  },
                },
              ],
            },
          };
        }),
      );
      final detail = await repository.order('order');
      final vehicle = detail.recommendedVehicles.single;
      expect(vehicle.name, 'Mixer A');
      expect(vehicle.imageFileId, 'vehicle-photo');
      expect(vehicle.capacityKg, '14400');
      expect(vehicle.mixerCapacityM3, '6');
      expect(vehicle.trips, 2);
      expect(detail.confirmedDelivery, isNull);
    },
  );
  test(
    'delivery assignment and proof parse public coordination fields and private evidence paths',
    () async {
      const path =
          '/buyers/orders/01a0fb55-e5f2-7081-a9ee-314ee8596f6f/files/01a0fb55-e5f2-7081-a9ee-314ee8596f70';
      final repository = _repositoryReturning(
        _envelope((data) {
          data['fulfillment_method'] = 'DELIVERY';
          data['fulfillment'] = {
            'method': 'DELIVERY',
            'state': 'DELIVERED',
            'late': false,
            'tracking_notice': 'No live GPS tracking.',
            'next_action': 'CONFIRM_RECEIPT',
            'steps': [],
            'trips': [],
            'receipt': {'paused': false, 'window_hours': 48},
            'thread': {'available': false, 'read_only': false},
            'assignment': {
              'display_name': 'Assigned Delivery Staff',
              'role': 'FULFILLMENT',
              'user_id': null,
              'assigned_at': '2026-10-13T01:00:00Z',
              'vehicle': {
                'vehicle_index': 0,
                'name': 'Accepted truck',
                'number_of_vehicles': 1,
                'total_vehicle_trips': 1,
              },
            },
            'vehicle_issues': [
              {'category': 'DELAY', 'description': 'Road works at the gate.'},
            ],
            'proof': {
              'milestone': 'DELIVERED',
              'handover_confirmed': false,
              'receiver_name': 'Site Receiver',
              'recorded_at': '2026-10-13T02:00:00Z',
              'recorded_by': 'Assigned Delivery Staff',
              'photo_path': path,
              'signature_path': path,
              'additional_photo_paths': [path],
              'note': 'All materials received.',
            },
          };
        }),
      );
      final order = await repository.order(
        '01a0fb55-e5f2-7081-a9ee-314ee8596f6f',
      );
      expect(order.fulfillment!.assigneeName, 'Assigned Delivery Staff');
      expect(order.fulfillment!.vehicleName, 'Accepted truck');
      expect(order.fulfillment!.assignedAt, DateTime.utc(2026, 10, 13, 1));
      expect(order.fulfillment!.proof!.recordedBy, 'Assigned Delivery Staff');
      expect(order.fulfillment!.proof!.additionalPhotoPaths, [path]);
      expect(order.fulfillment!.proof!.note, 'All materials received.');
      expect(order.fulfillment!.deliveryIssues, [
        'DELAY: Road works at the gate.',
      ]);
    },
  );

  test('an order with no payment attempt yet opens', () async {
    final repository = _repositoryReturning(_envelope((_) {}));
    final order = await repository.order(
      '01a0fb55-e5f2-7081-a9ee-314ee8596f6f',
    );
    expect(order.reference, 'ORD-2026-SY5SGTGN');
    expect(order.state('PAYMENT'), 'EXPIRED');
    expect(order.payment, isNotNull);
    expect(order.payment!.latestAttempt, isNull);
    expect(order.payment!.verifiedPayment, isNull);
  });

  test(
    'an order with a payment due lists the PAY action and still opens',
    () async {
      final repository = _repositoryReturning(
        _envelope((data) {
          data['available_actions'] = ['PAY'];
          (data['payment'] as Map<String, dynamic>)
            ..['available'] = true
            ..['purpose'] = 'FULL_ORDER_PAYMENT'
            ..['principal_centavos'] = 28550;
        }),
      );
      final order = await repository.order(
        '01a0fb55-e5f2-7081-a9ee-314ee8596f6f',
      );
      expect(order.actions, contains('PAY'));
      expect(order.payment!.available, isTrue);
      expect(order.payment!.purpose, 'FULL_ORDER_PAYMENT');
    },
  );
}
