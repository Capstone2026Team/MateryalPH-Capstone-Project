# materyalph_api_client.model.AdminVendorVerificationQueueEnvelope

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**data** | [**BuiltList&lt;AdminVendorVerificationQueueItem&gt;**](AdminVendorVerificationQueueItem.md) |  |
**meta** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Pagination, region options and status_counts: case counts per review status (PENDING_VERIFICATION, CHANGES_REQUIRED, REJECTED, APPROVED, EXPIRED) under every active filter except status. |
**errors** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


