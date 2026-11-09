# materyalph_api_client.model.DirectoryBuyerRow

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**name** | **String** |  |
**email** | **String** | Masked for a self-deleted Buyer. |
**status** | **String** |  |
**buyerType** | **String** |  |
**companyName** | **String** |  |
**joinedAt** | [**DateTime**](DateTime.md) |  |
**lastActiveAt** | [**DateTime**](DateTime.md) |  |
**rating** | [**BuyerRatingSummary**](BuyerRatingSummary.md) |  |
**avatarUrl** | **String** | Short-lived viewer-bound URL for the authenticated private Buyer photo endpoint. Null when absent or the Buyer is deleted. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


