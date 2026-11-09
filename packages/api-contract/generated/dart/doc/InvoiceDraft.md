# materyalph_api_client.model.InvoiceDraft

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**invoiceType** | **String** |  |
**issuerName** | **String** | Must equal the registered business name. |
**invoiceNumber** | **String** |  |
**issuedOn** | [**Date**](Date.md) | Invoice calendar date; must not be later than today in Asia/Manila. |
**amountCentavos** | **int** |  |
**vatCentavos** | **int** |  | [optional]
**vatExemptCentavos** | **int** |  | [optional]
**zeroRatedCentavos** | **int** |  | [optional]
**relatedLineIds** | **BuiltList&lt;String&gt;** |  | [optional]
**sourceSystem** | **String** |  |
**invoicingMethod** | **String** |  |
**amendsInvoiceRecordId** | **String** |  | [optional]
**invoiceRequestId** | **String** |  | [optional]
**lockVersion** | **int** |  |
**id** | **String** |  |
**sentRecordId** | **String** |  | [optional]
**sentAt** | [**DateTime**](DateTime.md) |  | [optional]
**updatedAt** | [**DateTime**](DateTime.md) |  | [optional]
**fileName** | **String** |  | [optional]
**contentType** | **String** |  | [optional]
**fileSizeBytes** | **int** |  | [optional]
**download** | [**DisputeFileLink**](DisputeFileLink.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


