# materyalph_api_client.model.WorkPackageBudgetEstimate

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**deliveryCentavos** | **int** | Actual route/vehicle estimate for a representative exact-match supplier plan, consolidated per supplier. Zero for pickup-only supplies; ready-mixed concrete includes mixer delivery even under PICKUP. Null when delivery or supplier availability needs review. | [optional]
**estimatedTotalCentavos** | **int** | Average eligible material prices plus applicable supplier delivery. Null until every material and delivery fee can be estimated. | [optional]
**deliveryStatus** | **String** |  | [optional]
**deliveryIssues** | **BuiltList&lt;String&gt;** |  | [optional]
**fulfillmentMethod** | **String** | Both is budgeted using the Site Delivery scenario. | [optional]
**lines** | [**BuiltList&lt;WorkPackageBudgetEstimateLine&gt;**](WorkPackageBudgetEstimateLine.md) |  |
**materialsTotalCentavos** | **int** |  |
**pricedLineCount** | **int** |  |
**unpricedLineCount** | **int** |  |
**radiusKm** | **int** |  |
**basis** | **String** |  |
**excludes** | **BuiltList&lt;String&gt;** |  |
**computedAt** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


