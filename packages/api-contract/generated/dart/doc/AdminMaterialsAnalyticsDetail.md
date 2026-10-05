# materyalph_api_client.model.AdminMaterialsAnalyticsDetail

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
**group** | [**AdminMaterialsAnalyticsDetailGroup**](AdminMaterialsAnalyticsDetailGroup.md) |  |
**variants** | [**BuiltList&lt;ComparableVariant&gt;**](ComparableVariant.md) |  |
**series** | [**BuiltList&lt;AdminAnalyticsPoint&gt;**](AdminAnalyticsPoint.md) |  |
**canInspectSources** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


