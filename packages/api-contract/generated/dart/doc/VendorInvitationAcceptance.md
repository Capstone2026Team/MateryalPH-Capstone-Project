# materyalph_api_client.model.VendorInvitationAcceptance

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**token** | **String** |  |
**email** | **String** |  |
**fullName** | **String** |  |
**password** | **String** | New Vendor identities require at least 14 characters, mixed case, and a number. Existing ACTIVE or PENDING_VERIFICATION Vendor identities with no retained membership use their current password. Pending identities must complete email verification before signing in. |
**passwordConfirmation** | **String** |  |
**botProtection** | [**VendorBotProtectionEvidence**](VendorBotProtectionEvidence.md) | Required when Vendor bot protection is enabled. Use the invitation checkbox token or accessible email check; a verified single-use proof is supplied by HttpOnly cookie. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


