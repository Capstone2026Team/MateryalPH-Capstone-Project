# materyalph_api_client.model.ChatRealtime

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**inboxChannel** | **String** | Viewer-bound inbox invalidation channel. Notification realtime also supports Admin accounts through a dedicated notifications channel. Re-fetch configuration on reconnect. No message or notification contents are broadcast. Authorized Team Tracking viewers also receive payload-free team.activity.changed invalidations on messaging inbox channels; activity details require the separately authorized Vendor team activity endpoint. | [optional]
**enabled** | **bool** |  |
**key** | **String** |  | [optional]
**host** | **String** |  | [optional]
**port** | **int** |  |
**scheme** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


