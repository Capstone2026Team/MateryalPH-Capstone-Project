# materyalph_api_client.model.DeliveryPreview

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** |  |
**issues** | [**BuiltList&lt;CartIssue&gt;**](CartIssue.md) |  |
**endpoint** | **String** |  |
**route** | [**DeliveryRoute**](DeliveryRoute.md) |  |
**straightLineMeters** | **int** |  |
**coverageKm** | **int** |  |
**estimate** | [**DeliveryEstimate**](DeliveryEstimate.md) |  |
**manualReviewReasons** | **BuiltList&lt;String&gt;** |  |
**confirmedOffer** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Always null in a preview; an authorized confirmed offer exists only after Vendor confirmation. |
**calculationVersion** | **String** |  |
**notice** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


