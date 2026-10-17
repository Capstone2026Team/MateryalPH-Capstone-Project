# materyalph_api_client.model.OrderConfirmedDelivery

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**systemRecommendation** | [**BuiltList&lt;DeliveryEstimateOption&gt;**](DeliveryEstimateOption.md) |  | [optional]
**recommendationChanged** | **bool** |  | [optional]
**changeReason** | **String** | Vendor explanation shown before Buyer approval and payment. Includes manual load review when no automatic fit was available. | [optional]
**vehicles** | [**BuiltList&lt;OrderDeliveryVehicle&gt;**](OrderDeliveryVehicle.md) |  |
**distanceMeters** | **int** |  |
**routeSource** | **String** |  |
**basis** | **String** |  |
**endpoint** | **String** |  |
**heavyVehicleRestriction** | **bool** |  |
**intended** | [**OrderPoint**](OrderPoint.md) |  |
**alternateDropOff** | [**OrderPoint**](OrderPoint.md) |  |
**finalFeeCentavos** | **int** |  |
**fulfillmentDate** | [**Date**](Date.md) |  |
**arrangement** | **String** |  |
**calculationVersion** | **String** |  |
**confirmedByRole** | **String** |  |
**confirmedAt** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


