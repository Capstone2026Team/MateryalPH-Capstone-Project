# materyalph_api_client.model.PaymentOptions

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**orderId** | **String** |  |
**orderReference** | **String** |  |
**paymentDue** | **bool** |  |
**purpose** | **String** |  | [optional]
**principalCentavos** | **int** |  | [optional]
**breakdown** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**channels** | [**BuiltList&lt;PaymentChannelOption&gt;**](PaymentChannelOption.md) |  |
**payBy** | [**DateTime**](DateTime.md) |  | [optional]
**environment** | **String** |  |
**evidenceOrigin** | **String** |  |
**providerReady** | **bool** |  |
**latestAttempt** | [**PaymentAttempt**](PaymentAttempt.md) |  | [optional]
**notice** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


