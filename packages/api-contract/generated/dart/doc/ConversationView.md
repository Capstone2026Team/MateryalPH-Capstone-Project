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


