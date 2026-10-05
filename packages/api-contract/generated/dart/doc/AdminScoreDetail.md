# materyalph_api_client.model.AdminScoreDetail

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vendorId** | **String** |  | [optional]
**storeName** | **String** |  | [optional]
**calculated** | **bool** |  | [optional]
**asOf** | [**Date**](Date.md) |  | [optional]
**label** | **String** |  | [optional]
**scores** | [**BuiltList&lt;ScoreMetric&gt;**](ScoreMetric.md) |  | [optional]
**operations** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**badgeMetrics** | [**BuiltList&lt;BadgeMetric&gt;**](BadgeMetric.md) |  | [optional]
**badges** | [**BuiltList&lt;BadgeState&gt;**](BadgeState.md) |  | [optional]
**badgeHistory** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**suppressions** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**exclusions** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**sourceEvents** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**history** | [**BuiltList&lt;ScoreHistoryPoint&gt;**](ScoreHistoryPoint.md) |  | [optional]
**canInvestigate** | **bool** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


