# materyalph_api_client.model.ListingSearchResult

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**listingId** | **String** |  |
**variantId** | **String** | The listing's best variant under the active sort. |
**rank** | **int** |  |
**displayName** | **String** |  |
**brand** | **String** |  |
**category** | [**ListingCategoryRef**](ListingCategoryRef.md) |  |
**variantLabel** | **String** |  |
**optionsCount** | **int** |  |
**image** | [**ListingImage**](ListingImage.md) |  |
**price** | [**ListingPrice**](ListingPrice.md) |  |
**comparable** | [**ComparableStatus**](ComparableStatus.md) |  |
**stockLabel** | **String** |  |
**stockConfirmedAt** | [**DateTime**](DateTime.md) |  |
**productRating** | [**ProductRatingSummary**](ProductRatingSummary.md) |  |
**unitsSold** | **String** | Quantity on completed orders. |
**distanceMeters** | **int** | Geodesic straight-line distance to the store. |
**badges** | **BuiltList&lt;String&gt;** |  |
**isFavorite** | **bool** |  |
**vendor** | [**ListingVendorCard**](ListingVendorCard.md) |  |
**fulfillment** | [**ListingFulfillmentSummary**](ListingFulfillmentSummary.md) |  |
**ranking** | [**RankingExplanation**](RankingExplanation.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


