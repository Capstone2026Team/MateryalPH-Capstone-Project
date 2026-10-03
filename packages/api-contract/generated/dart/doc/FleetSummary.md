# materyalph_api_client.model.FleetSummary

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**configurations** | **int** | Saved configurations excluding removed records. |
**totalVehicles** | **int** | Vehicle units in saved nonremoved configurations. |
**activeVehicles** | **int** | Vehicle units in enabled nonremoved configurations. |
**availableVehicles** | **int** | Vehicle units in enabled nonremoved configurations marked available. Does not imply eligibility or absence of delivery assignments. |
**outForDeliveryVehicleAssignments** | **int** | Sum of number_of_vehicles per confirmed snapshot entry on this Vendor's DELIVERY orders with order_state OUT_FOR_DELIVERY. Repeated assignments count separately. |
**outForDeliveryOrders** | **int** | Distinct OUT_FOR_DELIVERY orders contributing confirmed vehicle assignments. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


