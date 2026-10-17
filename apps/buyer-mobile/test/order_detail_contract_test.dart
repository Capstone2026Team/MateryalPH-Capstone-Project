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
