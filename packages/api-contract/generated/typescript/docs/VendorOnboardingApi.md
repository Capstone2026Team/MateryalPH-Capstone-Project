# VendorOnboardingApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**activateVendorStore**](VendorOnboardingApi.md#activatevendorstore) | **POST** /vendors/onboarding/activation |  |
| [**captureVendorPaymentConnection**](VendorOnboardingApi.md#capturevendorpaymentconnection) | **POST** /vendors/onboarding/payment-connection |  |
| [**completeVendorSetup**](VendorOnboardingApi.md#completevendorsetup) | **POST** /vendors/onboarding/setup/complete |  |
| [**confirmVendorStoreEmailVerification**](VendorOnboardingApi.md#confirmvendorstoreemailverification) | **POST** /vendors/onboarding/store-email/confirm |  |
| [**dismissVendorOnboardingWelcome**](VendorOnboardingApi.md#dismissvendoronboardingwelcome) | **POST** /vendors/onboarding/welcome/dismiss |  |
| [**downloadVendorOnboardingFile**](VendorOnboardingApi.md#downloadvendoronboardingfile) | **GET** /vendor-onboarding-files/{fileId}/content |  |
| [**getVendorOnboarding**](VendorOnboardingApi.md#getvendoronboarding) | **GET** /vendors/onboarding |  |
| [**getVendorPrivateFileUrl**](VendorOnboardingApi.md#getvendorprivatefileurl) | **GET** /vendors/onboarding/files/{fileId} |  |
| [**inviteVendorTeamMember**](VendorOnboardingApi.md#invitevendorteammember) | **POST** /vendors/account/invitations |  |
| [**receiveXenditAccountVerificationWebhook**](VendorOnboardingApi.md#receivexenditaccountverificationwebhook) | **POST** /webhooks/xendit/account-verification |  |
| [**reconcileVendorPaymentConnection**](VendorOnboardingApi.md#reconcilevendorpaymentconnection) | **POST** /vendors/onboarding/payment-connection/reconcile |  |
| [**requestVendorStoreEmailVerification**](VendorOnboardingApi.md#requestvendorstoreemailverification) | **POST** /vendors/onboarding/store-email |  |
| [**reverseGeocodeVendorAddress**](VendorOnboardingApi.md#reversegeocodevendoraddress) | **POST** /vendors/onboarding/address/geocode |  |
| [**saveVendorSetupDraft**](VendorOnboardingApi.md#savevendorsetupdraft) | **PATCH** /vendors/onboarding/setup |  |
| [**saveVendorVerificationDraft**](VendorOnboardingApi.md#savevendorverificationdraft) | **PATCH** /vendors/onboarding/verification |  |
| [**submitVendorVerification**](VendorOnboardingApi.md#submitvendorverification) | **POST** /vendors/onboarding/verification/submit |  |
| [**uploadVendorStoreMedia**](VendorOnboardingApi.md#uploadvendorstoremedia) | **POST** /vendors/onboarding/media |  |
| [**uploadVendorVerificationDocument**](VendorOnboardingApi.md#uploadvendorverificationdocument) | **POST** /vendors/onboarding/documents |  |



## activateVendorStore

> VendorOnboardingEnvelope activateVendorStore(idempotencyKey)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ActivateVendorStoreRequest } from '@materyalph/api-client-ts';

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
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ActivateVendorStoreRequest;

  try {
    const data = await api.activateVendorStore(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Store Activation recorded; discoverability remains independently gated. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## captureVendorPaymentConnection

> VendorOnboardingEnvelope captureVendorPaymentConnection(idempotencyKey, vendorPaymentConnection)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { CaptureVendorPaymentConnectionRequest } from '@materyalph/api-client-ts';

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
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorPaymentConnection
    vendorPaymentConnection: ...,
  } satisfies CaptureVendorPaymentConnectionRequest;

  try {
    const data = await api.captureVendorPaymentConnection(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **vendorPaymentConnection** | [VendorPaymentConnection](VendorPaymentConnection.md) |  | |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Xendit TEST connection captured as unverified/pending. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## completeVendorSetup

> VendorOnboardingEnvelope completeVendorSetup(idempotencyKey, vendorSetupComplete)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { CompleteVendorSetupRequest } from '@materyalph/api-client-ts';

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
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorSetupComplete
    vendorSetupComplete: ...,
  } satisfies CompleteVendorSetupRequest;

  try {
    const data = await api.completeVendorSetup(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **vendorSetupComplete** | [VendorSetupComplete](VendorSetupComplete.md) |  | |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Setup completion recorded. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## confirmVendorStoreEmailVerification

> VendorOnboardingEnvelope confirmVendorStoreEmailVerification(vendorStoreEmailConfirmation)



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
    // VendorStoreEmailConfirmation
    vendorStoreEmailConfirmation: ...,
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
| **vendorStoreEmailConfirmation** | [VendorStoreEmailConfirmation](VendorStoreEmailConfirmation.md) |  | |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Store Email verified. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## dismissVendorOnboardingWelcome

> VendorOnboardingEnvelope dismissVendorOnboardingWelcome()



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { DismissVendorOnboardingWelcomeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  try {
    const data = await api.dismissVendorOnboardingWelcome();
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

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Welcome dismissed. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## downloadVendorOnboardingFile

> Blob downloadVendorOnboardingFile(fileId)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { DownloadVendorOnboardingFileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    fileId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies DownloadVendorOnboardingFileRequest;

  try {
    const data = await api.downloadVendorOnboardingFile(body);
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
| **fileId** | `string` |  | [Defaults to `undefined`] |

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
| **200** | Authorized private file stream. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **404** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorOnboarding

> VendorOnboardingEnvelope getVendorOnboarding()



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorOnboardingRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  try {
    const data = await api.getVendorOnboarding();
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

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Vendor onboarding snapshot with separate Store Verification and Store Setup workstreams. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorPrivateFileUrl

> VendorFileEnvelope getVendorPrivateFileUrl(fileId)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { GetVendorPrivateFileUrlRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  const body = {
    // string
    fileId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorPrivateFileUrlRequest;

  try {
    const data = await api.getVendorPrivateFileUrl(body);
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
| **fileId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorFileEnvelope**](VendorFileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Five-minute authorized signed download URL. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **404** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## inviteVendorTeamMember

> VendorInvitationEnvelope inviteVendorTeamMember(idempotencyKey, vendorInvitationRequest)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { InviteVendorTeamMemberRequest } from '@materyalph/api-client-ts';

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
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorInvitationRequest
    vendorInvitationRequest: ...,
  } satisfies InviteVendorTeamMemberRequest;

  try {
    const data = await api.inviteVendorTeamMember(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **vendorInvitationRequest** | [VendorInvitationRequest](VendorInvitationRequest.md) |  | |

### Return type

[**VendorInvitationEnvelope**](VendorInvitationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Fixed-role team invitation queued by an authorized Owner or delegated Manager. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## receiveXenditAccountVerificationWebhook

> VendorWebhookEnvelope receiveXenditAccountVerificationWebhook(xCallbackToken, xenditAccountVerificationWebhook)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReceiveXenditAccountVerificationWebhookRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new VendorOnboardingApi();

  const body = {
    // string
    xCallbackToken: xCallbackToken_example,
    // XenditAccountVerificationWebhook
    xenditAccountVerificationWebhook: ...,
  } satisfies ReceiveXenditAccountVerificationWebhookRequest;

  try {
    const data = await api.receiveXenditAccountVerificationWebhook(body);
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
| **xCallbackToken** | `string` |  | [Defaults to `undefined`] |
| **xenditAccountVerificationWebhook** | [XenditAccountVerificationWebhook](XenditAccountVerificationWebhook.md) |  | |

### Return type

[**VendorWebhookEnvelope**](VendorWebhookEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Verified and replay-safe provider event accepted. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **503** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reconcileVendorPaymentConnection

> VendorPaymentReconciliationEnvelope reconcileVendorPaymentConnection()



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReconcileVendorPaymentConnectionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorOnboardingApi(config);

  try {
    const data = await api.reconcileVendorPaymentConnection();
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

[**VendorPaymentReconciliationEnvelope**](VendorPaymentReconciliationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Provider reconciliation result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **503** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## requestVendorStoreEmailVerification

> VendorStoreEmailEnvelope requestVendorStoreEmailVerification(emailRequest)



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
    // EmailRequest
    emailRequest: ...,
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
| **emailRequest** | [EmailRequest](EmailRequest.md) |  | |

### Return type

[**VendorStoreEmailEnvelope**](VendorStoreEmailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Short-lived Store Email OTP queued. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reverseGeocodeVendorAddress

> VendorAddressGeocodeEnvelope reverseGeocodeVendorAddress(vendorAddressGeocode)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { ReverseGeocodeVendorAddressRequest } from '@materyalph/api-client-ts';

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
    // VendorAddressGeocode
    vendorAddressGeocode: ...,
  } satisfies ReverseGeocodeVendorAddressRequest;

  try {
    const data = await api.reverseGeocodeVendorAddress(body);
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
| **vendorAddressGeocode** | [VendorAddressGeocode](VendorAddressGeocode.md) |  | |

### Return type

[**VendorAddressGeocodeEnvelope**](VendorAddressGeocodeEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Provider result or a manual-entry fallback. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveVendorSetupDraft

> VendorOnboardingEnvelope saveVendorSetupDraft(vendorSetupDraft)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { SaveVendorSetupDraftRequest } from '@materyalph/api-client-ts';

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
    // VendorSetupDraft
    vendorSetupDraft: ...,
  } satisfies SaveVendorSetupDraftRequest;

  try {
    const data = await api.saveVendorSetupDraft(body);
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
| **vendorSetupDraft** | [VendorSetupDraft](VendorSetupDraft.md) |  | |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Setup draft saved. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveVendorVerificationDraft

> VendorOnboardingEnvelope saveVendorVerificationDraft(vendorVerificationDraft)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { SaveVendorVerificationDraftRequest } from '@materyalph/api-client-ts';

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
    // VendorVerificationDraft
    vendorVerificationDraft: ...,
  } satisfies SaveVendorVerificationDraftRequest;

  try {
    const data = await api.saveVendorVerificationDraft(body);
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
| **vendorVerificationDraft** | [VendorVerificationDraft](VendorVerificationDraft.md) |  | |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Draft saved. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## submitVendorVerification

> VendorOnboardingEnvelope submitVendorVerification(idempotencyKey, vendorVerificationSubmit)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { SubmitVendorVerificationRequest } from '@materyalph/api-client-ts';

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
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorVerificationSubmit
    vendorVerificationSubmit: ...,
  } satisfies SubmitVendorVerificationRequest;

  try {
    const data = await api.submitVendorVerification(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **vendorVerificationSubmit** | [VendorVerificationSubmit](VendorVerificationSubmit.md) |  | |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Submission queued for manual Admin review. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## uploadVendorStoreMedia

> VendorMediaEnvelope uploadVendorStoreMedia(kind, file, altText)



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
    kind: kind_example,
    // Blob
    file: BINARY_DATA_HERE,
    // string (optional)
    altText: altText_example,
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
| **kind** | `LOGO`, `BANNER`, `PROMOTIONAL_IMAGE`, `PROMOTIONAL_VIDEO` |  | [Defaults to `undefined`] [Enum: LOGO, BANNER, PROMOTIONAL_IMAGE, PROMOTIONAL_VIDEO] |
| **file** | `Blob` |  | [Defaults to `undefined`] |
| **altText** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**VendorMediaEnvelope**](VendorMediaEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Store media uploaded to private storage. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## uploadVendorVerificationDocument

> VendorDocumentEnvelope uploadVendorVerificationDocument(requirementKey, file, metadata)



### Example

```ts
import {
  Configuration,
  VendorOnboardingApi,
} from '@materyalph/api-client-ts';
import type { UploadVendorVerificationDocumentRequest } from '@materyalph/api-client-ts';

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
    requirementKey: requirementKey_example,
    // Blob
    file: BINARY_DATA_HERE,
    // { [key: string]: string; } (optional)
    metadata: Object,
  } satisfies UploadVendorVerificationDocumentRequest;

  try {
    const data = await api.uploadVendorVerificationDocument(body);
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
| **requirementKey** | `business_registration`, `lgu_permit`, `bir_cor`, `identity_evidence`, `tax_relief_evidence` |  | [Defaults to `undefined`] [Enum: business_registration, lgu_permit, bir_cor, identity_evidence, tax_relief_evidence] |
| **file** | `Blob` |  | [Defaults to `undefined`] |
| **metadata** | `{ [key: string]: string; }` |  | [Optional] |

### Return type

[**VendorDocumentEnvelope**](VendorDocumentEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Private immutable evidence version created. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

