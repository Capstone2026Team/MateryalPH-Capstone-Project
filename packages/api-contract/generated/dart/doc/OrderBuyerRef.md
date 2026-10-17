# materyalph_api_client.model.OrderBuyerRef

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**displayName** | **String** |  |
**mobileE164** | **String** | Current Buyer phone for delivery coordination. Only Owner/Manager or current active assigned Fulfillment Staff on an accepted, open Site Delivery order receives it. Other roles and closed/pickup orders receive null. | [optional]
**avatarPath** | **String** | Authorized order-scoped API photo path with the Buyer profile version. Uses the same delivery-contact authorization as mobile_e164; never a public storage URL. Null when the Buyer has no photo or contact is unavailable. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


