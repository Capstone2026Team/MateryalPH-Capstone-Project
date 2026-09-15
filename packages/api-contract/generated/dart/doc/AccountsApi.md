# materyalph_api_client.api.AccountsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptAccountAgreements**](AccountsApi.md#acceptaccountagreements) | **POST** /{accountPortal}/account/agreements |
[**acceptVendorStaffInvitation**](AccountsApi.md#acceptvendorstaffinvitation) | **POST** /auth/vendor-invitations/accept |
[**changeAccountAdministrator**](AccountsApi.md#changeaccountadministrator) | **PATCH** /{accountPortal}/account/administrators/{publicId} |
[**changeAccountDelegation**](AccountsApi.md#changeaccountdelegation) | **PATCH** /{accountPortal}/account/memberships/{membershipId}/delegation |
[**changeAccountMembershipStatus**](AccountsApi.md#changeaccountmembershipstatus) | **PATCH** /{accountPortal}/account/memberships/{membershipId}/status |
[**changeAccountPassword**](AccountsApi.md#changeaccountpassword) | **POST** /{accountPortal}/account/password |
[**confirmAccountEmailChange**](AccountsApi.md#confirmaccountemailchange) | **POST** /{accountPortal}/account/email/confirm |
[**confirmAccountFactorReplacement**](AccountsApi.md#confirmaccountfactorreplacement) | **POST** /{accountPortal}/account/factor/confirm |
[**getAccountProfile**](AccountsApi.md#getaccountprofile) | **GET** /{accountPortal}/account/profile |
[**getAccountSecurity**](AccountsApi.md#getaccountsecurity) | **GET** /{accountPortal}/account/security |
[**inviteAccountAdmin**](AccountsApi.md#inviteaccountadmin) | **POST** /{accountPortal}/account/invitations |
[**listAccountAdminRoles**](AccountsApi.md#listaccountadminroles) | **GET** /{accountPortal}/account/roles |
[**listAccountAdministrators**](AccountsApi.md#listaccountadministrators) | **GET** /{accountPortal}/account/administrators |
[**listAccountAgreements**](AccountsApi.md#listaccountagreements) | **GET** /{accountPortal}/account/agreements |
[**listAccountMemberships**](AccountsApi.md#listaccountmemberships) | **GET** /{accountPortal}/account/memberships |
[**listAccountSessions**](AccountsApi.md#listaccountsessions) | **GET** /{accountPortal}/account/sessions |
[**reauthenticateAccount**](AccountsApi.md#reauthenticateaccount) | **POST** /{accountPortal}/account/reauthentication |
[**replaceAccountRecoveryCodes**](AccountsApi.md#replaceaccountrecoverycodes) | **POST** /{accountPortal}/account/recovery-codes |
[**revokeAccountSession**](AccountsApi.md#revokeaccountsession) | **DELETE** /{accountPortal}/account/sessions/{sessionId} |
[**revokeAccountSessions**](AccountsApi.md#revokeaccountsessions) | **POST** /{accountPortal}/account/sessions/revoke |
[**sendAccountReauthenticationEmail**](AccountsApi.md#sendaccountreauthenticationemail) | **POST** /{accountPortal}/account/reauthentication/email |
[**startAccountEmailChange**](AccountsApi.md#startaccountemailchange) | **POST** /{accountPortal}/account/email |
[**startAccountFactorReplacement**](AccountsApi.md#startaccountfactorreplacement) | **POST** /{accountPortal}/account/factor |
[**updateAccountProfile**](AccountsApi.md#updateaccountprofile) | **PATCH** /{accountPortal}/account/profile |


# **acceptAccountAgreements**
> AccountMutationResultEnvelope acceptAccountAgreements(accountPortal, accountAgreementAcceptance)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountAgreementAcceptance accountAgreementAcceptance = ; // AccountAgreementAcceptance |

try {
    final response = api.acceptAccountAgreements(accountPortal, accountAgreementAcceptance);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->acceptAccountAgreements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountAgreementAcceptance** | [**AccountAgreementAcceptance**](AccountAgreementAcceptance.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **acceptVendorStaffInvitation**
> AccountMutationResultEnvelope acceptVendorStaffInvitation(vendorInvitationAcceptance)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final VendorInvitationAcceptance vendorInvitationAcceptance = ; // VendorInvitationAcceptance |

try {
    final response = api.acceptVendorStaffInvitation(vendorInvitationAcceptance);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->acceptVendorStaffInvitation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorInvitationAcceptance** | [**VendorInvitationAcceptance**](VendorInvitationAcceptance.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **changeAccountAdministrator**
> AccountMutationResultEnvelope changeAccountAdministrator(accountPortal, publicId, accountAdminChange)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final String publicId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AccountAdminChange accountAdminChange = ; // AccountAdminChange |

try {
    final response = api.changeAccountAdministrator(accountPortal, publicId, accountAdminChange);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->changeAccountAdministrator: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **publicId** | **String**|  |
 **accountAdminChange** | [**AccountAdminChange**](AccountAdminChange.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **changeAccountDelegation**
> AccountMutationResultEnvelope changeAccountDelegation(accountPortal, membershipId, accountDelegation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final String membershipId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AccountDelegation accountDelegation = ; // AccountDelegation |

try {
    final response = api.changeAccountDelegation(accountPortal, membershipId, accountDelegation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->changeAccountDelegation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **membershipId** | **String**|  |
 **accountDelegation** | [**AccountDelegation**](AccountDelegation.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **changeAccountMembershipStatus**
> AccountMutationResultEnvelope changeAccountMembershipStatus(accountPortal, membershipId, accountMembershipStatus)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final String membershipId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AccountMembershipStatus accountMembershipStatus = ; // AccountMembershipStatus |

try {
    final response = api.changeAccountMembershipStatus(accountPortal, membershipId, accountMembershipStatus);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->changeAccountMembershipStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **membershipId** | **String**|  |
 **accountMembershipStatus** | [**AccountMembershipStatus**](AccountMembershipStatus.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **changeAccountPassword**
> AccountMutationResultEnvelope changeAccountPassword(accountPortal, accountPasswordChange)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountPasswordChange accountPasswordChange = ; // AccountPasswordChange |

try {
    final response = api.changeAccountPassword(accountPortal, accountPasswordChange);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->changeAccountPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountPasswordChange** | [**AccountPasswordChange**](AccountPasswordChange.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmAccountEmailChange**
> AccountMutationResultEnvelope confirmAccountEmailChange(accountPortal, accountCodeConfirmation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountCodeConfirmation accountCodeConfirmation = ; // AccountCodeConfirmation |

try {
    final response = api.confirmAccountEmailChange(accountPortal, accountCodeConfirmation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->confirmAccountEmailChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountCodeConfirmation** | [**AccountCodeConfirmation**](AccountCodeConfirmation.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmAccountFactorReplacement**
> AccountRecoveryCodesEnvelope confirmAccountFactorReplacement(accountPortal, accountCodeConfirmation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountCodeConfirmation accountCodeConfirmation = ; // AccountCodeConfirmation |

try {
    final response = api.confirmAccountFactorReplacement(accountPortal, accountCodeConfirmation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->confirmAccountFactorReplacement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountCodeConfirmation** | [**AccountCodeConfirmation**](AccountCodeConfirmation.md)|  |

### Return type

[**AccountRecoveryCodesEnvelope**](AccountRecoveryCodesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAccountProfile**
> AccountProfileEnvelope getAccountProfile(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |

try {
    final response = api.getAccountProfile(accountPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->getAccountProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |

### Return type

[**AccountProfileEnvelope**](AccountProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAccountSecurity**
> AccountSecurityEnvelope getAccountSecurity(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |

try {
    final response = api.getAccountSecurity(accountPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->getAccountSecurity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |

### Return type

[**AccountSecurityEnvelope**](AccountSecurityEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inviteAccountAdmin**
> AccountMutationResultEnvelope inviteAccountAdmin(accountPortal, idempotencyKey, accountAdminInvitation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AccountAdminInvitation accountAdminInvitation = ; // AccountAdminInvitation |

try {
    final response = api.inviteAccountAdmin(accountPortal, idempotencyKey, accountAdminInvitation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->inviteAccountAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **idempotencyKey** | **String**|  |
 **accountAdminInvitation** | [**AccountAdminInvitation**](AccountAdminInvitation.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountAdminRoles**
> AccountRoleListEnvelope listAccountAdminRoles(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |

try {
    final response = api.listAccountAdminRoles(accountPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->listAccountAdminRoles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |

### Return type

[**AccountRoleListEnvelope**](AccountRoleListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountAdministrators**
> AccountAdministratorListEnvelope listAccountAdministrators(accountPortal, page)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final int page = 56; // int |

try {
    final response = api.listAccountAdministrators(accountPortal, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->listAccountAdministrators: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**AccountAdministratorListEnvelope**](AccountAdministratorListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountAgreements**
> AccountAgreementListEnvelope listAccountAgreements(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |

try {
    final response = api.listAccountAgreements(accountPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->listAccountAgreements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |

### Return type

[**AccountAgreementListEnvelope**](AccountAgreementListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountMemberships**
> AccountMembershipListEnvelope listAccountMemberships(accountPortal, page)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final int page = 56; // int |

try {
    final response = api.listAccountMemberships(accountPortal, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->listAccountMemberships: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**AccountMembershipListEnvelope**](AccountMembershipListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountSessions**
> AccountSessionListEnvelope listAccountSessions(accountPortal, page)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final int page = 56; // int |

try {
    final response = api.listAccountSessions(accountPortal, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->listAccountSessions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**AccountSessionListEnvelope**](AccountSessionListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reauthenticateAccount**
> AccountMutationResultEnvelope reauthenticateAccount(accountPortal, accountReauthentication)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountReauthentication accountReauthentication = ; // AccountReauthentication |

try {
    final response = api.reauthenticateAccount(accountPortal, accountReauthentication);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->reauthenticateAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountReauthentication** | [**AccountReauthentication**](AccountReauthentication.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **replaceAccountRecoveryCodes**
> AccountRecoveryCodesEnvelope replaceAccountRecoveryCodes(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |

try {
    final response = api.replaceAccountRecoveryCodes(accountPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->replaceAccountRecoveryCodes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |

### Return type

[**AccountRecoveryCodesEnvelope**](AccountRecoveryCodesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeAccountSession**
> AccountMutationResultEnvelope revokeAccountSession(accountPortal, sessionId)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final String sessionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.revokeAccountSession(accountPortal, sessionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->revokeAccountSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **sessionId** | **String**|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeAccountSessions**
> AccountMutationResultEnvelope revokeAccountSessions(accountPortal, accountSessionRevocation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountSessionRevocation accountSessionRevocation = ; // AccountSessionRevocation |

try {
    final response = api.revokeAccountSessions(accountPortal, accountSessionRevocation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->revokeAccountSessions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountSessionRevocation** | [**AccountSessionRevocation**](AccountSessionRevocation.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendAccountReauthenticationEmail**
> AccountMutationResultEnvelope sendAccountReauthenticationEmail(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |

try {
    final response = api.sendAccountReauthenticationEmail(accountPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->sendAccountReauthenticationEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startAccountEmailChange**
> AccountPendingChangeEnvelope startAccountEmailChange(accountPortal, accountEmailChange)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountEmailChange accountEmailChange = ; // AccountEmailChange |

try {
    final response = api.startAccountEmailChange(accountPortal, accountEmailChange);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->startAccountEmailChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountEmailChange** | [**AccountEmailChange**](AccountEmailChange.md)|  |

### Return type

[**AccountPendingChangeEnvelope**](AccountPendingChangeEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startAccountFactorReplacement**
> AccountFactorEnrollmentEnvelope startAccountFactorReplacement(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |

try {
    final response = api.startAccountFactorReplacement(accountPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->startAccountFactorReplacement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |

### Return type

[**AccountFactorEnrollmentEnvelope**](AccountFactorEnrollmentEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAccountProfile**
> AccountProfileEnvelope updateAccountProfile(accountPortal, accountProfileUpdate)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAccountsApi();
final String accountPortal = accountPortal_example; // String |
final AccountProfileUpdate accountProfileUpdate = ; // AccountProfileUpdate |

try {
    final response = api.updateAccountProfile(accountPortal, accountProfileUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->updateAccountProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountPortal** | **String**|  |
 **accountProfileUpdate** | [**AccountProfileUpdate**](AccountProfileUpdate.md)|  |

### Return type

[**AccountProfileEnvelope**](AccountProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

