# materyalph_api_client.model.DeliveryEstimateOption

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vehicleId** | **String** | Recommended registered vehicle; absent in historical estimates. | [optional]
**loadKey** | **String** |  |
**vehicleName** | **String** |  |
**vehicleType** | **String** |  |
**vehicles** | **int** |  |
**trips** | **int** |  |
**feeCentavos** | **int** | Trip fees plus any mixer mobilization. |
**feePerTripCentavos** | **int** |  |
**mobilizationBasis** | **String** | The Vendor's chosen mixer mobilization basis. | [optional]
**mobilizationFeeCentavos** | **int** |  | [optional]
**mobilizationTotalCentavos** | **int** |  | [optional]
**volumePlan** | [**MixerVolumePlan**](MixerVolumePlan.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


