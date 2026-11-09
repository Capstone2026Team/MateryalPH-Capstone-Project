# materyalph_api_client.model.ChatWorkPackageAttachment

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**inquiryId** | **String** | Private quotation linkage used by the attachment action, not a separate user-facing chat subject. | [optional]
**orderId** | **String** |  | [optional]
**orderLockVersion** | **int** |  | [optional]
**reference** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Vendor-scoped read projection of the locked Work Package. Only this store's assigned quantities or its order snapshot items are included; other suppliers' materials and the package-wide budget are excluded. material_scope is VENDOR_ALLOCATION or VENDOR_ORDER; work_package contains the scoped lines and fulfillment details. order, when present, identifies the order and whether its terms were accepted. Source version/hash identify the retained complete original, not a hash of the filtered projection. |
**canPrepareQuotation** | **bool** | Authorized Vendor may prepare the quotation directly from this attachment. Accepted orders cannot be replaced. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


