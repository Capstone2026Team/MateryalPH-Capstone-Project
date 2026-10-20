import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/api_guard.dart';
import 'package:materyalph/features/disputes/dispute_models.dart';
import 'package:materyalph/features/disputes/disputes_repository.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

class _DisputeAdapter implements HttpClientAdapter {
  late RequestOptions request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode({
        'data': null,
        'meta': <String, Object?>{},
        'errors': [
          {
            'code': 'VALIDATION_FAILED',
            'message': 'Review the highlighted fields and try again.',
            'details': {
              'affected_line_ids': ['Select at least one affected line.'],
            },
          },
        ],
      }),
      422,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const lineIds = [
    '019a0123-0000-7000-8000-000000000002',
    '019a0123-0000-7000-8000-000000000003',
  ];
  for (final (lineCount, withEvidence) in [
    (1, false),
    (1, true),
    (2, false),
    (2, true),
  ]) {
    test(
      'filing encodes $lineCount PHP array items with evidence=$withEvidence',
      () async {
        final adapter = _DisputeAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'))
          ..httpClientAdapter = adapter;
        final repository = ApiDisputesRepository(
          client: api.MateryalphApiClient(dio: dio),
          guard: ApiGuard(() async {}),
        );
        await expectLater(
          repository.file(
            orderId: '019a0123-0000-7000-8000-000000000001',
            issueType: 'DEFECTIVE',
            requestedRemedy: 'RETURN_AND_REFUND',
            description: 'The steel bars arrived damaged and need returning.',
            affectedLineIds: lineIds.take(lineCount).toList(),
            evidence: withEvidence
                ? EvidenceFile(
                    bytes: Uint8List.fromList([1, 2, 3]),
                    filename: 'damaged.png',
                  )
                : null,
            idempotencyKey: '019a0123-0000-7000-8000-000000000004',
          ),
          throwsA(
            isA<DiscoveryFailure>().having(
              (error) => error.details['affected_line_ids'],
              'field errors survive the API boundary',
              ['Select at least one affected line.'],
            ),
          ),
        );
        expect(adapter.request.path, '/buyers/disputes');
        expect(
          adapter.request.headers['Idempotency-Key'],
          '019a0123-0000-7000-8000-000000000004',
        );
        final form = adapter.request.data as FormData;
        expect(
          form.fields
              .where((entry) => entry.key == 'affected_line_ids[]')
              .map((entry) => entry.value),
          lineIds.take(lineCount),
        );
        expect(
          form.fields.any((entry) => entry.key == 'affected_line_ids'),
          isFalse,
        );
        expect(
          form.files.map((entry) => entry.key),
          withEvidence ? ['files[]'] : isEmpty,
        );
      },
    );
  }
}
