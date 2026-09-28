# materyalph_api_client.model.PublicStoreProfile

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**vacationMode** | **bool** | True when all new procurement is paused; existing work remains available. |
**publicStoreName** | **String** |  |
**description** | **String** |  |
**publicEmail** | **String** |  |
**publicPhone** | **String** |  |
**operatingSchedule** | [**BuiltList&lt;StoreOperatingDay&gt;**](StoreOperatingDay.md) |  |
**effectiveToday** | [**StoreOperatingDay**](StoreOperatingDay.md) |  |
**effectiveDate** | [**Date**](Date.md) |  |
**effectiveSource** | **String** |  |
**timeZone** | **String** |  |
**logoUrl** | **String** | Validated public media only. |
**bannerUrl** | **String** |  |
**address** | [**PublicAddressSummary**](PublicAddressSummary.md) |  |
**supplierType** | **String** |  |
**niches** | **BuiltList&lt;String&gt;** |  |
**fulfillmentMethod** | **String** |  |
**scoreLabel** | [**ScoreLabel**](ScoreLabel.md) |  |
**hoursStatus** | **String** | UNAVAILABLE shows Hours Unavailable; the store stays visible and hours are never fabricated. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


