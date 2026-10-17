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
| [**confirmBuyerTwoFactor**](AccountsApi.md#confirmbuyertwofactor) | **POST** /buyers/account/two-factor/confirm |  |
| [**deleteBuyerAccount**](AccountsApi.md#deletebuyeraccount) | **POST** /buyers/account/deletion |  |
| [**deleteVendorTeamInvitation**](AccountsApi.md#deletevendorteaminvitation) | **DELETE** /vendors/account/invitations/{invitationId} |  |
| [**deleteVendorTeamMember**](AccountsApi.md#deletevendorteammember) | **DELETE** /vendors/account/memberships/{membershipId} |  |
| [**disableBuyerTwoFactor**](AccountsApi.md#disablebuyertwofactor) | **POST** /buyers/account/two-factor/disable |  |
| [**getAccountPhoto**](AccountsApi.md#getaccountphoto) | **GET** /{webAccountPortal}/account/photo |  |
| [**getAccountProfile**](AccountsApi.md#getaccountprofile) | **GET** /{accountPortal}/account/profile |  |
| [**getAccountSecurity**](AccountsApi.md#getaccountsecurity) | **GET** /{accountPortal}/account/security |  |
| [**getBuyerAccountDeletionPreview**](AccountsApi.md#getbuyeraccountdeletionpreview) | **GET** /buyers/account/deletion |  |
| [**getBuyerAccountPhoto**](AccountsApi.md#getbuyeraccountphoto) | **GET** /buyers/account/photo |  |
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
| [**startBuyerTwoFactor**](AccountsApi.md#startbuyertwofactor) | **POST** /buyers/account/two-factor |  |
| [**updateAccountProfile**](AccountsApi.md#updateaccountprofile) | **PATCH** /{accountPortal}/account/profile |  |
| [**updateVendorStaff**](AccountsApi.md#updatevendorstaff) | **PATCH** /vendors/account/memberships/{membershipId} |  |
| [**uploadAccountPhoto**](AccountsApi.md#uploadaccountphoto) | **POST** /{webAccountPortal}/account/photo |  |
| [**uploadBuyerAccountPhoto**](AccountsApi.md#uploadbuyeraccountphoto) | **POST** /buyers/account/photo |  |



## acceptAccountAgreements

> AccountMutationResultEnvelope acceptAccountAgreements(accountPortal, accountAgreementAcceptance)



Vendor commission consent must use the version-bound Store Verification commission endpoint; this account endpoint returns COMMISSION_VERIFICATION_REQUIRED for that agreement. Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.

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
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## acceptVendorStaffInvitation

> AccountMutationResultEnvelope acceptVendorStaffInvitation(vendorInvitationAcceptance)



Accepts an unexpired invitation for its invited email and fixed role. When Vendor bot protection is enabled, requires an Enterprise checkbox assessment with server-selected action vendor_invitation_accept, or an accessible email security check with a single-use HttpOnly proof bound to this email and action. Invalid, expired, revoked, deleted or accepted invitations cannot trigger a bot email challenge. Existing Vendor identities in ACTIVE or PENDING_VERIFICATION use their current password and must have no retained Vendor membership. Deleted memberships remain historical records. Pending identities receive a new email verification code and remain pending until verification; acceptance never signs in or activates the identity. Suspended, banned, deactivated and non-Vendor identities remain ineligible.

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
| **403** | The requested auth operation requires a short-lived email risk-verification step. |  -  |
| **503** | Bot protection is not configured for the Vendor portal. No invitation is consumed. |  -  |
| **429** | Authentication rate limit or OTP resend cooldown. OTP_RESEND_THROTTLED leaves the invitation unconsumed and creates no membership; wait before retrying. |  -  |

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


## confirmBuyerTwoFactor

> AccountRecoveryCodesEnvelope confirmBuyerTwoFactor(buyerTwoFactorConfirmation)



Confirms the pending authenticator with a current 6-digit code. Requires recent authentication. Turns 2FA on, signs out the Buyer\&#39;s other devices and returns 8 single-use recovery codes once. From then on every Buyer sign-in, including Google, needs an authenticator or recovery code. A wrong code is 422 MFA_CODE_INVALID.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { ConfirmBuyerTwoFactorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // BuyerTwoFactorConfirmation
    buyerTwoFactorConfirmation: ...,
  } satisfies ConfirmBuyerTwoFactorRequest;

  try {
    const data = await api.confirmBuyerTwoFactor(body);
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
| **buyerTwoFactorConfirmation** | [BuyerTwoFactorConfirmation](BuyerTwoFactorConfirmation.md) |  | |

### Return type

[**AccountRecoveryCodesEnvelope**](AccountRecoveryCodesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | 2FA enabled. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## deleteBuyerAccount

> BuyerAccountDeletionResultEnvelope deleteBuyerAccount(buyerAccountDeletionRequest)



Deletes the signed-in Buyer account. Requires recent authentication and the typed confirmation phrase. Refused with 409 ACCOUNT_DELETION_BLOCKED (details.blockers) while an order, dispute or refund is open. The account becomes DELETED (final), every session, push device and authenticator is revoked and an IN_APP DELETION privacy request is opened. Orders, payments, disputes, reviews and audit records are retained and later minimized, never deleted.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { DeleteBuyerAccountRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // BuyerAccountDeletionRequest
    buyerAccountDeletionRequest: ...,
  } satisfies DeleteBuyerAccountRequest;

  try {
    const data = await api.deleteBuyerAccount(body);
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
| **buyerAccountDeletionRequest** | [BuyerAccountDeletionRequest](BuyerAccountDeletionRequest.md) |  | |

### Return type

[**BuyerAccountDeletionResultEnvelope**](BuyerAccountDeletionResultEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Account deleted and signed out. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## deleteVendorTeamInvitation

> AccountMutationResultEnvelope deleteVendorTeamInvitation(invitationId, vendorTeamDeletion)



Owner only. Allowed for unaccepted expired invitations or accepted invitations linked to a deleted membership. Otherwise returns TEAM_INVITATION_NOT_DELETABLE. Stale lock_version returns RESOURCE_VERSION_CONFLICT. Requires recent authentication and current agreements. Repeated deletion succeeds without duplicating audit events.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { DeleteVendorTeamInvitationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // string
    invitationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorTeamDeletion
    vendorTeamDeletion: ...,
  } satisfies DeleteVendorTeamInvitationRequest;

  try {
    const data = await api.deleteVendorTeamInvitation(body);
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
| **invitationId** | `string` |  | [Defaults to `undefined`] |
| **vendorTeamDeletion** | [VendorTeamDeletion](VendorTeamDeletion.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Team record removed from management lists; historical attribution retained. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## deleteVendorTeamMember

> AccountMutationResultEnvelope deleteVendorTeamMember(membershipId, vendorTeamDeletion)



Owner only, scoped to the current organization. Only DEACTIVATED non-Owner memberships can be deleted; otherwise TEAM_ACCOUNT_NOT_DEACTIVATED. Deleted memberships cannot be edited or reactivated. Stale lock_version returns RESOURCE_VERSION_CONFLICT. Requires recent authentication and current agreements. Repeated deletion succeeds without duplicating audit events.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { DeleteVendorTeamMemberRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // string
    membershipId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorTeamDeletion
    vendorTeamDeletion: ...,
  } satisfies DeleteVendorTeamMemberRequest;

  try {
    const data = await api.deleteVendorTeamMember(body);
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
| **membershipId** | `string` |  | [Defaults to `undefined`] |
| **vendorTeamDeletion** | [VendorTeamDeletion](VendorTeamDeletion.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Team record removed from management lists; historical attribution retained. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## disableBuyerTwoFactor

> AccountMutationResultEnvelope disableBuyerTwoFactor(buyerTwoFactorDisable)



Turns the Buyer\&#39;s authenticator off. Requires recent authentication plus a fresh authenticator code or an unused recovery code. Retires every recovery code, spends the recent-authentication proof and emails a security notice.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { DisableBuyerTwoFactorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // BuyerTwoFactorDisable
    buyerTwoFactorDisable: ...,
  } satisfies DisableBuyerTwoFactorRequest;

  try {
    const data = await api.disableBuyerTwoFactor(body);
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
| **buyerTwoFactorDisable** | [BuyerTwoFactorDisable](BuyerTwoFactorDisable.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | 2FA disabled. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAccountPhoto

> Blob getAccountPhoto(expires, signature, version, owner, webAccountPortal)



Use the five-minute signed avatar_url from the profile. Authenticated owner only; private no-store response. No user identifier is accepted.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { GetAccountPhotoRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // number
    expires: 56,
    // string
    signature: signature_example,
    // number
    version: 56,
    // string
    owner: owner_example,
    // 'vendors' | 'admin'
    webAccountPortal: webAccountPortal_example,
  } satisfies GetAccountPhotoRequest;

  try {
    const data = await api.getAccountPhoto(body);
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
| **expires** | `number` |  | [Defaults to `undefined`] |
| **signature** | `string` |  | [Defaults to `undefined`] |
| **version** | `number` |  | [Defaults to `undefined`] |
| **owner** | `string` |  | [Defaults to `undefined`] |
| **webAccountPortal** | `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: vendors, admin] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `image/png`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Sanitized personal photo. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getBuyerAccountDeletionPreview

> BuyerAccountDeletionPreviewEnvelope getBuyerAccountDeletionPreview()



What deleting the account keeps and whether open orders, disputes or pending refunds block it. Shown before the Buyer confirms.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { GetBuyerAccountDeletionPreviewRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  try {
    const data = await api.getBuyerAccountDeletionPreview();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**BuyerAccountDeletionPreviewEnvelope**](BuyerAccountDeletionPreviewEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Deletion preview. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getBuyerAccountPhoto

> Blob getBuyerAccountPhoto(expires, owner, version, signature)



Use the five-minute signed avatar_url from the Buyer profile through an authenticated request. Owner and current profile version are checked on every fetch. Private no-store response; the signed URL alone grants no access.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { GetBuyerAccountPhotoRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // number
    expires: 56,
    // string
    owner: owner_example,
    // number
    version: 56,
    // string
    signature: signature_example,
  } satisfies GetBuyerAccountPhotoRequest;

  try {
    const data = await api.getBuyerAccountPhoto(body);
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
| **expires** | `number` |  | [Defaults to `undefined`] |
| **owner** | `string` |  | [Defaults to `undefined`] |
| **version** | `number` |  | [Defaults to `undefined`] |
| **signature** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `image/png`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Sanitized personal photo. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAccountMemberships

> AccountMembershipListEnvelope listAccountMemberships(accountPortal, page, search, role)



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
    // string (optional)
    search: search_example,
    // 'OWNER' | 'STORE_MANAGER' | 'STORE_STAFF' | 'CUSTOMER_SERVICE' | 'INVENTORY' | 'FULFILLMENT' (optional)
    role: role_example,
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
| **search** | `string` |  | [Optional] [Defaults to `undefined`] |
| **role** | `OWNER`, `STORE_MANAGER`, `STORE_STAFF`, `CUSTOMER_SERVICE`, `INVENTORY`, `FULFILLMENT` |  | [Optional] [Defaults to `undefined`] [Enum: OWNER, STORE_MANAGER, STORE_STAFF, CUSTOMER_SERVICE, INVENTORY, FULFILLMENT] |

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



Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security. Requires an enrolled authenticator; a Buyer with optional 2FA may also regenerate codes. Previous codes stop working and the recent-authentication proof is spent.

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
    // 'buyers' | 'vendors' | 'admin'
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
| **accountPortal** | `buyers`, `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendors, admin] |

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


## startBuyerTwoFactor

> BuyerTwoFactorEnrollmentEnvelope startBuyerTwoFactor()



Starts optional authenticator-app (TOTP, RFC 6238, SHA-1, 6 digits, 30 seconds) enrollment for the signed-in Buyer. Requires session-bound recent authentication. Returns the setup key and otpauth provisioning URI for a QR code or copy/paste; calling again before confirmation returns the same pending key. The key is shown only to the owner and is never logged.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { StartBuyerTwoFactorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  try {
    const data = await api.startBuyerTwoFactor();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**BuyerTwoFactorEnrollmentEnvelope**](BuyerTwoFactorEnrollmentEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Pending authenticator setup. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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
| **503** | Safe canonical error with correlation identifier. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## updateVendorStaff

> AccountMutationResultEnvelope updateVendorStaff(membershipId, vendorStaffUpdate)



### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { UpdateVendorStaffRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // string
    membershipId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorStaffUpdate
    vendorStaffUpdate: ...,
  } satisfies UpdateVendorStaffRequest;

  try {
    const data = await api.updateVendorStaff(body);
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
| **membershipId** | `string` |  | [Defaults to `undefined`] |
| **vendorStaffUpdate** | [VendorStaffUpdate](VendorStaffUpdate.md) |  | |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Staff information and role updated; sessions revoked; audit history preserved. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## uploadAccountPhoto

> AccountProfileEnvelope uploadAccountPhoto(webAccountPortal, photo, lockVersion)



Owner-only personal photo. Maximum 2 MB JPEG/PNG/WebP and 4096 pixels per dimension. Malware-scanned, re-encoded to 256px PNG, privately stored. Fails closed if scanning or processing is unavailable.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { UploadAccountPhotoRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'vendors' | 'admin'
    webAccountPortal: webAccountPortal_example,
    // Blob
    photo: BINARY_DATA_HERE,
    // number
    lockVersion: 56,
  } satisfies UploadAccountPhotoRequest;

  try {
    const data = await api.uploadAccountPhoto(body);
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
| **webAccountPortal** | `vendors`, `admin` |  | [Defaults to `undefined`] [Enum: vendors, admin] |
| **photo** | `Blob` |  | [Defaults to `undefined`] |
| **lockVersion** | `number` |  | [Defaults to `undefined`] |

### Return type

[**AccountProfileEnvelope**](AccountProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated personal profile. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **419** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## uploadBuyerAccountPhoto

> AccountProfileEnvelope uploadBuyerAccountPhoto(photo, lockVersion)



Authenticated Buyer\&#39;s own personal photo. Maximum 2 MB JPEG/PNG/WebP and 4096 pixels per dimension. Uses the shared malware scan, 256px PNG sanitization, private storage and profile version checks. Fails closed if scanning or processing is unavailable.

### Example

```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { UploadBuyerAccountPhotoRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AccountsApi(config);

  const body = {
    // Blob
    photo: BINARY_DATA_HERE,
    // number
    lockVersion: 56,
  } satisfies UploadBuyerAccountPhotoRequest;

  try {
    const data = await api.uploadBuyerAccountPhoto(body);
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
| **photo** | `Blob` |  | [Defaults to `undefined`] |
| **lockVersion** | `number` |  | [Defaults to `undefined`] |

### Return type

[**AccountProfileEnvelope**](AccountProfileEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated personal profile. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

