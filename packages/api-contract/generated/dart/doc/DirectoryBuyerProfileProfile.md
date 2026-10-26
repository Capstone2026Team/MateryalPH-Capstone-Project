# materyalph_api_client.model.DirectoryBuyerProfileProfile

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**avatarUrl** | **String** | Five-minute signed private photo URL, bound to the viewing Admin and current Buyer profile version. Fetch with authenticated cookie transport; null when absent or the account is deleted. |
**email** | **String** |  |
**emailVerified** | **bool** |  |
**mobile** | **String** |  |
**buyerType** | **String** |  |
**companyName** | **String** |  |
**positionTitle** | **String** |  |
**industry** | **String** |  |
**area** | **String** | City and province of the primary saved location; never coordinates or site instructions. |
**onboardingStatus** | **String** |  |
**joinedAt** | [**DateTime**](DateTime.md) |  |
**deletedAt** | [**DateTime**](DateTime.md) |  |
**commerceRestrictedUntil** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


