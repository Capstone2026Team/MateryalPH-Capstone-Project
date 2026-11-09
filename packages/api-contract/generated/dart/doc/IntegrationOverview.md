# materyalph_api_client.model.IntegrationOverview

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**generatedAt** | [**DateTime**](DateTime.md) |  |
**environment** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Safe app and commerce labels. deployment is HOSTINGER_VPS only for the staging API on the approved MateryalPH Duck DNS host pattern; OTHER responses must not be presented as VPS provider health. |
**integrations** | [**BuiltList&lt;IntegrationStatus&gt;**](IntegrationStatus.md) |  |
**queues** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**automaticRecovery** | [**AutomaticRecoveryHealth**](AutomaticRecoveryHealth.md) |  | [optional]
**scheduledTasks** | [**BuiltList&lt;ScheduledTaskHealth&gt;**](ScheduledTaskHealth.md) |  |
**analytics** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**canRetry** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


