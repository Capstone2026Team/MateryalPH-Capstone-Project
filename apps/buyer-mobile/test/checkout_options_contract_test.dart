import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/invoice_billing_input.dart';
import 'package:materyalph/features/orders/orders_repository.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

void main() {
  test(
    'checkout resolves Projects through its order repository with bearer auth and session expiry',
    () async {
      final client = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      );
      client.setBearerAuth('passportBearer', 'checkout-project-fixture');
      var expired = false;
      var reject = false;
      RequestOptions? sent;
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            sent = options;
            if (reject) {
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
              return;
            }
            handler.resolve(
              Response<Object?>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {'items': <Object?>[], 'page': 1, 'has_more': false},
                  'meta': <String, Object?>{},
                  'errors': <Object?>[],
                },
              ),
            );
          },
        ),
      );
      final orders = ApiOrdersRepository(
        client: client,
        onSessionExpired: () async {
          expired = true;
        },
      );
      // No separately injected Projects repository is needed by a checkout using the API Orders repository.
      final page = await orders.projects.list();
      expect(page.items, isEmpty);
      expect(sent!.path, '/buyers/projects');
      expect(sent!.headers['Authorization'], 'Bearer checkout-project-fixture');
      expect(expired, isFalse);
      reject = true;
      await expectLater(
        orders.projects.list(),
        throwsA(
          isA<DiscoveryFailure>().having(
            (error) => error.kind,
            'kind',
            DiscoveryFailureKind.sessionExpired,
          ),
        ),
      );
      expect(expired, isTrue);
    },
  );

  test(
    'checkout serializes the project link and private billing through the authenticated generated client',
    () async {
      RequestOptions? sent;
      final client = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      );
      client.setBearerAuth('passportBearer', 'checkout-test-fixture');
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            sent = options;
            handler.resolve(
              Response<Object?>(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'data': {
                    'id': 'checkout',
                    'reference': 'CHK',
                    'submitted_at': '2026-10-15T00:00:00Z',
                    'derived_status': 'EMPTY',
                    'orders': <Object?>[],
                    'notice': 'Submitted',
                  },
                  'meta': <String, Object?>{},
                  'errors': <Object?>[],
                },
              ),
            );
          },
        ),
      );
      final repository = ApiOrdersRepository(
        client: client,
        onSessionExpired: () async {},
      );
      await repository.submitCheckout(
        cartLockVersion: 3,
        vendorIds: ['vendor'],
        splitConfirmed: false,
        idempotencyKey: 'checkout-request-key',
        workPackageId: 'package',
        workPackageLockVersion: 7,
        budgetOverrideReason: 'Approved additional foundation materials.',
        invoiceDetails: const InvoiceBillingInput(
          name: 'Test Buyer',
          address: 'Test street, Quezon City',
          tin: '123456789000',
        ),
      );
      expect(sent!.headers['Authorization'], 'Bearer checkout-test-fixture');
      expect(sent!.headers['Idempotency-Key'], 'checkout-request-key');
      expect(sent!.data, containsPair('work_package_id', 'package'));
      expect(sent!.data, containsPair('work_package_lock_version', 7));
      expect(
        sent!.data,
        containsPair(
          'budget_override_reason',
          'Approved additional foundation materials.',
        ),
      );
      expect((sent!.data as Map)['invoice_details'], {
        'billing_name': 'Test Buyer',
        'billing_address': 'Test street, Quezon City',
        'tin': '123456789000',
      });
      await repository.submitCheckout(
        cartLockVersion: 4,
        vendorIds: ['vendor'],
        splitConfirmed: false,
        idempotencyKey: 'ordinary-checkout',
      );
      expect((sent!.data as Map).containsKey('invoice_details'), isFalse);
      expect((sent!.data as Map).containsKey('work_package_id'), isFalse);
    },
  );
}
