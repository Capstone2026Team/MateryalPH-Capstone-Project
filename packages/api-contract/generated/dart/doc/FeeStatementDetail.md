# materyalph_api_client.model.FeeStatementDetail

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**reference** | **String** |  |
**state** | **String** |  |
**overdue** | **bool** |  |
**periodStart** | **String** |  |
**periodEnd** | **String** |  |
**issuedOn** | **String** |  |
**dueOn** | **String** |  |
**chargesCentavos** | **int** |  |
**creditsCentavos** | **int** |  |
**paidCentavos** | **int** |  |
**outstandingCentavos** | **int** |  |
**disputedHeldCentavos** | **int** |  |
**lockVersion** | **int** |  |
**sampleNotice** | **String** |  |
**lines** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**payments** | [**BuiltList&lt;PaymentAttempt&gt;**](PaymentAttempt.md) |  |
**channels** | [**BuiltList&lt;PaymentChannelOption&gt;**](PaymentChannelOption.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


