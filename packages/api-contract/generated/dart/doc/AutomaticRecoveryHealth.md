# materyalph_api_client.model.AutomaticRecoveryHealth

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** |  |
**maxCycles** | **int** |  |
**delaysMinutes** | **BuiltList&lt;int&gt;** | Recovery cooldowns: 15, 60 and 360 minutes after the most recent failure; active dispatcher leases can delay eligibility. |
**lastStartedAt** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


