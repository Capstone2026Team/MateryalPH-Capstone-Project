# materyalph_api_client.model.AccountProfile

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**fullName** | **String** |  |
**avatarUrl** | **String** | Short-lived owner-only personal photo URL; never the store logo. | [optional]
**mobileE164** | **String** | Authenticated Buyer registered contact number. | [optional]
**emailMasked** | **bool** | False for the authenticated owner's full account email. Retained for client compatibility. | [optional]
**email** | **String** | Full account email, visible only to the authenticated account owner. |
**emailVerified** | **bool** | Whether the account email ownership has been verified; not a Buyer performance or business verification badge. | [optional]
**accountType** | **String** |  |
**accountStatus** | **String** |  |
**lockVersion** | **int** |  |
**createdAt** | **String** |  |
**buyerType** | **String** |  |
**companyName** | **String** |  |
**organizationName** | **String** |  |
**role** | **String** |  |
**organizationId** | **String** |  |
**membershipId** | **String** |  |
**canManageStaff** | **bool** |  |
**permissions** | **BuiltList&lt;String&gt;** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


