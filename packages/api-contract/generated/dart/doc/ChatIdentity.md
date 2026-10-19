# materyalph_api_client.model.ChatIdentity

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**displayName** | **String** | Current public profile name. Historical messages fall back to the stored public name when no current profile name exists. System messages retain their system identity. |
**role** | **String** | Public role. For historical messages, this is the role recorded when the message was sent, even after a handler transfer or role change. |
**avatarPath** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


