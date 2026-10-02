# materyalph_api_client.model.ProjectCandidate

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**estimateId** | **String** |  |
**vendorId** | **String** |  |
**storeName** | **String** |  |
**rank** | **int** |  |
**latitude** | **num** |  |
**longitude** | **num** |  |
**scoreLabel** | **String** |  |
**vps** | **String** |  | [optional]
**fms** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**complete** | **bool** |  |
**fulfillmentPercent** | **String** |  |
**missingLines** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**lines** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**materialsCentavos** | **int** |  |
**includedVatCentavos** | **int** |  |
**deliveryCentavos** | **int** |  | [optional]
**processingFeeCentavos** | **int** |  | [optional]
**processingFeeStatus** | **String** |  |
**projectedTotalCentavos** | **int** |  | [optional]
**budgetLabel** | **String** |  |
**distanceMeters** | **int** |  |
**distanceBasis** | **String** |  |
**etaSeconds** | **int** |  | [optional]
**fulfillmentMethod** | **String** |  |
**paymentMethod** | **String** |  |
**delivery** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**destination** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**expiresAt** | **String** |  |
**stale** | **bool** |  |
**label** | **String** |  |
**currentQuotationState** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


