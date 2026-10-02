# materyalph_api_client.model.OrderDeadlines

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vendorResponseDueAt** | [**DateTime**](DateTime.md) |  |
**buyerResponseDueAt** | [**DateTime**](DateTime.md) |  |
**paymentExpiresAt** | [**DateTime**](DateTime.md) | 24 hours after the order entered AWAITING_PAYMENT (Pending Payment). The server clock decides; clients only display it. |
**serverTime** | [**DateTime**](DateTime.md) |  |
**timezone** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


