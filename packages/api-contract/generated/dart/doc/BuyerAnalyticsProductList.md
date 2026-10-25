# materyalph_api_client.model.BuyerAnalyticsProductList

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**audience** | **String** |  |
**scope** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**sourceKind** | **String** |  |
**dataset** | [**DatasetLabel**](DatasetLabel.md) |  |
**window** | [**AnalyticsWindow**](AnalyticsWindow.md) |  |
**currentAsOf** | [**DateTime**](DateTime.md) |  |
**snapshot** | [**AnalyticsSnapshotRef**](AnalyticsSnapshotRef.md) |  | [optional]
**updateSchedule** | **String** |  |
**explanation** | **String** |  |
**categories** | [**BuiltList&lt;BuyerAnalyticsCategorySummary&gt;**](BuyerAnalyticsCategorySummary.md) |  |
**items** | [**BuiltList&lt;BuyerAnalyticsProductRow&gt;**](BuyerAnalyticsProductRow.md) |  |
**nextCursor** | **String** |  | [optional]
**notYetComparableListings** | **int** | Current in-scope listings not mapped to any comparable variant, so they are not price-compared. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


