# VendorOnboardingApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**acceptVendorCommissionTerms**](VendorOnboardingApi.md#acceptvendorcommissionterms) | **POST** /vendors/{organization}/commission-terms/acceptance | accept Vendor Commission Terms |
| [**activateVendorMarketplace**](VendorOnboardingApi.md#activatevendormarketplace) | **POST** /vendors/{organization}/activation | activate Vendor Marketplace |
| [**changeVendorTeamMember**](VendorOnboardingApi.md#changevendorteammember) | **PATCH** /vendors/{organization}/team/memberships/{membership} | change Vendor Team Member |
| [**confirmVendorStoreEmailVerification**](VendorOnboardingApi.md#confirmvendorstoreemailverification) | **POST** /vendors/{organization}/business/store-email/verification/confirm | confirm Vendor Store Email Verification |
| [**connectVendorTest**](VendorOnboardingApi.md#connectvendortest) | **POST** /vendors/{organization}/payment-connection | connect Vendor Test |
| [**downloadAdminVendorDocument**](VendorOnboardingApi.md#downloadadminvendordocument) | **GET** /admin/vendor-verification/{organization}/documents/{version}/download | download Admin Vendor Document |
| [**downloadVendorDocument**](VendorOnboardingApi.md#downloadvendordocument) | **GET** /vendors/{organization}/documents/{version}/download | download Vendor Document |
| [**getAdminVendorBusiness**](VendorOnboardingApi.md#getadminvendorbusiness) | **GET** /admin/vendor-verification/{organization}/business | get Admin Vendor Business |
| [**getAdminVendorReadiness**](VendorOnboardingApi.md#getadminvendorreadiness) | **GET** /admin/vendor-verification/{organization}/onboarding | get Admin Vendor Readiness |
| [**getAdminVendorTaxProfile**](VendorOnboardingApi.md#getadminvendortaxprofile) | **GET** /admin/vendor-verification/{organization}/tax-profile | get Admin Vendor Tax Profile |
| [**getPublicVendorStoreMedia**](VendorOnboardingApi.md#getpublicvendorstoremedia) | **GET** /public/vendors/{organization}/store-media/{media} | get Public Vendor Store Media |
| [**getVendorBusiness**](VendorOnboardingApi.md#getvendorbusiness) | **GET** /vendors/{organization}/business | get Vendor Business |
| [**getVendorCommissionTerms**](VendorOnboardingApi.md#getvendorcommissionterms) | **GET** /vendors/{organization}/commission-terms | get Vendor Commission Terms |
| [**getVendorReadiness**](VendorOnboardingApi.md#getvendorreadiness) | **GET** /vendors/{organization}/onboarding | get Vendor Readiness |
| [**getVendorSetup**](VendorOnboardingApi.md#getvendorsetup) | **GET** /vendors/{organization}/setup | get Vendor Setup |
| [**getVendorTaxProfile**](VendorOnboardingApi.md#getvendortaxprofile) | **GET** /vendors/{organization}/tax-profile | get Vendor Tax Profile |
| [**getVendorTeam**](VendorOnboardingApi.md#getvendorteam) | **GET** /vendors/{organization}/team | get Vendor Team |
| [**inviteVendorTeam**](VendorOnboardingApi.md#invitevendorteam) | **POST** /vendors/{organization}/team/invitations | invite Vendor Team |
| [**issueAdminVendorDocumentLink**](VendorOnboardingApi.md#issueadminvendordocumentlink) | **POST** /admin/vendor-verification/{organization}/documents/{version}/download-link | issue Admin Vendor Document Link |
| [**issueVendorDocumentLink**](VendorOnboardingApi.md#issuevendordocumentlink) | **POST** /vendors/{organization}/documents/{version}/download-link | issue Vendor Document Link |
| [**listAdminVendorDocuments**](VendorOnboardingApi.md#listadminvendordocuments) | **GET** /admin/vendor-verification/{organization}/documents | list Admin Vendor Documents |
| [**listAdminVendorStoreMedia**](VendorOnboardingApi.md#listadminvendorstoremedia) | **GET** /admin/vendor-verification/{organization}/store-media | list Admin Vendor Store Media |
| [**listVendorDocuments**](VendorOnboardingApi.md#listvendordocuments) | **GET** /vendors/{organization}/documents | list Vendor Documents |
| [**listVendorStoreMedia**](VendorOnboardingApi.md#listvendorstoremedia) | **GET** /vendors/{organization}/store-media | list Vendor Store Media |
| [**listVendorTeamInvitations**](VendorOnboardingApi.md#listvendorteaminvitations) | **GET** /vendors/{organization}/team/invitations | list Vendor Team Invitations |
| [**listVendorVerificationQueue**](VendorOnboardingApi.md#listvendorverificationqueue) | **GET** /admin/vendor-verification | list Vendor Verification Queue |
| [**previewAdminVendorStoreMedia**](VendorOnboardingApi.md#previewadminvendorstoremedia) | **GET** /admin/vendor-verification/{organization}/store-media/{media} | preview Admin Vendor Store Media |
| [**previewVendorStoreMedia**](VendorOnboardingApi.md#previewvendorstoremedia) | **GET** /vendors/{organization}/store-media/{media} | preview Vendor Store Media |
| [**reconcileVendorTestConnection**](VendorOnboardingApi.md#reconcilevendortestconnection) | **POST** /vendors/{organization}/payment-connection/reconciliation | reconcile Vendor Test Connection |
| [**removeVendorStoreMedia**](VendorOnboardingApi.md#removevendorstoremedia) | **POST** /vendors/{organization}/store-media/{media}/remove | remove Vendor Store Media |
| [**requestVendorStoreEmailVerification**](VendorOnboardingApi.md#requestvendorstoreemailverification) | **POST** /vendors/{organization}/business/store-email/verification | request Vendor Store Email Verification |
| [**reviewVendorBusiness**](VendorOnboardingApi.md#reviewvendorbusiness) | **POST** /admin/vendor-verification/{organization}/business/reviews | review Vendor Business |
| [**reviewVendorDocument**](VendorOnboardingApi.md#reviewvendordocument) | **POST** /admin/vendor-verification/{organization}/documents/{version}/reviews | review Vendor Document |
| [**reviewVendorStoreMedia**](VendorOnboardingApi.md#reviewvendorstoremedia) | **POST** /admin/vendor-verification/{organization}/store-media/{media}/reviews | review Vendor Store Media |
| [**reviewVendorTaxProfile**](VendorOnboardingApi.md#reviewvendortaxprofile) | **POST** /admin/vendor-verification/{organization}/tax-profile/versions/{version}/reviews | review Vendor Tax Profile |
| [**revokeVendorTeamInvitation**](VendorOnboardingApi.md#revokevendorteaminvitation) | **POST** /vendors/{organization}/team/invitations/{invitation}/revoke | revoke Vendor Team Invitation |
| [**saveVendorBusiness**](VendorOnboardingApi.md#savevendorbusiness) | **PUT** /vendors/{organization}/business | save Vendor Business |
| [**saveVendorStore**](VendorOnboardingApi.md#savevendorstore) | **PUT** /vendors/{organization}/store-profile | save Vendor Store |
| [**saveVendorTaxProfile**](VendorOnboardingApi.md#savevendortaxprofile) | **POST** /vendors/{organization}/tax-profile/versions | save Vendor Tax Profile |
| [**uploadVendorDocument**](VendorOnboardingApi.md#uploadvendordocument) | **POST** /vendors/{organization}/documents | upload Vendor Document |
| [**uploadVendorStoreMedia**](VendorOnboardingApi.md#uploadvendorstoremedia) | **POST** /vendors/{organization}/store-media | upload Vendor Store Media |



## acceptVendorCommissionTerms

> VendorCommissionTermsEnvelope acceptVendorCommissionTerms(organization, acceptVendorCommission)

accept Vendor Commission Terms

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { AcceptVendorCommissionTermsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AcceptVendorCommission
    acceptVendorCommission: ...,
  } satisfies AcceptVendorCommissionTermsRequest;

  try {
    const data = await api.acceptVendorCommissionTerms(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **acceptVendorCommission** | [AcceptVendorCommission](AcceptVendorCommission.md) |  | |

### Return type

[**VendorCommissionTermsEnvelope**](VendorCommissionTermsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## activateVendorMarketplace

> VendorReadinessEnvelope activateVendorMarketplace(organization, vendorVersionMutation)

activate Vendor Marketplace

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ActivateVendorMarketplaceRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorVersionMutation
    vendorVersionMutation: ...,
  } satisfies ActivateVendorMarketplaceRequest;

  try {
    const data = await api.activateVendorMarketplace(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **vendorVersionMutation** | [VendorVersionMutation](VendorVersionMutation.md) |  | |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## changeVendorTeamMember

> VendorMutationEnvelope changeVendorTeamMember(organization, membership, changeVendorTeamMember)

change Vendor Team Member

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ChangeVendorTeamMemberRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    membership: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChangeVendorTeamMember
    changeVendorTeamMember: ...,
  } satisfies ChangeVendorTeamMemberRequest;

  try {
    const data = await api.changeVendorTeamMember(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **membership** | `string` |  | [Defaults to `undefined`] |
| **changeVendorTeamMember** | [ChangeVendorTeamMember](ChangeVendorTeamMember.md) |  | |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## confirmVendorStoreEmailVerification

> VendorBusinessEnvelope confirmVendorStoreEmailVerification(organization, vendorStoreEmailVerificationConfirmation)

confirm Vendor Store Email Verification

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ConfirmVendorStoreEmailVerificationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorStoreEmailVerificationConfirmation
    vendorStoreEmailVerificationConfirmation: ...,
  } satisfies ConfirmVendorStoreEmailVerificationRequest;

  try {
    const data = await api.confirmVendorStoreEmailVerification(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **vendorStoreEmailVerificationConfirmation** | [VendorStoreEmailVerificationConfirmation](VendorStoreEmailVerificationConfirmation.md) |  | |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## connectVendorTest

> VendorSetupEnvelope connectVendorTest(organization, connectVendorTest)

connect Vendor Test

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ConnectVendorTestRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ConnectVendorTest
    connectVendorTest: ...,
  } satisfies ConnectVendorTestRequest;

  try {
    const data = await api.connectVendorTest(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **connectVendorTest** | [ConnectVendorTest](ConnectVendorTest.md) |  | |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## downloadAdminVendorDocument

> Blob downloadAdminVendorDocument(organization, version, expires, signature, viewer)

download Admin Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { DownloadAdminVendorDocumentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    version: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    expires: expires_example,
    // string
    signature: signature_example,
    // string
    viewer: viewer_example,
  } satisfies DownloadAdminVendorDocumentRequest;

  try {
    const data = await api.downloadAdminVendorDocument(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **version** | `string` |  | [Defaults to `undefined`] |
| **expires** | `string` |  | [Defaults to `undefined`] |
| **signature** | `string` |  | [Defaults to `undefined`] |
| **viewer** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## downloadVendorDocument

> Blob downloadVendorDocument(organization, version, expires, signature, viewer)

download Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { DownloadVendorDocumentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    version: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    expires: expires_example,
    // string
    signature: signature_example,
    // string
    viewer: viewer_example,
  } satisfies DownloadVendorDocumentRequest;

  try {
    const data = await api.downloadVendorDocument(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **version** | `string` |  | [Defaults to `undefined`] |
| **expires** | `string` |  | [Defaults to `undefined`] |
| **signature** | `string` |  | [Defaults to `undefined`] |
| **viewer** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAdminVendorBusiness

> VendorBusinessEnvelope getAdminVendorBusiness(organization)

get Admin Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetAdminVendorBusinessRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetAdminVendorBusinessRequest;

  try {
    const data = await api.getAdminVendorBusiness(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAdminVendorReadiness

> VendorReadinessEnvelope getAdminVendorReadiness(organization)

get Admin Vendor Readiness

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetAdminVendorReadinessRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetAdminVendorReadinessRequest;

  try {
    const data = await api.getAdminVendorReadiness(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAdminVendorTaxProfile

> VendorTaxProfileEnvelope getAdminVendorTaxProfile(organization)

get Admin Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetAdminVendorTaxProfileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetAdminVendorTaxProfileRequest;

  try {
    const data = await api.getAdminVendorTaxProfile(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorTaxProfileEnvelope**](VendorTaxProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getPublicVendorStoreMedia

> Blob getPublicVendorStoreMedia(organization, media)

get Public Vendor Store Media

Public delivery for an approved, unreplaced Store Profile image belonging to an active Vendor.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetPublicVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new VendorOnboardingApi();

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    media: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetPublicVendorStoreMediaRequest;

  try {
    const data = await api.getPublicVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **media** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorBusiness

> VendorBusinessEnvelope getVendorBusiness(organization)

get Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorBusinessRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorBusinessRequest;

  try {
    const data = await api.getVendorBusiness(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorCommissionTerms

> VendorCommissionTermsEnvelope getVendorCommissionTerms(organization)

get Vendor Commission Terms

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorCommissionTermsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorCommissionTermsRequest;

  try {
    const data = await api.getVendorCommissionTerms(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorCommissionTermsEnvelope**](VendorCommissionTermsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorReadiness

> VendorReadinessEnvelope getVendorReadiness(organization)

get Vendor Readiness

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorReadinessRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorReadinessRequest;

  try {
    const data = await api.getVendorReadiness(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorSetup

> VendorSetupEnvelope getVendorSetup(organization)

get Vendor Setup

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorSetupRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorSetupRequest;

  try {
    const data = await api.getVendorSetup(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorTaxProfile

> VendorTaxProfileEnvelope getVendorTaxProfile(organization)

get Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorTaxProfileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorTaxProfileRequest;

  try {
    const data = await api.getVendorTaxProfile(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorTaxProfileEnvelope**](VendorTaxProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorTeam

> VendorTeamEnvelope getVendorTeam(organization, page, perPage)

get Vendor Team

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorTeamRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
    // number (optional)
    perPage: 56,
  } satisfies GetVendorTeamRequest;

  try {
    const data = await api.getVendorTeam(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `1`] |
| **perPage** | `number` |  | [Optional] [Defaults to `20`] |

### Return type

[**VendorTeamEnvelope**](VendorTeamEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## inviteVendorTeam

> VendorMutationEnvelope inviteVendorTeam(organization, idempotencyKey, inviteVendorTeam)

invite Vendor Team

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { InviteVendorTeamRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // InviteVendorTeam
    inviteVendorTeam: ...,
  } satisfies InviteVendorTeamRequest;

  try {
    const data = await api.inviteVendorTeam(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **inviteVendorTeam** | [InviteVendorTeam](InviteVendorTeam.md) |  | |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## issueAdminVendorDocumentLink

> VendorDownloadLinkEnvelope issueAdminVendorDocumentLink(organization, version)

issue Admin Vendor Document Link

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { IssueAdminVendorDocumentLinkRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    version: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies IssueAdminVendorDocumentLinkRequest;

  try {
    const data = await api.issueAdminVendorDocumentLink(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **version** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorDownloadLinkEnvelope**](VendorDownloadLinkEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## issueVendorDocumentLink

> VendorDownloadLinkEnvelope issueVendorDocumentLink(organization, version)

issue Vendor Document Link

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { IssueVendorDocumentLinkRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    version: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies IssueVendorDocumentLinkRequest;

  try {
    const data = await api.issueVendorDocumentLink(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **version** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorDownloadLinkEnvelope**](VendorDownloadLinkEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAdminVendorDocuments

> VendorDocumentListEnvelope listAdminVendorDocuments(organization, page, perPage)

list Admin Vendor Documents

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ListAdminVendorDocumentsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
    // number (optional)
    perPage: 56,
  } satisfies ListAdminVendorDocumentsRequest;

  try {
    const data = await api.listAdminVendorDocuments(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `1`] |
| **perPage** | `number` |  | [Optional] [Defaults to `20`] |

### Return type

[**VendorDocumentListEnvelope**](VendorDocumentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAdminVendorStoreMedia

> VendorStoreMediaListEnvelope listAdminVendorStoreMedia(organization)

list Admin Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ListAdminVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ListAdminVendorStoreMediaRequest;

  try {
    const data = await api.listAdminVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorStoreMediaListEnvelope**](VendorStoreMediaListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listVendorDocuments

> VendorDocumentListEnvelope listVendorDocuments(organization, page, perPage)

list Vendor Documents

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ListVendorDocumentsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
    // number (optional)
    perPage: 56,
  } satisfies ListVendorDocumentsRequest;

  try {
    const data = await api.listVendorDocuments(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `1`] |
| **perPage** | `number` |  | [Optional] [Defaults to `20`] |

### Return type

[**VendorDocumentListEnvelope**](VendorDocumentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listVendorStoreMedia

> VendorStoreMediaListEnvelope listVendorStoreMedia(organization)

list Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ListVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ListVendorStoreMediaRequest;

  try {
    const data = await api.listVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorStoreMediaListEnvelope**](VendorStoreMediaListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listVendorTeamInvitations

> VendorTeamInvitationListEnvelope listVendorTeamInvitations(organization, page, perPage)

list Vendor Team Invitations

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ListVendorTeamInvitationsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
    // number (optional)
    perPage: 56,
  } satisfies ListVendorTeamInvitationsRequest;

  try {
    const data = await api.listVendorTeamInvitations(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `1`] |
| **perPage** | `number` |  | [Optional] [Defaults to `20`] |

### Return type

[**VendorTeamInvitationListEnvelope**](VendorTeamInvitationListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listVendorVerificationQueue

> VendorVerificationRowListEnvelope listVendorVerificationQueue(page, perPage)

list Vendor Verification Queue

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ListVendorVerificationQueueRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // number (optional)
    page: 56,
    // number (optional)
    perPage: 56,
  } satisfies ListVendorVerificationQueueRequest;

  try {
    const data = await api.listVendorVerificationQueue(body);
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
| **page** | `number` |  | [Optional] [Defaults to `1`] |
| **perPage** | `number` |  | [Optional] [Defaults to `20`] |

### Return type

[**VendorVerificationRowListEnvelope**](VendorVerificationRowListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## previewAdminVendorStoreMedia

> Blob previewAdminVendorStoreMedia(organization, media)

preview Admin Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { PreviewAdminVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    media: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies PreviewAdminVendorStoreMediaRequest;

  try {
    const data = await api.previewAdminVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **media** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## previewVendorStoreMedia

> Blob previewVendorStoreMedia(organization, media)

preview Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { PreviewVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    media: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies PreviewVendorStoreMediaRequest;

  try {
    const data = await api.previewVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **media** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reconcileVendorTestConnection

> VendorSetupEnvelope reconcileVendorTestConnection(organization, vendorVersionMutation)

reconcile Vendor Test Connection

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReconcileVendorTestConnectionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorVersionMutation
    vendorVersionMutation: ...,
  } satisfies ReconcileVendorTestConnectionRequest;

  try {
    const data = await api.reconcileVendorTestConnection(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **vendorVersionMutation** | [VendorVersionMutation](VendorVersionMutation.md) |  | |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## removeVendorStoreMedia

> VendorMutationEnvelope removeVendorStoreMedia(organization, media, vendorVersionMutation)

remove Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { RemoveVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    media: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorVersionMutation
    vendorVersionMutation: ...,
  } satisfies RemoveVendorStoreMediaRequest;

  try {
    const data = await api.removeVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **media** | `string` |  | [Defaults to `undefined`] |
| **vendorVersionMutation** | [VendorVersionMutation](VendorVersionMutation.md) |  | |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## requestVendorStoreEmailVerification

> VendorBusinessEnvelope requestVendorStoreEmailVerification(organization, vendorStoreEmailVerificationRequest)

request Vendor Store Email Verification

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { RequestVendorStoreEmailVerificationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorStoreEmailVerificationRequest
    vendorStoreEmailVerificationRequest: ...,
  } satisfies RequestVendorStoreEmailVerificationRequest;

  try {
    const data = await api.requestVendorStoreEmailVerification(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **vendorStoreEmailVerificationRequest** | [VendorStoreEmailVerificationRequest](VendorStoreEmailVerificationRequest.md) |  | |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reviewVendorBusiness

> VendorReadinessEnvelope reviewVendorBusiness(organization, vendorBusinessReview)

review Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReviewVendorBusinessRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorBusinessReview
    vendorBusinessReview: ...,
  } satisfies ReviewVendorBusinessRequest;

  try {
    const data = await api.reviewVendorBusiness(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **vendorBusinessReview** | [VendorBusinessReview](VendorBusinessReview.md) |  | |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reviewVendorDocument

> VendorReadinessEnvelope reviewVendorDocument(organization, version, vendorDocumentReview)

review Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReviewVendorDocumentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    version: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorDocumentReview
    vendorDocumentReview: ...,
  } satisfies ReviewVendorDocumentRequest;

  try {
    const data = await api.reviewVendorDocument(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **version** | `string` |  | [Defaults to `undefined`] |
| **vendorDocumentReview** | [VendorDocumentReview](VendorDocumentReview.md) |  | |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reviewVendorStoreMedia

> VendorMutationEnvelope reviewVendorStoreMedia(organization, media, vendorReview)

review Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReviewVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    media: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorReview
    vendorReview: ...,
  } satisfies ReviewVendorStoreMediaRequest;

  try {
    const data = await api.reviewVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **media** | `string` |  | [Defaults to `undefined`] |
| **vendorReview** | [VendorReview](VendorReview.md) |  | |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reviewVendorTaxProfile

> VendorReadinessEnvelope reviewVendorTaxProfile(organization, version, vendorReview)

review Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReviewVendorTaxProfileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    version: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorReview
    vendorReview: ...,
  } satisfies ReviewVendorTaxProfileRequest;

  try {
    const data = await api.reviewVendorTaxProfile(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **version** | `string` |  | [Defaults to `undefined`] |
| **vendorReview** | [VendorReview](VendorReview.md) |  | |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## revokeVendorTeamInvitation

> VendorMutationEnvelope revokeVendorTeamInvitation(organization, invitation, vendorVersionMutation)

revoke Vendor Team Invitation

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { RevokeVendorTeamInvitationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    invitation: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorVersionMutation
    vendorVersionMutation: ...,
  } satisfies RevokeVendorTeamInvitationRequest;

  try {
    const data = await api.revokeVendorTeamInvitation(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **invitation** | `string` |  | [Defaults to `undefined`] |
| **vendorVersionMutation** | [VendorVersionMutation](VendorVersionMutation.md) |  | |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveVendorBusiness

> VendorBusinessEnvelope saveVendorBusiness(organization, saveVendorBusiness)

save Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { SaveVendorBusinessRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // SaveVendorBusiness
    saveVendorBusiness: ...,
  } satisfies SaveVendorBusinessRequest;

  try {
    const data = await api.saveVendorBusiness(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **saveVendorBusiness** | [SaveVendorBusiness](SaveVendorBusiness.md) |  | |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveVendorStore

> VendorSetupEnvelope saveVendorStore(organization, saveVendorStore)

save Vendor Store

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { SaveVendorStoreRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // SaveVendorStore
    saveVendorStore: ...,
  } satisfies SaveVendorStoreRequest;

  try {
    const data = await api.saveVendorStore(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **saveVendorStore** | [SaveVendorStore](SaveVendorStore.md) |  | |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveVendorTaxProfile

> VendorTaxProfileEnvelope saveVendorTaxProfile(organization, saveVendorTax)

save Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { SaveVendorTaxProfileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // SaveVendorTax
    saveVendorTax: ...,
  } satisfies SaveVendorTaxProfileRequest;

  try {
    const data = await api.saveVendorTaxProfile(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **saveVendorTax** | [SaveVendorTax](SaveVendorTax.md) |  | |

### Return type

[**VendorTaxProfileEnvelope**](VendorTaxProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## uploadVendorDocument

> VendorDocumentUploadEnvelope uploadVendorDocument(organization, lockVersion, documentType, file)

upload Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { UploadVendorDocumentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number
    lockVersion: 56,
    // string
    documentType: documentType_example,
    // Blob
    file: BINARY_DATA_HERE,
  } satisfies UploadVendorDocumentRequest;

  try {
    const data = await api.uploadVendorDocument(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **lockVersion** | `number` |  | [Defaults to `undefined`] |
| **documentType** | `GOVERNMENT_ID`, `DTI`, `SEC`, `CDA`, `LGU_PERMIT`, `BIR_COR`, `REGULATORY`, `ISO_CERTIFICATION`, `TAX_DECLARATION`, `WITHHOLDING_DECLARATION` |  | [Defaults to `undefined`] [Enum: GOVERNMENT_ID, DTI, SEC, CDA, LGU_PERMIT, BIR_COR, REGULATORY, ISO_CERTIFICATION, TAX_DECLARATION, WITHHOLDING_DECLARATION] |
| **file** | `Blob` |  | [Defaults to `undefined`] |

### Return type

[**VendorDocumentUploadEnvelope**](VendorDocumentUploadEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## uploadVendorStoreMedia

> VendorMutationEnvelope uploadVendorStoreMedia(organization, lockVersion, kind, altText, file)

upload Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { UploadVendorStoreMediaRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    organization: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number
    lockVersion: 56,
    // string
    kind: kind_example,
    // string
    altText: altText_example,
    // Blob
    file: BINARY_DATA_HERE,
  } satisfies UploadVendorStoreMediaRequest;

  try {
    const data = await api.uploadVendorStoreMedia(body);
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
| **organization** | `string` |  | [Defaults to `undefined`] |
| **lockVersion** | `number` |  | [Defaults to `undefined`] |
| **kind** | `LOGO`, `BANNER`, `PROMOTIONAL` |  | [Defaults to `undefined`] [Enum: LOGO, BANNER, PROMOTIONAL] |
| **altText** | `string` |  | [Defaults to `undefined`] |
| **file** | `Blob` |  | [Defaults to `undefined`] |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Operation completed. |  -  |
| **401** | Safe canonical error envelope. |  -  |
| **403** | Safe canonical error envelope. |  -  |
| **404** | Safe canonical error envelope. |  -  |
| **409** | Safe canonical error envelope. |  -  |
| **422** | Safe canonical error envelope. |  -  |
| **429** | Safe canonical error envelope. |  -  |
| **503** | Safe canonical error envelope. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

