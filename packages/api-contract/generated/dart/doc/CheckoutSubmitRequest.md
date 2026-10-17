# materyalph_api_client.model.CheckoutSubmitRequest

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**cartLockVersion** | **int** |  |
**vendorIds** | **BuiltSet&lt;String&gt;** |  |
**splitConfirmed** | **bool** | Required when fewer Vendor groups are submitted than the cart holds. | [optional]
**workPackageId** | **String** | Optional owned open Work Package under an Active Project. Each submitted child remains ITEM_BASED and contributes to its budget; this does not fulfill missing lines or select the Project Vendor. Tagged cart lines must belong to this version. | [optional]
**workPackageLockVersion** | **int** | Required with work_package_id; stale versions return PROJECT_VERSION_CONFLICT (409). | [optional]
**budgetOverrideReason** | **String** | Explicit Buyer acknowledgement when the combined submitted amount exceeds the Project or Work Package budget. Final acceptance rechecks committed spend. | [optional]
**invoiceDetails** | [**CheckoutInvoiceDetails**](CheckoutInvoiceDetails.md) |  | [optional]
**paymentMethods** | **BuiltMap&lt;String, String&gt;** | Vendor id => chosen method; Online when omitted. COD pairs with Site Delivery, In-Store with Self-Pickup, each only when the Vendor enabled it. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


