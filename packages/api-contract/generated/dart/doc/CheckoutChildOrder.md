# materyalph_api_client.model.CheckoutChildOrder

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**reference** | **String** |  |
**vendor** | [**OrderVendorRef**](OrderVendorRef.md) |  |
**orderState** | [**OrderState**](OrderState.md) |  |
**paymentState** | [**OrderPaymentState**](OrderPaymentState.md) |  |
**fulfillmentMethod** | **String** |  |
**paymentMethod** | **String** |  |
**confirmationSource** | **String** |  |
**materialsCentavos** | **int** |  |
**deliveryCentavos** | **int** | Null while the Vendor has not confirmed the delivery fee. |
**commercialTotalCentavos** | **int** |  |
**vendorResponseDueAt** | [**DateTime**](DateTime.md) |  |
**paymentExpiresAt** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


