import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:materyalph/features/support/support_repository.dart';

class _SupportAdapter implements HttpClientAdapter {
  _SupportAdapter(this.reply);
  final ResponseBody Function(RequestOptions) reply;
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return reply(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object? data, {Object? meta, int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode({
        'data': data,
        'meta': meta ?? <String, Object?>{},
        'errors': [],
      }),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  test(
    'creation uses the generated multipart contract, stable key and private attachment array',
    () async {
      final adapter = _SupportAdapter(
        (_) => _json({
          'id': 'ticket-id',
          'ticket_number': 'SUP-EXAMPLE',
          'status': 'OPEN',
        }, status: 201),
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'))
        ..httpClientAdapter = adapter;
      final repository = BuyerSupportRepository(
        api.MateryalphApiClient(dio: dio),
        () async {},
      );
      final receipt = await repository.create(
        category: api.SupportCategory.TECHNICAL_ISSUE,
        subject: 'Technical issue',
        message: 'Please investigate this issue.',
        key: 'same-request-key',
        files: [
          SupportUpload('proof.png', Uint8List.fromList([1, 2, 3])),
        ],
        referenceType: api.SupportReferenceType.ORDER,
        reference: 'order-reference',
      );
      expect(receipt.ticketNumber, 'SUP-EXAMPLE');
      expect(adapter.requests.single.path, '/support/buyers/tickets');
      expect(
        adapter.requests.single.headers['Idempotency-Key'],
        'same-request-key',
      );
      final form = adapter.requests.single.data as FormData;
      expect(form.files.single.key, 'files[]');
      expect(
        form.fields,
        contains(const MapEntry('reference', 'order-reference')),
      );
      expect(form.fields, contains(const MapEntry('user_type', 'BUYER')));
    },
  );

  test(
    'list pagination and null cursors deserialize through generated serializers',
    () async {
      final adapter = _SupportAdapter(
        (_) => _json([], meta: {'next_cursor': null}),
      );
      final repository = BuyerSupportRepository(
        api.MateryalphApiClient(
          dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'))
            ..httpClientAdapter = adapter,
        ),
        () async {},
      );
      final page = await repository.list('older-cursor');
      expect(page.data, isEmpty);
      expect(page.meta.nextCursor, isNull);
      expect(adapter.requests.single.queryParameters['cursor'], 'older-cursor');
    },
  );

  test(
    'attachment content uses the authenticated API and session expiry clears local access',
    () async {
      var expired = 0;
      final adapter = _SupportAdapter(
        (_) => ResponseBody.fromString(
          jsonEncode({
            'data': null,
            'meta': {},
            'errors': [
              {
                'code': 'UNAUTHENTICATED',
                'message': 'Sign in again.',
                'details': {},
              },
            ],
          }),
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );
      final repository = BuyerSupportRepository(
        api.MateryalphApiClient(
          dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'))
            ..httpClientAdapter = adapter,
        ),
        () async {
          expired++;
        },
      );
      await expectLater(
        repository.attachment('ticket-id', 'file-id'),
        throwsA(isA<Exception>()),
      );
      expect(expired, 1);
      expect(
        adapter.requests.single.path,
        '/support/buyers/tickets/ticket-id/attachments/file-id',
      );
    },
  );
}
