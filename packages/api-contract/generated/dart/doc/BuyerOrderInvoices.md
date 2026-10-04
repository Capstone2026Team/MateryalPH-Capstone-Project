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
**canRequestCopy** | **bool** |  |
**canRequestCorrection** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


