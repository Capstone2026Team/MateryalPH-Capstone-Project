# materyalph_api_client.model.ConversationView

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**purpose** | **String** |  |
**contextType** | **String** |  |
**orderId** | **String** |  | [optional]
**lockVersion** | **int** |  |
**store** | [**ChatStore**](ChatStore.md) |  |
**handler** | [**ChatIdentity**](ChatIdentity.md) |  | [optional]
**unreadCount** | **int** |  |
**channel** | **String** |  |
**lockedReference** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**updatedAt** | **String** |  |
**canTransfer** | **bool** |  |
**canListFulfillmentConversations** | **bool** | Current vendor Owner or Store Manager may list this sales inquiry buyer's fulfillment conversations. False for other roles and fulfillment threads. | [optional]
**mainConversationId** | **String** | Currently authorized Item-Based main conversation for this Buyer and Store. Null if the viewer cannot access it or this is a fulfillment thread. | [optional]
**projectInquiryCount** | **int** | Number of currently authorized open project quotation inquiries for this Buyer and Store, using the project-inquiries list filter. | [optional]
**projectUnreadCount** | **int** | Received unread messages across all currently authorized open project quotation inquiries, including every page. Opening the main thread does not mark these messages read. | [optional]
**inquiryLabel** | **String** | Work Package name for a project inquiry, or Item inquiry for the main thread. | [optional]
**fulfillmentUnreadCount** | **int** | Unread received messages across every fulfillment conversation for this inquiry buyer and store, including history and all pages. Zero unless can_list_fulfillment_conversations is true. Does not include sales messages or mark messages read. | [optional]
**fulfillmentEntryEnabled** | **bool** |  |
**readOnly** | **bool** |  |
**readOnlyReason** | **String** |  | [optional]
**orderReference** | **String** |  | [optional]
**buyer** | [**ChatIdentity**](ChatIdentity.md) |  | [optional]
**lastMessagePreview** | **String** |  | [optional]
**latestProductId** | **String** |  | [optional]
**canonicalConversationId** | **String** |  | [optional]
**legacyConversationIds** | **BuiltList&lt;String&gt;** |  | [optional]
**legacyHasMore** | **bool** |  | [optional]
**legacyPage** | **int** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


