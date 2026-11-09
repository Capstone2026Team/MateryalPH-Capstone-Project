# materyalph_api_client.model.ConversationDetail

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**threadAuthority** | **String** | Opaque authorized-context epoch for the combined Vendor timeline. Discard retained pages when it changes; it is never an authorization credential. | [optional]
**threadContexts** | [**BuiltList&lt;ConversationView&gt;**](ConversationView.md) | Authorized original references used to resolve older messages, quotations, files and receipts within the single chat. No reply-subject selector is shown. | [optional]
**conversation** | [**ConversationView**](ConversationView.md) |  |
**messages** | [**ChatMessagePage**](ChatMessagePage.md) |  |
**quotations** | [**ChatQuotationPage**](ChatQuotationPage.md) |  |
**siteInspections** | [**BuiltList&lt;SiteInspection&gt;**](SiteInspection.md) | The Item-Based conversation's ten most recent free site inspection requests, newest first; empty for other conversations. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


