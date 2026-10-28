# materyalph_api_client.model.ChatDraftContent

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**message** | **String** | Optional message to the Buyer, published with the quotation. | [optional]
**lines** | [**BuiltList&lt;ChatDraftLine&gt;**](ChatDraftLine.md) |  |
**fulfillmentMethod** | **String** |  |
**paymentMethod** | **String** | Legacy editor preference, ignored. The Buyer selects payment before accepting the quotation. | [optional]
**fulfillmentDate** | **String** | May be empty in an autosaved draft; a current or future date is required for publication. | [optional]
**deadlineHours** | **int** |  | [optional] [default to 24]
**vendorDiscountCentavos** | **int** | Legacy fixed materials discount. Omit when discount is supplied. | [optional]
**discount** | [**ChatQuotationDiscount**](ChatQuotationDiscount.md) |  | [optional]
**destination** | [**ChatQuotationDestination**](ChatQuotationDestination.md) |  | [optional]
**delivery** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Vehicles, counts, trips, arrangement and access confirmations. Set fee_override to true with a 10-2000 character change_reason to propose a manual gross fee; eligibility, route and capacity checks still apply. | [optional]
**nrpc** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Historical drafts only. Omit when saving; new quotation NRPC is prohibited. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


