# materyalph_api_client.model.VendorProductAnalytics

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**generatedAt** | [**DateTime**](DateTime.md) |  |
**period** | [**ProductAnalyticsPeriod**](ProductAnalyticsPeriod.md) |  |
**access** | [**VendorProductAnalyticsAccess**](VendorProductAnalyticsAccess.md) |  |
**definitions** | **BuiltMap&lt;String, String&gt;** |  |
**tracking** | [**ProductAnalyticsTracking**](ProductAnalyticsTracking.md) |  |
**kpis** | [**VendorProductAnalyticsKpis**](VendorProductAnalyticsKpis.md) |  |
**series** | [**BuiltList&lt;ProductAnalyticsSeriesPoint&gt;**](ProductAnalyticsSeriesPoint.md) |  |
**forecast** | [**VendorProductAnalyticsForecast**](VendorProductAnalyticsForecast.md) |  |
**topSelling** | [**BuiltList&lt;ProductAnalyticsRow&gt;**](ProductAnalyticsRow.md) |  |
**topPerforming** | [**BuiltList&lt;ProductAnalyticsRow&gt;**](ProductAnalyticsRow.md) |  |
**mostViewed** | [**BuiltList&lt;ProductAnalyticsRow&gt;**](ProductAnalyticsRow.md) |  |
**topRated** | [**BuiltList&lt;ProductAnalyticsRatedProduct&gt;**](ProductAnalyticsRatedProduct.md) | Up to five products ranked by all-time visible Product Quality average descending, count descending, then listing ID ascending, independent of the selected period. Null without reviews.view; an empty array means no rated published products. Uses the same blind-reveal, moderation, active-dispute and score-exclusion gates as Buyer product averages. | [optional]
**categories** | [**BuiltList&lt;VendorProductAnalyticsCategoriesInner&gt;**](VendorProductAnalyticsCategoriesInner.md) |  |
**segments** | [**ProductAnalyticsSegments**](ProductAnalyticsSegments.md) |  |
**basketRules** | [**VendorProductAnalyticsBasketRules**](VendorProductAnalyticsBasketRules.md) |  |
**suggestions** | [**BuiltList&lt;ProductAnalyticsSuggestion&gt;**](ProductAnalyticsSuggestion.md) |  |
**products** | [**VendorProductAnalyticsProducts**](VendorProductAnalyticsProducts.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


