# materyalph_api_client.model.OperationFailure

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**kind** | **String** |  |
**reference** | **String** |  |
**label** | **String** |  |
**queue** | **String** |  |
**failure** | **String** |  |
**attempts** | **int** |  | [optional]
**failedAt** | [**DateTime**](DateTime.md) |  |
**retryable** | **bool** |  |
**retryNote** | **String** |  | [optional]
**recoveryStatus** | **String** | Automatic recovery eligibility; SCHEDULED is a lower-bound eligibility time, subject to the scheduler and worker being available. | [optional]
**recoveryAttempts** | **int** |  | [optional]
**nextRetryAt** | [**DateTime**](DateTime.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


