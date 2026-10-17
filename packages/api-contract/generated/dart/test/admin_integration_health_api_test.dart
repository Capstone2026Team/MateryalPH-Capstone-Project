import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminIntegrationHealthApi
void main() {
  final instance = MateryalphApiClient().getAdminIntegrationHealthApi();

  group(AdminIntegrationHealthApi, () {
    // integrations.view. Provider, queue, scheduled-task, aggregation, Materials snapshot and PSGC health without secrets.
    //
    //Future<IntegrationOverviewEnvelope> getIntegrationHealth() async
    test('test getIntegrationHealth', () async {
      // TODO
    });

    // integrations.view. Dead-lettered outbox deliveries or failed jobs: type and failure class only.
    //
    //Future<OperationFailureListEnvelope> listOperationFailures({ String kind, int page, Date from, Date to }) async
    test('test listOperationFailures', () async {
      // TODO
    });

    // integrations.view. Recent authorized retries with reasons.
    //
    //Future<OperationRetryListEnvelope> listOperationRetries() async
    test('test listOperationRetries', () async {
      // TODO
    });

    // jobs.retry. Retry an allowlisted idempotent failed job, outbox delivery or daily analytics run with a reason. Payment and refund work belongs to reconciliation (409 RETRY_NOT_ALLOWED).
    //
    //Future<OperationRetryEnvelope> retryOperation(String idempotencyKey, OperationRetryRequest operationRetryRequest) async
    test('test retryOperation', () async {
      // TODO
    });

  });
}
