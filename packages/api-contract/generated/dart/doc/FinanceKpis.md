# materyalph_api_client.model.FinanceKpis

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**label** | **String** |  |
**scenario** | **String** |  |
**period** | [**FinanceKpisPeriod**](FinanceKpisPeriod.md) |  |
**commerce** | [**BuiltList&lt;FinanceKpi&gt;**](FinanceKpi.md) |  |
**finance** | [**BuiltList&lt;FinanceKpi&gt;**](FinanceKpi.md) |  |
**counts** | **BuiltMap&lt;String, int&gt;** |  |
**trend** | [**BuiltList&lt;CommissionTrendPoint&gt;**](CommissionTrendPoint.md) |  | [optional]
**trendGranularity** | **String** | DAY when the recorded range spans at most 92 days (empty days are zero-filled); otherwise MONTH, recorded months only. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


