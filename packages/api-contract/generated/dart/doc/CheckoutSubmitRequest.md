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
**paymentMethods** | **BuiltMap&lt;String, String&gt;** | Vendor id => chosen method; Online when omitted. COD pairs with Site Delivery, In-Store with Self-Pickup, each only when the Vendor enabled it. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


