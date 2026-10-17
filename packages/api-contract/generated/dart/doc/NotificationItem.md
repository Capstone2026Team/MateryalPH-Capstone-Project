# materyalph_api_client.model.NotificationItem

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**category** | **String** |  |
**title** | **String** | Actual event title. MESSAGES identifies the public sender display name and store name. |
**body** | **String** | Actual event summary; MESSAGES contains a short single-line message preview, capped at 320 display characters. Attachment and product-only messages use a type summary. Private contacts and attachment details are excluded. Mobile push displays this title and bounded summary after queued recipient authorization. |
**mandatory** | **bool** |  |
**readAt** | **String** | A non-null timestamp identifies a read notice, which is retained but no longer listed in the recipient's inbox. Required notices remain stored and authorized deep links remain available. |
**createdAt** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


