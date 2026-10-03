# materyalph_api_client.model.ListingDetails

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**listingId** | **String** |  |
**publicationVersion** | **int** |  |
**displayName** | **String** |  |
**description** | **String** |  |
**brand** | **String** |  |
**model** | **String** |  |
**manufacturer** | **String** |  |
**countryOfManufacture** | **String** |  |
**category** | [**ListingCategoryRef**](ListingCategoryRef.md) |  |
**technicalAttributes** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**images** | [**BuiltList&lt;ListingImage&gt;**](ListingImage.md) |  |
**compliance** | [**ListingCompliance**](ListingCompliance.md) |  |
**productRating** | [**ProductRatingSummary**](ProductRatingSummary.md) |  |
**unitsSold** | **String** |  |
**isFavorite** | **bool** |  |
**purchasable** | **bool** |  |
**notPurchasableReason** | **String** |  |
**distanceMeters** | **int** |  |
**vendor** | [**ListingDetailVendor**](ListingDetailVendor.md) |  |
**fulfillment** | [**ListingDetailFulfillment**](ListingDetailFulfillment.md) |  |
**variants** | [**BuiltList&lt;ListingVariantOffer&gt;**](ListingVariantOffer.md) |  |
**scope** | [**DiscoveryScope**](DiscoveryScope.md) |  |
**currentAsOf** | [**DateTime**](DateTime.md) |  |
**eligibilityVersion** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


