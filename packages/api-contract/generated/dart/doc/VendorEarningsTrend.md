# materyalph_api_client.model.VendorEarningsTrend

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**granularity** | **String** |  |
**timezone** | **String** |  |
**from** | [**Date**](Date.md) |  |
**to** | [**Date**](Date.md) |  |
**days** | **int** |  |
**points** | [**BuiltList&lt;VendorEarningsTrendPoint&gt;**](VendorEarningsTrendPoint.md) | One point per day or month in order; a bucket with no records is zero. Empty when the period starts after today. |
**previous** | [**VendorEarningsTrendComparison**](VendorEarningsTrendComparison.md) | Totals of the equal-length period just before this one, for comparison; null when the period is empty. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


