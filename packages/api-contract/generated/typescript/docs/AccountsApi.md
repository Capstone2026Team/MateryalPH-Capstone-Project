# AccountsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**acceptAccountAgreements**](AccountsApi.md#acceptaccountagreements) | **POST** /{accountPortal}/account/agreements |  |
| [**acceptVendorStaffInvitation**](AccountsApi.md#acceptvendorstaffinvitation) | **POST** /auth/vendor-invitations/accept |  |
| [**changeAccountAdministrator**](AccountsApi.md#changeaccountadministrator) | **PATCH** /{accountPortal}/account/administrators/{publicId} |  |
| [**changeAccountDelegation**](AccountsApi.md#changeaccountdelegation) | **PATCH** /{accountPortal}/account/memberships/{membershipId}/delegation |  |
| [**changeAccountMembershipStatus**](AccountsApi.md#changeaccountmembershipstatus) | **PATCH** /{accountPortal}/account/memberships/{membershipId}/status |  |
| [**changeAccountPassword**](AccountsApi.md#changeaccountpassword) | **POST** /{accountPortal}/account/password |  |
| [**confirmAccountEmailChange**](AccountsApi.md#confirmaccountemailchange) | **POST** /{accountPortal}/account/email/confirm |  |
| [**confirmAccountFactorReplacement**](AccountsApi.md#confirmaccountfactorreplacement) | **POST** /{accountPortal}/account/factor/confirm |  |
| [**getAccountProfile**](AccountsApi.md#getaccountprofile) | **GET** /{accountPortal}/account/profile |  |
| [**getAccountSecurity**](AccountsApi.md#getaccountsecurity) | **GET** /{accountPortal}/account/security |  |
| [**inviteAccountAdmin**](AccountsApi.md#inviteaccountadmin) | **POST** /{accountPortal}/account/invitations |  |
| [**listAccountAdminRoles**](AccountsApi.md#listaccountadminroles) | **GET** /{accountPortal}/account/roles |  |
| [**listAccountAdministrators**](AccountsApi.md#listaccountadministrators) | **GET** /{accountPortal}/account/administrators |  |
| [**listAccountAgreements**](AccountsApi.md#listaccountagreements) | **GET** /{accountPortal}/account/agreements |  |
| [**listAccountMemberships**](AccountsApi.md#listaccountmemberships) | **GET** /{accountPortal}/account/memberships |  |
| [**listAccountSessions**](AccountsApi.md#listaccountsessions) | **GET** /{accountPortal}/account/sessions |  |
| [**reauthenticateAccount**](AccountsApi.md#reauthenticateaccount) | **POST** /{accountPortal}/account/reauthentication |  |
| [**replaceAccountRecoveryCodes**](AccountsApi.md#replaceaccountrecoverycodes) | **POST** /{accountPortal}/account/recovery-codes |  |
| [**revokeAccountSession**](AccountsApi.md#revokeaccountsession) | **DELETE** /{accountPortal}/account/sessions/{sessionId} |  |
| [**revokeAccountSessions**](AccountsApi.md#revokeaccountsessions) | **POST** /{accountPortal}/account/sessions/revoke |  |
| [**sendAccountReauthenticationEmail**](AccountsApi.md#sendaccountreauthenticationemail) | **POST** /{accountPortal}/account/reauthentication/email |  |
| [**startAccountEmailChange**](AccountsApi.md#startaccountemailchange) | **POST** /{accountPortal}/account/email |  |
| [**startAccountFactorReplacement**](AccountsApi.md#startaccountfactorreplacement) | **POST** /{accountPortal}/account/factor |  |
| [**updateAccountProfile**](AccountsApi.md#updateaccountprofile) | **PATCH** /{accountPortal}/account/profile |  |



## acceptAccountAgreements

> AccountMutationResultEnvelope acceptAccountAgreements(accountPortal, accountAgreementAcceptance)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { AcceptAccountAgreementsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountAgreementAcceptance
    accountAgreementAcceptance: ...,
  } satisfies AcceptAccountAgreementsRequest;

  try {
    const data = await api.acceptAccountAgreements(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **accountAgreementAcceptance** | [AccountAgreementAcceptance](AccountAgreementAcceptance.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## acceptVendorStaffInvitation

> AccountMutationResultEnvelope acceptVendorStaffInvitation(vendorInvitationAcceptance)



### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { AcceptVendorStaffInvitationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // VendorInvitationAcceptance
    vendorInvitationAcceptance: ...,
  } satisfies AcceptVendorStaffInvitationRequest;

  try {
    const data = await api.acceptVendorStaffInvitation(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **vendorInvitationAcceptance** | [VendorInvitationAcceptance](VendorInvitationAcceptance.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Invitation consumed. Verify email and sign in; privileged roles require TOTP. |  -  |
| **422** | Invalid invitation or details. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## changeAccountAdministrator

> AccountMutationResultEnvelope changeAccountAdministrator(accountPortal, publicId, accountAdminChange)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ChangeAccountAdministratorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'admin'
    accountPortal: accountPortal_example,
    // string
    publicId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AccountAdminChange
    accountAdminChange: ...,
  } satisfies ChangeAccountAdministratorRequest;

  try {
    const data = await api.changeAccountAdministrator(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `admin` |  | [Defaults to `undefined`] [Enum: admin] |
| **publicId** | `string` |  | [Defaults to `undefined`] |
| **accountAdminChange** | [AccountAdminChange](AccountAdminChange.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## changeAccountDelegation

> AccountMutationResultEnvelope changeAccountDelegation(accountPortal, membershipId, accountDelegation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ChangeAccountDelegationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'vendors'
    accountPortal: accountPortal_example,
    // string
    membershipId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AccountDelegation
    accountDelegation: ...,
  } satisfies ChangeAccountDelegationRequest;

  try {
    const data = await api.changeAccountDelegation(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `vendors` |  | [Defaults to `undefined`] [Enum: vendors] |
| **membershipId** | `string` |  | [Defaults to `undefined`] |
| **accountDelegation** | [AccountDelegation](AccountDelegation.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## changeAccountMembershipStatus

> AccountMutationResultEnvelope changeAccountMembershipStatus(accountPortal, membershipId, accountMembershipStatus)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ChangeAccountMembershipStatusRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'vendors'
    accountPortal: accountPortal_example,
    // string
    membershipId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AccountMembershipStatus
    accountMembershipStatus: ...,
  } satisfies ChangeAccountMembershipStatusRequest;

  try {
    const data = await api.changeAccountMembershipStatus(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `vendors` |  | [Defaults to `undefined`] [Enum: vendors] |
| **membershipId** | `string` |  | [Defaults to `undefined`] |
| **accountMembershipStatus** | [AccountMembershipStatus](AccountMembershipStatus.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## changeAccountPassword

> AccountMutationResultEnvelope changeAccountPassword(accountPortal, accountPasswordChange)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ChangeAccountPasswordRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountPasswordChange
    accountPasswordChange: ...,
  } satisfies ChangeAccountPasswordRequest;

  try {
    const data = await api.changeAccountPassword(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **accountPasswordChange** | [AccountPasswordChange](AccountPasswordChange.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## confirmAccountEmailChange

> AccountMutationResultEnvelope confirmAccountEmailChange(accountPortal, accountCodeConfirmation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ConfirmAccountEmailChangeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountCodeConfirmation
    accountCodeConfirmation: ...,
  } satisfies ConfirmAccountEmailChangeRequest;

  try {
    const data = await api.confirmAccountEmailChange(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **accountCodeConfirmation** | [AccountCodeConfirmation](AccountCodeConfirmation.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## confirmAccountFactorReplacement

> AccountRecoveryCodesEnvelope confirmAccountFactorReplacement(accountPortal, accountCodeConfirmation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ConfirmAccountFactorReplacementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountCodeConfirmation
    accountCodeConfirmation: ...,
  } satisfies ConfirmAccountFactorReplacementRequest;

  try {
    const data = await api.confirmAccountFactorReplacement(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: vendors, admin] |
| **accountCodeConfirmation** | [AccountCodeConfirmation](AccountCodeConfirmation.md) |  | |

### Return type

[**AccountRecoveryCodesEnvelope**](AccountRecoveryCodesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAccountProfile

> AccountProfileEnvelope getAccountProfile(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { GetAccountProfileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
  } satisfies GetAccountProfileRequest;

  try {
    const data = await api.getAccountProfile(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |

### Return type

[**AccountProfileEnvelope**](AccountProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAccountSecurity

> AccountSecurityEnvelope getAccountSecurity(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { GetAccountSecurityRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
  } satisfies GetAccountSecurityRequest;

  try {
    const data = await api.getAccountSecurity(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |

### Return type

[**AccountSecurityEnvelope**](AccountSecurityEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## inviteAccountAdmin

> AccountMutationResultEnvelope inviteAccountAdmin(accountPortal, idempotencyKey, accountAdminInvitation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { InviteAccountAdminRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'admin'
    accountPortal: accountPortal_example,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AccountAdminInvitation
    accountAdminInvitation: ...,
  } satisfies InviteAccountAdminRequest;

  try {
    const data = await api.inviteAccountAdmin(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `admin` |  | [Defaults to `undefined`] [Enum: admin] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **accountAdminInvitation** | [AccountAdminInvitation](AccountAdminInvitation.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAccountAdminRoles

> AccountRoleListEnvelope listAccountAdminRoles(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ListAccountAdminRolesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'admin'
    accountPortal: accountPortal_example,
  } satisfies ListAccountAdminRolesRequest;

  try {
    const data = await api.listAccountAdminRoles(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `admin` |  | [Defaults to `undefined`] [Enum: admin] |

### Return type

[**AccountRoleListEnvelope**](AccountRoleListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAccountAdministrators

> AccountAdministratorListEnvelope listAccountAdministrators(accountPortal, page)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ListAccountAdministratorsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'admin'
    accountPortal: accountPortal_example,
    // number (optional)
    page: 56,
  } satisfies ListAccountAdministratorsRequest;

  try {
    const data = await api.listAccountAdministrators(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `admin` |  | [Defaults to `undefined`] [Enum: admin] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AccountAdministratorListEnvelope**](AccountAdministratorListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAccountAgreements

> AccountAgreementListEnvelope listAccountAgreements(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ListAccountAgreementsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
  } satisfies ListAccountAgreementsRequest;

  try {
    const data = await api.listAccountAgreements(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |

### Return type

[**AccountAgreementListEnvelope**](AccountAgreementListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAccountMemberships

> AccountMembershipListEnvelope listAccountMemberships(accountPortal, page)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ListAccountMembershipsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'vendors'
    accountPortal: accountPortal_example,
    // number (optional)
    page: 56,
  } satisfies ListAccountMembershipsRequest;

  try {
    const data = await api.listAccountMemberships(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `vendors` |  | [Defaults to `undefined`] [Enum: vendors] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AccountMembershipListEnvelope**](AccountMembershipListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAccountSessions

> AccountSessionListEnvelope listAccountSessions(accountPortal, page)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ListAccountSessionsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // number (optional)
    page: 56,
  } satisfies ListAccountSessionsRequest;

  try {
    const data = await api.listAccountSessions(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AccountSessionListEnvelope**](AccountSessionListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reauthenticateAccount

> AccountMutationResultEnvelope reauthenticateAccount(accountPortal, accountReauthentication)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ReauthenticateAccountRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountReauthentication
    accountReauthentication: ...,
  } satisfies ReauthenticateAccountRequest;

  try {
    const data = await api.reauthenticateAccount(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **accountReauthentication** | [AccountReauthentication](AccountReauthentication.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## replaceAccountRecoveryCodes

> AccountRecoveryCodesEnvelope replaceAccountRecoveryCodes(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ReplaceAccountRecoveryCodesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'vendors' | 'admin'
    accountPortal: accountPortal_example,
  } satisfies ReplaceAccountRecoveryCodesRequest;

  try {
    const data = await api.replaceAccountRecoveryCodes(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: vendors, admin] |

### Return type

[**AccountRecoveryCodesEnvelope**](AccountRecoveryCodesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## revokeAccountSession

> AccountMutationResultEnvelope revokeAccountSession(accountPortal, sessionId)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { RevokeAccountSessionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // string
    sessionId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies RevokeAccountSessionRequest;

  try {
    const data = await api.revokeAccountSession(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **sessionId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## revokeAccountSessions

> AccountMutationResultEnvelope revokeAccountSessions(accountPortal, accountSessionRevocation)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { RevokeAccountSessionsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountSessionRevocation
    accountSessionRevocation: ...,
  } satisfies RevokeAccountSessionsRequest;

  try {
    const data = await api.revokeAccountSessions(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **accountSessionRevocation** | [AccountSessionRevocation](AccountSessionRevocation.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## sendAccountReauthenticationEmail

> AccountMutationResultEnvelope sendAccountReauthenticationEmail(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { SendAccountReauthenticationEmailRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
  } satisfies SendAccountReauthenticationEmailRequest;

  try {
    const data = await api.sendAccountReauthenticationEmail(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## startAccountEmailChange

> AccountPendingChangeEnvelope startAccountEmailChange(accountPortal, accountEmailChange)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { StartAccountEmailChangeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountEmailChange
    accountEmailChange: ...,
  } satisfies StartAccountEmailChangeRequest;

  try {
    const data = await api.startAccountEmailChange(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **accountEmailChange** | [AccountEmailChange](AccountEmailChange.md) |  | |

### Return type

[**AccountPendingChangeEnvelope**](AccountPendingChangeEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## startAccountFactorReplacement

> AccountFactorEnrollmentEnvelope startAccountFactorReplacement(accountPortal)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { StartAccountFactorReplacementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'vendors' | 'admin'
    accountPortal: accountPortal_example,
  } satisfies StartAccountFactorReplacementRequest;

  try {
    const data = await api.startAccountFactorReplacement(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: vendors, admin] |

### Return type

[**AccountFactorEnrollmentEnvelope**](AccountFactorEnrollmentEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## updateAccountProfile

> AccountProfileEnvelope updateAccountProfile(accountPortal, accountProfileUpdate)



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { UpdateAccountProfileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountProfileUpdate
    accountProfileUpdate: ...,
  } satisfies UpdateAccountProfileRequest;

  try {
    const data = await api.updateAccountProfile(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |
| **accountProfileUpdate** | [AccountProfileUpdate](AccountProfileUpdate.md) |  | |

### Return type

[**AccountProfileEnvelope**](AccountProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful account operation. |  -  |
| **401** | Safe canonical error with correlation identifier. |  -  |
| **403** | Safe canonical error with correlation identifier. |  -  |
| **404** | Safe canonical error with correlation identifier. |  -  |
| **409** | Safe canonical error with correlation identifier. |  -  |
| **419** | Safe canonical error with correlation identifier. |  -  |
| **422** | Safe canonical error with correlation identifier. |  -  |
| **429** | Safe canonical error with correlation identifier. |  -  |
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

