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
  test('an order with no payment attempt yet opens', () async {
    final repository = _repositoryReturning(_envelope((_) {}));
    final order = await repository.order('01a0fb55-e5f2-7081-a9ee-314ee8596f6f');
    expect(order.reference, 'ORD-2026-SY5SGTGN');
    expect(order.state('PAYMENT'), 'EXPIRED');
    expect(order.payment, isNotNull);
    expect(order.payment!.latestAttempt, isNull);
    expect(order.payment!.verifiedPayment, isNull);
  });

  test('an order with a payment due lists the PAY action and still opens', () async {
    final repository = _repositoryReturning(
      _envelope((data) {
        data['available_actions'] = ['PAY'];
        (data['payment'] as Map<String, dynamic>)
          ..['available'] = true
          ..['purpose'] = 'FULL_ORDER_PAYMENT'
          ..['principal_centavos'] = 28550;
      }),
    );
    final order = await repository.order('01a0fb55-e5f2-7081-a9ee-314ee8596f6f');
    expect(order.actions, contains('PAY'));
    expect(order.payment!.available, isTrue);
    expect(order.payment!.purpose, 'FULL_ORDER_PAYMENT');
  });
}
