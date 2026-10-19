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
**fulfillmentMethod** | **String** | The concrete method this view is priced for: DELIVERY or PICKUP. For a Both package it is the Vendor's preferred method until the Buyer picks one. A supplier quotation containing ready-mixed concrete uses DELIVERY only, even when the Work Package requests pickup. |
**fulfillmentOptions** | **BuiltList&lt;String&gt;** | Methods this Vendor offers for the package. More than one means the Buyer must send `fulfillment_method` when inquiring or selecting; selection-preview re-prices for the chosen method. Ready-mixed concrete restricts its supplier quotation to DELIVERY. | [optional]
**paymentMethod** | **String** |  |
**delivery** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**destination** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**expiresAt** | **String** |  |
**stale** | **bool** |  |
**label** | **String** |  |
**currentQuotationState** | **String** |  |
**isFavorite** | **bool** | The Buyer saved this store as a preferred seller. | [optional]
**fulfillment** | [**ProjectFulfillment**](ProjectFulfillment.md) |  |
**paymentMethods** | [**BuiltList&lt;ProjectPaymentMethod&gt;**](ProjectPaymentMethod.md) |  | [optional]
**draftGroups** | [**BuiltList&lt;ProjectDraftVendorGroup&gt;**](ProjectDraftVendorGroup.md) | Draft supplementary items by supplying Vendor, including automatic exact-match defaults. Defaults are saved during selection preview; explicit removals and replacements are preserved. Independent of the regular cart. | [optional]
**primaryOrderId** | **String** |  | [optional]
**procurementMaterialsCentavos** | **int** | Primary and supplementary materials, including existing linked purchases. | [optional]
**separateDeliveryCentavos** | **int** | Delivery for supplementary suppliers and linked orders, counted once per order or draft supplier. Null while any fee needs review. | [optional]
**procurementDeliveryCentavos** | **int** | Delivery for the primary Vendor and all separate suppliers. Null while any fee needs review. | [optional]
**procurementBudgetLabel** | **String** | Work Package budget status for the complete procurement total. | [optional]
**procurementTotalCentavos** | **int** | Materials and each supplying Vendor delivery counted once. Null while any delivery remains unconfirmed or unavailable. Processing fees are excluded until payment. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


