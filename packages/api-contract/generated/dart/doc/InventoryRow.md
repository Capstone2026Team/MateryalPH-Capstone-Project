# materyalph_api_client.model.InventoryRow

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**listingVariantId** | **String** |  |
**listingId** | **String** |  |
**listingName** | **String** |  |
**listingStatus** | [**ListingStatus**](ListingStatus.md) |  |
**variantLabel** | **String** |  | [optional]
**sku** | **String** |  |
**unitCode** | **String** |  |
**lockVersion** | **int** | Inventory row version; 0 before the first count. |
**inventory** | [**InventoryBalance**](InventoryBalance.md) |  |
**publicLabel** | [**StockLabel**](StockLabel.md) |  |
**stockConfirmation** | [**StockConfirmationSchedule**](StockConfirmationSchedule.md) |  |
**listingConfirmation** | [**StockConfirmationSchedule**](StockConfirmationSchedule.md) |  |
**price** | [**InventoryPrice**](InventoryPrice.md) |  |
**comparability** | [**InventoryComparability**](InventoryComparability.md) |  |
**autoAccept** | [**AutoAcceptPolicy**](AutoAcceptPolicy.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


