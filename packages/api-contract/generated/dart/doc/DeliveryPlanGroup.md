# materyalph_api_client.model.DeliveryPlanGroup

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **String** |  |
**label** | **String** |  |
**status** | **String** |  |
**manualReviewReasons** | **BuiltList&lt;String&gt;** |  |
**candidates** | [**BuiltList&lt;DeliveryPlanVehicle&gt;**](DeliveryPlanVehicle.md) |  |
**manualReviewVehicles** | [**BuiltList&lt;DeliveryPlanVehicle&gt;**](DeliveryPlanVehicle.md) | Configured vehicles permitted for a recorded Owner or Store Manager manual load review, including an automatic dimensional-fit rejection. Availability, material compatibility, known payload, route range and access still apply. Trip counts cover known payload or mixer volume only and do not prove cargo fit. Empty outside MANUAL_REVIEW_REQUIRED; automatic candidates remain separate. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


