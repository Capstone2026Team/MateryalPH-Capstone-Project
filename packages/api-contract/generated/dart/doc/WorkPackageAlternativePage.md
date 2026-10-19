# materyalph_api_client.model.WorkPackageAlternativePage

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**line** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**status** | **String** | NO_SUITABLE_ALTERNATIVE: no eligible store within the radius can supply the quantity still needed (see `excluded`). COVERED: separate purchases already satisfy the line. A failed request is an error response, never one of these. |
**neededQuantity** | **String** | The quantity still to source: the compared Vendor's gap less the separate purchases that satisfy the line (the full line quantity when no `candidate_id` is sent). |
**excluded** | [**WorkPackageAlternativePageExcluded**](WorkPackageAlternativePageExcluded.md) |  |
**locationId** | **String** | The Project site's saved location, for display only. The server scopes the purchase from the package's locked site point. | [optional]
**radiusKm** | **int** | The fixed Project-Based radius. |
**items** | [**BuiltList&lt;WorkPackageAlternative&gt;**](WorkPackageAlternative.md) |  |
**page** | **int** |  |
**hasMore** | **bool** |  |
**total** | **int** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


