# materyalph_api_client.model.OrderFulfillment

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**method** | **String** |  |
**state** | **String** |  |
**expectedDate** | **String** |  | [optional]
**late_** | **bool** |  |
**steps** | [**BuiltList&lt;FulfillmentStep&gt;**](FulfillmentStep.md) |  |
**proof** | [**FulfillmentProof**](FulfillmentProof.md) |  | [optional]
**trackingNotice** | **String** |  |
**trips** | [**BuiltList&lt;FulfillmentTrip&gt;**](FulfillmentTrip.md) |  |
**acceptedArrangement** | [**FulfillmentArrangement**](FulfillmentArrangement.md) |  | [optional]
**receipt** | [**FulfillmentReceipt**](FulfillmentReceipt.md) |  |
**issue** | [**FulfillmentIssue**](FulfillmentIssue.md) |  | [optional]
**assignment** | [**FulfillmentAssignment**](FulfillmentAssignment.md) |  | [optional]
**vehicleIssues** | [**BuiltList&lt;FulfillmentVehicleIssue&gt;**](FulfillmentVehicleIssue.md) |  |
**thread** | [**FulfillmentThreadRef**](FulfillmentThreadRef.md) |  |
**nextAction** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


