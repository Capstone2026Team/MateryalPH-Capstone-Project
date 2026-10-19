# materyalph_api_client.model.WorkPackageInput

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lockVersion** | **int** |  | [optional]
**name** | **String** |  |
**description** | **String** |  | [optional]
**budgetCentavos** | **int** |  |
**siteId** | **String** |  |
**radiusKm** | **int** | Optional. 50 km is the only Project-Based vendor-selection radius; the server applies it whether or not it is sent. | [optional]
**fulfillmentMethod** | **String** | BOTH means the Buyer is open to either. The scan lists every Vendor offering Site Delivery, Self-Pickup or both; each candidate then lists its `fulfillment_options` and the Buyer picks one when inquiring or selecting. BOTH requires `payment_method` ONLINE and the delivery details (`site_contact`, `access_instructions`, `heavy_vehicle_restriction`). |
**paymentMethod** | **String** | Optional legacy value. New authoring omits payment; it is explicitly chosen in the selection checklist. | [optional]
**siteContact** | **String** |  | [optional]
**heavyVehicleRestriction** | **String** |  | [optional]
**alternateDropOffLocationId** | **String** |  | [optional]
**accessInstructions** | **String** |  | [optional]
**lines** | [**BuiltList&lt;WorkPackageLineInput&gt;**](WorkPackageLineInput.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


