# materyalph_api_client.model.VendorTeamFulfillmentPerformance

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**assigned** | **int** |  |
**active** | **int** | Orders currently assigned and still being fulfilled. |
**handovers** | **int** | DELIVERED or PICKED_UP milestones recorded by this member. |
**onTime** | **int** | Handovers on or before the order's expected fulfillment date (Asia/Manila). |
**onTimeMeasured** | **int** | Handovers whose order has an expected fulfillment date. |
**milestones** | **int** |  |
**proofs** | **int** |  |
**vehicleIssues** | **int** |  |
**conversations** | **int** |  |
**messages** | **int** |  |
**awaitingReply** | **int** |  |
**reply** | [**VendorTeamReplyTime**](VendorTeamReplyTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


