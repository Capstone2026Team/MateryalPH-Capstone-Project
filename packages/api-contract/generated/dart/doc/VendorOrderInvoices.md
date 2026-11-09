# materyalph_api_client.model.VendorOrderInvoices

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**buyerName** | **String** | The order Buyer's display name, available without an invoice request. This is separate from supplied invoice billing details. | [optional]
**orderId** | **String** |  |
**orderReference** | **String** |  |
**status** | **String** |  |
**issuanceNotice** | **String** |  |
**records** | [**BuiltList&lt;InvoiceRecordView&gt;**](InvoiceRecordView.md) |  |
**requests** | [**BuiltList&lt;InvoiceRequestView&gt;**](InvoiceRequestView.md) |  |
**platformDocuments** | [**BuiltList&lt;PlatformDocumentRef&gt;**](PlatformDocumentRef.md) |  |
**billingDetails** | [**VendorInvoiceBillingDetails**](VendorInvoiceBillingDetails.md) |  | [optional]
**canUpload** | **bool** |  |
**canOpenFiles** | **bool** |  |
**issuerName** | **String** |  |
**invoiceTypes** | **BuiltList&lt;String&gt;** |  |
**sourceSystems** | **BuiltList&lt;String&gt;** |  |
**invoicingMethods** | **BuiltList&lt;String&gt;** |  |
**lines** | [**BuiltList&lt;InvoiceOrderLine&gt;**](InvoiceOrderLine.md) |  |
**canSend** | **bool** |  | [optional]
**draft** | [**InvoiceDraft**](InvoiceDraft.md) |  | [optional]
**preset** | [**VendorInvoicePreset**](VendorInvoicePreset.md) |  | [optional]
**orderSummary** | [**InvoiceOrderSummary**](InvoiceOrderSummary.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


