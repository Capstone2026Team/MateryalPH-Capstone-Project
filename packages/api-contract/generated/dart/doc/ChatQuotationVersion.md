# materyalph_api_client.model.ChatQuotationVersion

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**requestedChanges** | **String** | Buyer's exact recorded counter-offer for this version, retained after revision. Omitted when no changes were requested. Only visible to authorized conversation participants. | [optional]
**changeRequestedAt** | **String** | UTC ISO 8601 timestamp of the recorded counter-offer for this version. | [optional]
**vendorResponseDueAt** | **String** | Exact recorded UTC ISO 8601 deadline for the Vendor to revise and republish. Historical requests retain their original deadline; it is active only while the version is current and COUNTERED. | [optional]
**availablePaymentMethods** | **BuiltSet&lt;String&gt;** | Currently available Buyer choices for this quotation's fulfillment, subject to Vendor settings. Revalidated at acceptance. | [optional]
**selectedPaymentMethod** | **String** | The Buyer's recorded method from the accepted order, including historical accepted quotations. | [optional]
**id** | **String** |  |
**version** | **int** |  |
**latest** | **bool** |  |
**state** | **String** |  |
**publishedAt** | **String** |  |
**expiresAt** | **String** |  |
**contentHash** | **String** |  |
**content** | [**ChatQuotationContent**](ChatQuotationContent.md) |  |
**viewed** | **bool** |  |
**actions** | **BuiltList&lt;String&gt;** |  |
**quotationId** | **String** |  | [optional]
**acceptedOrderId** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


