import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ConversationView
void main() {
  final instance = ConversationViewBuilder();
  // TODO add properties to the builder and call build()

  group(ConversationView, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String purpose
    test('to test the property `purpose`', () async {
      // TODO
    });

    // String contextType
    test('to test the property `contextType`', () async {
      // TODO
    });

    // String orderId
    test('to test the property `orderId`', () async {
      // TODO
    });

    // int lockVersion
    test('to test the property `lockVersion`', () async {
      // TODO
    });

    // ChatStore store
    test('to test the property `store`', () async {
      // TODO
    });

    // ChatIdentity handler
    test('to test the property `handler`', () async {
      // TODO
    });

    // int unreadCount
    test('to test the property `unreadCount`', () async {
      // TODO
    });

    // String channel
    test('to test the property `channel`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> lockedReference
    test('to test the property `lockedReference`', () async {
      // TODO
    });

    // String updatedAt
    test('to test the property `updatedAt`', () async {
      // TODO
    });

    // bool canTransfer
    test('to test the property `canTransfer`', () async {
      // TODO
    });

    // Current vendor Owner or Store Manager may list this sales inquiry buyer's fulfillment conversations. False for other roles and fulfillment threads.
    // bool canListFulfillmentConversations
    test('to test the property `canListFulfillmentConversations`', () async {
      // TODO
    });

    // Currently authorized Item-Based main conversation for this Buyer and Store. Null if the viewer cannot access it or this is a fulfillment thread.
    // String mainConversationId
    test('to test the property `mainConversationId`', () async {
      // TODO
    });

    // Number of currently authorized open project quotation inquiries for this Buyer and Store, using the project-inquiries list filter.
    // int projectInquiryCount
    test('to test the property `projectInquiryCount`', () async {
      // TODO
    });

    // Received unread messages across all currently authorized open project quotation inquiries, including every page. Opening the main thread does not mark these messages read.
    // int projectUnreadCount
    test('to test the property `projectUnreadCount`', () async {
      // TODO
    });

    // Work Package name for a project inquiry, or Item inquiry for the main thread.
    // String inquiryLabel
    test('to test the property `inquiryLabel`', () async {
      // TODO
    });

    // Unread received messages across every fulfillment conversation for this inquiry buyer and store, including history and all pages. Zero unless can_list_fulfillment_conversations is true. Does not include sales messages or mark messages read.
    // int fulfillmentUnreadCount
    test('to test the property `fulfillmentUnreadCount`', () async {
      // TODO
    });

    // bool fulfillmentEntryEnabled
    test('to test the property `fulfillmentEntryEnabled`', () async {
      // TODO
    });

    // bool readOnly
    test('to test the property `readOnly`', () async {
      // TODO
    });

    // String readOnlyReason
    test('to test the property `readOnlyReason`', () async {
      // TODO
    });

    // String orderReference
    test('to test the property `orderReference`', () async {
      // TODO
    });

    // ChatIdentity buyer
    test('to test the property `buyer`', () async {
      // TODO
    });

    // String lastMessagePreview
    test('to test the property `lastMessagePreview`', () async {
      // TODO
    });

    // String latestProductId
    test('to test the property `latestProductId`', () async {
      // TODO
    });

    // String canonicalConversationId
    test('to test the property `canonicalConversationId`', () async {
      // TODO
    });

    // BuiltList<String> legacyConversationIds
    test('to test the property `legacyConversationIds`', () async {
      // TODO
    });

    // bool legacyHasMore
    test('to test the property `legacyHasMore`', () async {
      // TODO
    });

    // int legacyPage
    test('to test the property `legacyPage`', () async {
      // TODO
    });

  });
}
