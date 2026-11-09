# materyalph_api_client.model.InvoiceLogRow

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**buyerName** | **String** | The order Buyer's display name on Vendor DUE rows, including orders without a Buyer invoice request. | [optional]
**id** | **String** |  | [optional]
**orderId** | **String** |  | [optional]
**orderReference** | **String** |  | [optional]
**orderState** | **String** |  | [optional]
**paymentState** | **String** |  | [optional]
**acceptedAt** | [**DateTime**](DateTime.md) |  | [optional]
**openRequest** | **bool** |  | [optional]
**note** | **String** |  | [optional]
**kind** | **String** |  | [optional]
**state** | **String** | Request state; Vendor RECONCILIATION rows also include the pending Buyer correction state, REQUESTED or RETURNED_FOR_CORRECTION. | [optional]
**details** | **String** |  | [optional]
**serviceTargetAt** | [**DateTime**](DateTime.md) |  | [optional]
**serviceTargetLabel** | **String** |  | [optional]
**overdue** | **bool** |  | [optional]
**invoiceType** | **String** |  | [optional]
**issuer** | **String** |  | [optional]
**invoiceNumber** | **String** |  | [optional]
**issuedOn** | **String** |  | [optional]
**amountCentavos** | **int** |  | [optional]
**reconciliationState** | **String** |  | [optional]
**reconciliationDifferenceCentavos** | **int** |  | [optional]
**originLabel** | **String** |  | [optional]
**complianceNote** | **String** |  | [optional]
**vendorName** | **String** |  | [optional]
**downloads** | **int** |  | [optional]
**lastDownloadAt** | [**DateTime**](DateTime.md) |  | [optional]
**uploadedAt** | [**DateTime**](DateTime.md) |  | [optional]
**download** | [**DisputeFileLink**](DisputeFileLink.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


