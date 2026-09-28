# materyalph_api_client.model.AutoAcceptPolicy

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | [**AutoAcceptStatus**](AutoAcceptStatus.md) |  |
**enabled** | **bool** |  |
**paused** | **bool** |  |
**pauseReason** | **String** |  |
**pausedAt** | **String** |  |
**allotmentQuantity** | **String** | Whole-number allotment last set. |
**remainingAllotmentQuantity** | **String** | Whole units still available to auto-accept. |
**maxUnitCount** | **String** | Independent per-order unit safeguard; null means no unit cap. |
**maxOrderAmountCentavos** | **int** | Independent Buyer commercial total safeguard; null means no amount cap. |
**currentVersion** | **int** |  |
**lockVersion** | **int** |  |
**updatedAt** | **String** |  |
**lastEditor** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


