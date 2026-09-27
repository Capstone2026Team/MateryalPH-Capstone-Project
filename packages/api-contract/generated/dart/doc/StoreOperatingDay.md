# materyalph_api_client.model.StoreOperatingDay

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dayOfWeek** | **int** | ISO weekday; Monday is 1 and Sunday is 7. |
**status** | **String** |  |
**opensAt** | **String** | Philippine local time; null when Closed. | [optional]
**closesAt** | **String** | Later than opens_at on the same day; overnight periods are unsupported. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


