# materyalph_api_client.model.CheckoutGroupPreview

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vendor** | [**CheckoutVendorRef**](CheckoutVendorRef.md) |  |
**fulfillmentMethod** | **String** |  |
**fulfillmentOptions** | **BuiltList&lt;String&gt;** |  |
**status** | **String** |  |
**issues** | [**BuiltList&lt;CartIssue&gt;**](CartIssue.md) |  |
**lines** | [**BuiltList&lt;CartLine&gt;**](CartLine.md) |  |
**delivery** | [**DeliveryPreview**](DeliveryPreview.md) |  |
**pickup** | [**PickupPreview**](PickupPreview.md) |  |
**paymentMethods** | [**BuiltList&lt;PaymentMethodEligibility&gt;**](PaymentMethodEligibility.md) |  |
**amounts** | [**FinancialPreview**](FinancialPreview.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


