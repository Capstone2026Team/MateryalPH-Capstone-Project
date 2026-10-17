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
**attributeLabels** | [**BuiltList&lt;ListingAttributeLabel&gt;**](ListingAttributeLabel.md) | The category's names for listing and variant technical attributes, in category order; the same labels a Work Package quotation shows. | [optional]
**images** | [**BuiltList&lt;ListingImage&gt;**](ListingImage.md) |  |
**readyMixedConcrete** | [**ReadyMixedConcreteDetail**](ReadyMixedConcreteDetail.md) | Present only for ready-mixed concrete; Self-Pickup is then never available. | [optional]
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


