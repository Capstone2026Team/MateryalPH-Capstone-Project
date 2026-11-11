# TutorialsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**acknowledgeTutorial**](TutorialsApi.md#acknowledgetutorial) | **PUT** /{tutorialPortal}/account/tutorials/{tutorialKey} | Save completion or dismissal for the signed-in user |
| [**getTutorialProgress**](TutorialsApi.md#gettutorialprogress) | **GET** /{tutorialPortal}/account/tutorials | Read the signed-in user\&#39;s tutorial acknowledgments |



## acknowledgeTutorial

> TutorialProgressEnvelope acknowledgeTutorial(tutorialPortal, tutorialKey, tutorialAcknowledgment)

Save completion or dismissal for the signed-in user

Idempotent acknowledgment. COMPLETED cannot be downgraded by a replay. Keys are role-scoped; Buyer supports overview/discovery/procurement/projects/messages/orders and Vendor supports overview/store/products/inventory/messages/orders/dashboard/fulfillment/invoices/disputes/reviews/vehicles/finance/commissions/transactions/remittance/performance/analytics/team/tracking/settings/notifications/support. Page acknowledgments are per person and do not grant access to the corresponding workspace. Vendor requests require the existing CSRF header. Replay never resets persisted progress. No other user ID is accepted.

### Example

```ts
import {
  Configuration,
  TutorialsApi,
} from '@materyalph/api-client-ts';
import type { AcknowledgeTutorialRequest } from '@materyalph/api-client-ts';

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
  const api = new TutorialsApi(config);

  const body = {
    // 'buyers' | 'vendors'
    tutorialPortal: tutorialPortal_example,
    // 'overview' | 'discovery' | 'procurement' | 'projects' | 'messages' | 'orders' | 'store' | 'products' | 'inventory' | 'dashboard' | 'fulfillment' | 'invoices' | 'disputes' | 'reviews' | 'vehicles' | 'finance' | 'commissions' | 'transactions' | 'remittance' | 'performance' | 'analytics' | 'team' | 'tracking' | 'settings' | 'notifications' | 'support'
    tutorialKey: tutorialKey_example,
    // TutorialAcknowledgment
    tutorialAcknowledgment: ...,
  } satisfies AcknowledgeTutorialRequest;

  try {
    const data = await api.acknowledgeTutorial(body);
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
| **tutorialPortal** | `buyers`, `vendors` |  | [Defaults to `undefined`] [Enum: buyers, vendors] |
| **tutorialKey** | `overview`, `discovery`, `procurement`, `projects`, `messages`, `orders`, `store`, `products`, `inventory`, `dashboard`, `fulfillment`, `invoices`, `disputes`, `reviews`, `vehicles`, `finance`, `commissions`, `transactions`, `remittance`, `performance`, `analytics`, `team`, `tracking`, `settings`, `notifications`, `support` |  | [Defaults to `undefined`] [Enum: overview, discovery, procurement, projects, messages, orders, store, products, inventory, dashboard, fulfillment, invoices, disputes, reviews, vehicles, finance, commissions, transactions, remittance, performance, analytics, team, tracking, settings, notifications, support] |
| **tutorialAcknowledgment** | [TutorialAcknowledgment](TutorialAcknowledgment.md) |  | |

### Return type

[**TutorialProgressEnvelope**](TutorialProgressEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Saved account-scoped progress |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **419** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getTutorialProgress

> TutorialProgressEnvelope getTutorialProgress(tutorialPortal)

Read the signed-in user\&#39;s tutorial acknowledgments

Bounded to six Buyer keys or 23 Vendor overview/page keys for this account type. An absent key is unseen. Buyer uses native bearer transport; Vendor uses cookie transport. Does not alter account or store onboarding.

### Example

```ts
import {
  Configuration,
  TutorialsApi,
} from '@materyalph/api-client-ts';
import type { GetTutorialProgressRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new TutorialsApi(config);

  const body = {
    // 'buyers' | 'vendors'
    tutorialPortal: tutorialPortal_example,
  } satisfies GetTutorialProgressRequest;

  try {
    const data = await api.getTutorialProgress(body);
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
| **tutorialPortal** | `buyers`, `vendors` |  | [Defaults to `undefined`] [Enum: buyers, vendors] |

### Return type

[**TutorialProgressEnvelope**](TutorialProgressEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Account-scoped tutorial progress |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

