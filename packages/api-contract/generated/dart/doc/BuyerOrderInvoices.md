# materyalph_api_client.model.BuyerOrderInvoices

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**orderId** | **String** |  |
**orderReference** | **String** |  |
**status** | **String** |  |
**issuanceNotice** | **String** |  |
**records** | [**BuiltList&lt;InvoiceRecordView&gt;**](InvoiceRecordView.md) |  |
**requests** | [**BuiltList&lt;InvoiceRequestView&gt;**](InvoiceRequestView.md) |  |
**platformDocuments** | [**BuiltList&lt;PlatformDocumentRef&gt;**](PlatformDocumentRef.md) |  |
**billingDetails** | [**BuyerInvoiceBillingDetails**](BuyerInvoiceBillingDetails.md) |  | [optional]
**canEditBillingDetails** | **bool** |  |
**canRequestCopy** | **bool** | False once a Vendor sales invoice copy has been sent, including legacy uploaded copies. Corrections remain a separate action. |
**canRequestCorrection** | **bool** |  |
**orderSummary** | [**InvoiceOrderSummary**](InvoiceOrderSummary.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


