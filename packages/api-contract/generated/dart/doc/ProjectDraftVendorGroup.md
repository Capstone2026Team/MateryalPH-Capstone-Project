# materyalph_api_client.model.ProjectDraftVendorGroup

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vendorId** | **String** |  |
**storeName** | **String** |  |
**items** | [**BuiltList&lt;ProjectSeparatePurchase&gt;**](ProjectSeparatePurchase.md) |  |
**materialsCentavos** | **int** |  |
**fulfillmentMethod** | **String** | This supplier's method. Any group containing ready-mixed concrete uses DELIVERY even when the primary supplier uses PICKUP. Its delivery fee and payment options are calculated independently. |
**fulfillmentOptions** | **BuiltList&lt;String&gt;** | Current fulfillment methods supported for every selected product from this supplier. | [optional]
**delivery** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Existing delivery preview for this supplier's selected items, including its route, vehicles, trips, estimated fees and review issues. | [optional]
**paymentMethods** | [**BuiltList&lt;ProjectPaymentMethod&gt;**](ProjectPaymentMethod.md) |  |
**issues** | **BuiltList&lt;String&gt;** |  |
**draftFingerprint** | **String** |  |
**deliveryCentavos** | **int** |  | [optional]
**projectedTotalCentavos** | **int** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


