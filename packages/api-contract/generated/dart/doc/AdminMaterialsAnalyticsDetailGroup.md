# materyalph_api_client.model.AdminMaterialsAnalyticsDetailGroup

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
**startPoint** | [**AdminAnalyticsPoint**](AdminAnalyticsPoint.md) |  |
**endPoint** | [**AdminAnalyticsPoint**](AdminAnalyticsPoint.md) |  |
**trend** | [**AnalyticsTrend**](AnalyticsTrend.md) |  |
**current** | [**AnalyticsCurrentCounts**](AnalyticsCurrentCounts.md) |  |
**image** | [**ListingImage**](ListingImage.md) | Photo of the cheapest current in-scope offer that has one, present only with materials_analytics.inspect_sources and null otherwise. Never its listing or store identity. | [optional]
**description** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


