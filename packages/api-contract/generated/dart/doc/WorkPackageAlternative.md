# materyalph_api_client.model.WorkPackageAlternative

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**listingId** | **String** |  |
**variantId** | **String** |  |
**priceVersionId** | **String** |  |
**displayName** | **String** |  |
**variantLabel** | **String** |  | [optional]
**brand** | **String** |  | [optional]
**vendorId** | **String** |  |
**storeName** | **String** |  | [optional]
**image** | [**ListingImage**](ListingImage.md) | First public photo of the listing. The server returns an object ({url, alt_text}); declaring it as a string made the generated client reject any page containing a photographed offer, which surfaced as a generic 'Something went wrong' instead of the recommendations. | [optional]
**unitPriceCentavos** | **int** |  |
**unitCode** | **String** |  |
**unitPrecision** | **int** |  |
**distanceMeters** | **int** |  |
**stockLabel** | **String** | Availability label only; exact inventory is never returned. |
**specifications** | [**BuiltList&lt;ProjectSpecificationDetail&gt;**](ProjectSpecificationDetail.md) | Listing and variant details as the category names them. | [optional]
**exactMatch** | **bool** | Brand (when set) and every stated specification match the Work Package line. |
**availability** | **String** | Whether the store can confirm the whole quantity still needed. PARTIAL stores can be added with `allow_partial_stock` for what they can confirm. |
**estimatedTotalCentavos** | **int** | Unit price times the quantity still needed. |
**fulfillmentMethods** | **BuiltList&lt;String&gt;** | Methods the store can serve for this product. Ready-mixed concrete uses DELIVERY only even when the primary quotation or package uses PICKUP. |
**alreadyAdded** | **bool** | This product is already in the cart or an open order for the line; adding it again never stacks the quantity. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


