# materyalph_api_client.model.CartItemCreate

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**listingVariantId** | **String** |  |
**expectedPriceVersionId** | **String** | The price version shown to the Buyer; a newer one returns 409 PRICE_CHANGED. |
**quantity** | **String** |  |
**fulfillmentMethod** | **String** |  | [optional]
**locationId** | **String** |  | [optional]
**latitude** | **double** |  | [optional]
**longitude** | **double** |  | [optional]
**originSource** | **String** |  | [optional]
**radiusKm** | **int** |  | [optional]
**workPackageLineId** | **String** | Work Package line this purchase covers; same material and unit only (422 MISSING_LINE_TAG_INVALID), at most the line quantity (422 TAGGED_QUANTITY_EXCEEDS_REQUIREMENT). The server scopes it from the package site at the fixed 50 km Project-Based radius, ignoring any radius_km sent. It never stacks: adding the same product again keeps the larger quantity. | [optional]
**allowPartialStock** | **bool** | With work_package_line_id: add what the store can confirm when it holds less than quantity, instead of failing with QUANTITY_UNAVAILABLE. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


