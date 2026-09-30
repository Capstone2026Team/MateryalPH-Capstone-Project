# materyalph_api_client.model.OrderLine

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**lineNumber** | **int** |  |
**listingId** | **String** |  |
**listingVariantId** | **String** |  |
**displayName** | **String** |  |
**variantLabel** | **String** |  |
**brand** | **String** |  |
**category** | **String** |  |
**image** | [**ListingImage**](ListingImage.md) |  |
**unitCode** | **String** |  |
**unitName** | **String** |  |
**unitPrecision** | **int** |  |
**quantityStep** | **String** |  |
**requestedQuantity** | **String** |  |
**confirmedQuantity** | **String** | Null until a Vendor version exists. |
**unitPriceCentavos** | **int** | Frozen submission price with the frozen volume tier re-applied to the confirmed quantity. |
**ordinaryUnitPriceCentavos** | **int** |  |
**volumeTierApplied** | **bool** |  |
**volumeTiers** | [**BuiltList&lt;OrderVolumeTier&gt;**](OrderVolumeTier.md) |  |
**grossCentavos** | **int** |  |
**discountCentavos** | **int** |  |
**lineTotalCentavos** | **int** |  |
**includedVatCentavos** | **int** |  |
**taxCategory** | [**TaxCategory**](TaxCategory.md) |  |
**vatLabel** | **String** |  |
**change** | **String** |  |
**priceVersionId** | **String** |  |
**inventory** | [**OrderLineInventory**](OrderLineInventory.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


