import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ConversationDetail
void main() {
  final instance = ConversationDetailBuilder();
  // TODO add properties to the builder and call build()

  group(ConversationDetail, () {
    // Opaque authorized-context epoch for the combined Vendor timeline. Discard retained pages when it changes; it is never an authorization credential.
    // String threadAuthority
    test('to test the property `threadAuthority`', () async {
      // TODO
    });

    // Authorized original references used to resolve older messages, quotations, files and receipts within the single chat. No reply-subject selector is shown.
    // BuiltList<ConversationView> threadContexts
    test('to test the property `threadContexts`', () async {
      // TODO
    });

    // ConversationView conversation
    test('to test the property `conversation`', () async {
      // TODO
    });

    // ChatMessagePage messages
    test('to test the property `messages`', () async {
      // TODO
    });

    // ChatQuotationPage quotations
    test('to test the property `quotations`', () async {
      // TODO
    });

    // The Item-Based conversation's ten most recent free site inspection requests, newest first; empty for other conversations.
    // BuiltList<SiteInspection> siteInspections
    test('to test the property `siteInspections`', () async {
      // TODO
    });

  });
}
