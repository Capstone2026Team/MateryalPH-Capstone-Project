# materyalph_api_client.model.InventoryBalance

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**quantityOnHand** | **String** | Physical stock (four decimals). Reduced only by fulfillment or a recorded adjustment. |
**hardReservedQuantity** | **String** |  |
**softHeldQuantity** | **String** | Planning-only quotation holds; never reduce available_to_sell. |
**availableToSell** | **String** | quantity_on_hand minus hard_reserved_quantity. |
**reorderLevel** | **String** |  |
**confirmedAt** | [**DateTime**](DateTime.md) |  |
**updatedAt** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


