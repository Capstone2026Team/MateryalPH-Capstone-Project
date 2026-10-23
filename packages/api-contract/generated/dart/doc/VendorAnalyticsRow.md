# materyalph_api_client.model.VendorAnalyticsRow

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**groupId** | **String** |  |
**displayName** | **String** |  |
**material** | [**AnalyticsMaterialRef**](AnalyticsMaterialRef.md) |  |
**category** | [**AnalyticsCategoryRef**](AnalyticsCategoryRef.md) |  |
**specification** | [**ComparableSpecification**](ComparableSpecification.md) |  |
**unit** | [**AnalyticsUnit**](AnalyticsUnit.md) |  |
**startPoint** | [**VendorAnalyticsPoint**](VendorAnalyticsPoint.md) |  |
**endPoint** | [**VendorAnalyticsPoint**](VendorAnalyticsPoint.md) |  |
**trend** | [**AnalyticsTrend**](AnalyticsTrend.md) |  |
**currentCompetitors** | [**VendorCurrentCompetitors**](VendorCurrentCompetitors.md) |  |
**ownOffer** | [**VendorOwnOffer**](VendorOwnOffer.md) |  | [optional]
**image** | [**ListingImage**](ListingImage.md) | The Vendor's own listing photo for this variant, or null. A competitor photo is never returned (MAT-05). | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


