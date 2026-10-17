# materyalph_api_client.model.SiteInspectionDecision

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lockVersion** | **int** |  |
**scheduledFor** | [**DateTime**](DateTime.md) | Required for schedule; must be in the future. | [optional]
**note** | **String** | Optional note shown to the Buyer for schedule and complete. | [optional]
**reason** | **String** | Required for decline. | [optional]
**measuredVolumeM3** | **String** | Required for complete; above zero. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


