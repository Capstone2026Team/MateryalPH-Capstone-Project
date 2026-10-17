# materyalph_api_client.model.AdminInvitationRequest

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**token** | **String** |  |
**email** | **String** | Must match the invited email when supplied. The server always derives the account and email-check recipient from the invitation. | [optional]
**fullName** | **String** |  |
**password** | **String** |  |
**passwordConfirmation** | **String** |  |
**termsAccepted** | **bool** |  |
**privacyAccepted** | **bool** |  |
**botProtection** | [**VendorBotProtectionEvidence**](VendorBotProtectionEvidence.md) | Admin invitation acceptance; required when bot protection is enabled unless a matching single-use HttpOnly proof cookie is present. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


