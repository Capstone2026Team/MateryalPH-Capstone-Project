# materyalph_api_client.model.ChatMessage

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**conversationId** | **String** | Original authorized context for files and read receipts, including in a combined Buyer timeline. | [optional]
**id** | **String** |  |
**clientMessageId** | **String** |  |
**body** | **String** |  |
**kind** | **String** |  |
**sender** | [**ChatIdentity**](ChatIdentity.md) |  |
**sentAt** | **String** |  |
**mine** | **bool** |  |
**attachments** | [**BuiltList&lt;ChatAttachment&gt;**](ChatAttachment.md) |  |
**readByRecipient** | **bool** |  |
**product** | [**ChatProduct**](ChatProduct.md) |  | [optional]
**automatedReply** | [**ChatAutomatedReply**](ChatAutomatedReply.md) | Static store reply. SYSTEM messages with this field do not count as human responses. | [optional]
**workPackageAttachment** | [**ChatWorkPackageAttachment**](ChatWorkPackageAttachment.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


