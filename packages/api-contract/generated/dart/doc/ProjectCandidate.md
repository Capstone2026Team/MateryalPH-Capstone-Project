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
**lines** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) | One entry per Work Package line. Each line is filled from one specification option and never mixes two. `options` lists every option (ProjectSpecificationDetail `specifications`, lowest unit price, availability label) when there is more than one; `selection_required` is true until the Buyer chooses one, and until then the line is priced on a flagged basis option. Allocations carry `listing_id`, `variant_id`, `variant_label` and labelled `offered_specifications`. |
**selectionRequired** | **bool** | Some line still needs the Buyer's specification choice. | [optional]
**specificationSelections** | **BuiltMap&lt;String, String&gt;** | Choices applied by selection-preview, keyed by line id. | [optional]
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
**isFavorite** | **bool** | The Buyer saved this store as a preferred seller. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


