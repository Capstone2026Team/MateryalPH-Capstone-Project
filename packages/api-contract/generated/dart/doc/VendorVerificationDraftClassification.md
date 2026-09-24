# materyalph_api_client.model.VendorVerificationDraftClassification

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**supplierType** | **String** | WHOLESALER_DISTRIBUTOR or RETAIL_HARDWARE_STORE or SPECIALIZED_SUPPLIER. | [optional]
**niches** | **BuiltList&lt;String&gt;** |  | [optional]
**customLabel** | **String** | Legacy single label; used when custom_labels is omitted. | [optional]
**customLabels** | **BuiltSet&lt;String&gt;** | Vendor-provided labels for Other Category, kept separate from canonical taxonomy. Returned in onboarding classification; legacy custom_label mirrors the first label. Empty when Other Category is not selected. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


