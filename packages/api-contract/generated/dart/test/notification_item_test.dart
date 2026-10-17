import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for NotificationItem
void main() {
  final instance = NotificationItemBuilder();
  // TODO add properties to the builder and call build()

  group(NotificationItem, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String category
    test('to test the property `category`', () async {
      // TODO
    });

    // Actual event title. MESSAGES identifies the public sender display name and store name.
    // String title
    test('to test the property `title`', () async {
      // TODO
    });

    // Actual event summary; MESSAGES contains a short single-line message preview, capped at 320 display characters. Attachment and product-only messages use a type summary. Private contacts and attachment details are excluded. Mobile push displays this title and bounded summary after queued recipient authorization.
    // String body
    test('to test the property `body`', () async {
      // TODO
    });

    // bool mandatory
    test('to test the property `mandatory`', () async {
      // TODO
    });

    // A non-null timestamp identifies a read notice, which is retained but no longer listed in the recipient's inbox. Required notices remain stored and authorized deep links remain available.
    // String readAt
    test('to test the property `readAt`', () async {
      // TODO
    });

    // String createdAt
    test('to test the property `createdAt`', () async {
      // TODO
    });

  });
}
