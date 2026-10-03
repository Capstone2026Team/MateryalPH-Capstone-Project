import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/messaging/messaging_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

class MessagingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      options.method == 'GET'
          ? '{"data":{"items":[{"id":"thread","purpose":"SALES","context_type":"ITEM_BASED","lock_version":1,"store":{"id":"store","name":"Fixture store","verified":true,"logo_url":null},"handler":{"display_name":"Public staff","role":"OWNER","avatar_path":null},"buyer":{"display_name":"Buyer","role":"BUYER","avatar_path":null},"unread_count":0,"channel":"channel","locked_reference":{},"updated_at":"2026-10-02T12:00:00+00:00","can_transfer":false,"fulfillment_entry_enabled":false,"read_only":false,"last_message_preview":"","legacy_conversation_ids":[]}],"page":1,"has_more":false},"meta":{},"errors":[]}'
          : '{"data":{"id":"thread"},"meta":{},"errors":[]}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'real generated inbox decodes profile identities and product-free creation uses bearer transport',
    () async {
      final adapter = MessagingAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      final client = api.MateryalphApiClient(dio: dio)
        ..setBearerAuth('passportBearer', 'synthetic-test-token');
      final repository = ApiMessagingRepository(
        client: client,
        onSessionExpired: () async =>
            fail('Successful inbox must retain the session'),
      );
      final inbox = await repository.inbox();
      expect(inbox.items.single.handler!.displayName, 'Public staff');
      expect(inbox.items.single.lockedReference, isEmpty);
      expect(adapter.requests.single.path, '/buyers/conversations');
      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer synthetic-test-token',
      );
      await repository.create('store', null, 'request');
      expect(adapter.requests.last.data, isNot(contains('listing_variant_id')));
      await repository.send('thread', '', 'message', productId: 'variant');
      expect(adapter.requests.last.data, containsPair('product_id', 'variant'));
      expect(
        adapter.requests.last.data,
        containsPair('client_message_id', 'message'),
      );
      await repository.updateDestination('thread', 4, 'location', 'NO');
      expect(
        adapter.requests.last.data,
        containsPair('heavy_vehicle_restriction', 'NO'),
      );
      expect(adapter.requests.last.data, containsPair('lock_version', 4));
    },
  );
}
