import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/api_guard.dart';
import 'package:materyalph/features/trust/reviews_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

Map<String, Object?> _envelope() => {
  'data': {
    'order_id': 'order-1',
    'order_reference': 'ORD-1',
    'state': 'OPEN',
    'revealed': false,
    'withheld_for_dispute': false,
    'party': 'BUYER',
    'speed_kind': 'PROCESSING_SPEED',
    'speed_label': 'Processing Speed',
    'rules': {
      'window_days': 14,
      'edit_hours': 24,
      'comment_max': 1000,
      'media_max': 3,
      'photo_max_bytes': 10485760,
      'video_max_bytes': 104857600,
      'blind_reveal': 'Hidden until reveal',
    },
    'display_name_options': [
      {'choice': 'VERIFIED_BUYER', 'preview': 'Verified Buyer'},
    ],
    'can_submit_vendor_rating': true,
    'lines': [
      {
        'order_line_id': 'line-1',
        'listing_id': 'listing-1',
        'display_name': 'Cement',
        'can_review': false,
        'review': {
          'id': 'review-1',
          'type': 'PRODUCT',
          'ratings': {'product_quality': 4},
          'display_name': 'Verified Buyer',
          'can_edit': true,
          'correction_requested': false,
          'visibility': 'HIDDEN_UNTIL_REVEAL',
          'revision': 2,
          'lock_version': 2,
          'media': [
            {
              'id': 'media-1',
              'url':
                  'https://api.example.test/api/v1/buyers/reviews/review-1/media/media-1/content?expires=2000000000&signature=test-signature',
              'expires_at': '2033-05-18T03:33:20Z',
              'content_type': 'video/mp4',
              'byte_size': 2000,
            },
          ],
        },
      },
    ],
  },
  'meta': <String, Object?>{},
  'errors': <Object?>[],
};

void main() {
  test(
    'review decoding retains video type, own media and authoritative limits',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
      final client = api.MateryalphApiClient(
        dio: dio,
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: _envelope(),
              ),
            ),
          ),
        ],
      );
      final repository = ApiReviewsRepository(
        client: client,
        guard: ApiGuard(() async {}),
      );
      final view = await repository.orderReviews('order-1');
      expect(view.lines.single.review!.media.single.video, isTrue);
      expect(view.lines.single.review!.media.single.byteSize, 2000);
      expect(view.mediaMax, 3);
      expect(view.photoMaxBytes, 10485760);
      expect(view.videoMaxBytes, 104857600);
    },
  );

  test(
    'media upload sends a PHP file array and preserves the retry key',
    () async {
      final temporary = await Directory.systemTemp.createTemp(
        'review-upload-test-',
      );
      addTearDown(() => temporary.delete(recursive: true));
      final file = await File(
        '${temporary.path}/photo.jpg',
      ).writeAsBytes([1, 2, 3]);
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
      final client = api.MateryalphApiClient(
        dio: dio,
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: _envelope(),
                ),
              );
            },
          ),
        ],
      );
      final repository = ApiReviewsRepository(
        client: client,
        guard: ApiGuard(() async {}),
      );
      for (var attempt = 0; attempt < 2; attempt++) {
        await repository.addMedia(
          reviewId: 'review-1',
          path: file.path,
          filename: 'photo.jpg',
          idempotencyKey: 'same-upload-key',
        );
      }
      expect(requests.map((request) => request.headers['Idempotency-Key']), [
        'same-upload-key',
        'same-upload-key',
      ]);
      expect((requests.first.data as FormData).files.single.key, 'files[]');
      expect(
        (requests.first.data as FormData).files.single.value.filename,
        'photo.jpg',
      );
    },
  );

  test(
    'media retrieval uses the generated API path and signed query',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
      final client = api.MateryalphApiClient(
        dio: dio,
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: options.responseType == ResponseType.bytes
                      ? Uint8List.fromList([1, 2])
                      : _envelope(),
                ),
              );
            },
          ),
        ],
      );
      final repository = ApiReviewsRepository(
        client: client,
        guard: ApiGuard(() async {}),
      );
      final view = await repository.orderReviews('order-1');
      final bytes = await repository.media(
        'review-1',
        view.lines.single.review!.media.single,
      );
      expect(bytes, [1, 2]);
      expect(
        requests.last.path,
        '/buyers/reviews/review-1/media/media-1/content',
      );
      expect(requests.last.queryParameters['expires'], 2000000000);
      expect(requests.last.queryParameters['signature'], 'test-signature');
    },
  );
}
