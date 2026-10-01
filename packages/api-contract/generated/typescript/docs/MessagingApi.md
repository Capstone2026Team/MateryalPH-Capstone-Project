# MessagingApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**authorizeChatChannel**](MessagingApi.md#authorizechatchannel) | **POST** /{messagingPortal}/messaging/auth |  |
| [**createConversation**](MessagingApi.md#createconversation) | **POST** /{messagingPortal}/conversations |  |
| [**decideChatQuotation**](MessagingApi.md#decidechatquotation) | **POST** /{messagingPortal}/conversations/{conversationId}/quotation/{action} |  |
| [**downloadChatAttachment**](MessagingApi.md#downloadchatattachment) | **GET** /{messagingPortal}/conversations/{conversationId}/attachments/{attachmentId} |  |
| [**getChatAvatar**](MessagingApi.md#getchatavatar) | **GET** /{messagingPortal}/conversations/{conversationId}/avatars/{userId} |  |
| [**getChatRealtime**](MessagingApi.md#getchatrealtime) | **GET** /{messagingPortal}/messaging/realtime |  |
| [**getConversation**](MessagingApi.md#getconversation) | **GET** /{messagingPortal}/conversations/{conversationId} |  |
| [**listChatHandlers**](MessagingApi.md#listchathandlers) | **GET** /{messagingPortal}/conversations/{conversationId}/handlers |  |
| [**listConversations**](MessagingApi.md#listconversations) | **GET** /{messagingPortal}/conversations |  |
| [**publishChatQuotation**](MessagingApi.md#publishchatquotation) | **POST** /{messagingPortal}/conversations/{conversationId}/quotation/publish |  |
| [**readChatMessages**](MessagingApi.md#readchatmessages) | **POST** /{messagingPortal}/conversations/{conversationId}/read |  |
| [**saveChatQuotationDraft**](MessagingApi.md#savechatquotationdraft) | **PUT** /{messagingPortal}/conversations/{conversationId}/quotation/draft |  |
| [**sendChatMessage**](MessagingApi.md#sendchatmessage) | **POST** /{messagingPortal}/conversations/{conversationId}/messages |  |
| [**transferChatHandler**](MessagingApi.md#transferchathandler) | **POST** /{messagingPortal}/conversations/{conversationId}/transfer |  |
| [**uploadChatAttachment**](MessagingApi.md#uploadchatattachment) | **POST** /{messagingPortal}/conversations/{conversationId}/attachments |  |



## authorizeChatChannel

> ChatChannelSignature authorizeChatChannel(messagingPortal, chatChannelAuth)



Pusher protocol signature for an authorized per-viewer Reverb channel. Purpose, membership and assignment epoch must match. Broadcasts carry only invalidations; message/file data always requires a fresh authorized REST request. No client events are accepted.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { AuthorizeChatChannelRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // ChatChannelAuth
    chatChannelAuth: ...,
  } satisfies AuthorizeChatChannelRequest;

  try {
    const data = await api.authorizeChatChannel(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **chatChannelAuth** | [ChatChannelAuth](ChatChannelAuth.md) |  | |

### Return type

[**ChatChannelSignature**](ChatChannelSignature.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## createConversation

> ChatIdResponse createConversation(messagingPortal, idempotencyKey, chatCreate)



Buyer-only Item-Based inquiry. Project inquiry entry remains gated until Phase 10; both contexts use the same quotation engine. Fulfillment thread creation has no public endpoint and Phase 12 entry remains disabled.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { CreateConversationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new MessagingApi(config);

  const body = {
    // 'buyers'
    messagingPortal: messagingPortal_example,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChatCreate
    chatCreate: ...,
  } satisfies CreateConversationRequest;

  try {
    const data = await api.createConversation(body);
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
| **messagingPortal** | `buyers` |  | [Defaults to `undefined`] [Enum: buyers] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **chatCreate** | [ChatCreate](ChatCreate.md) |  | |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **201** | Conversation created |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## decideChatQuotation

> ChatDecisionResultResponse decideChatQuotation(messagingPortal, conversationId, action, idempotencyKey, chatDecision)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { DecideChatQuotationRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 'view' | 'accept' | 'reject' | 'counter' | 'withdraw'
    action: action_example,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChatDecision
    chatDecision: ...,
  } satisfies DecideChatQuotationRequest;

  try {
    const data = await api.decideChatQuotation(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **action** | `view`, `accept`, `reject`, `counter`, `withdraw` |  | [Defaults to `undefined`] [Enum: view, accept, reject, counter, withdraw] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **chatDecision** | [ChatDecision](ChatDecision.md) |  | |

### Return type

[**ChatDecisionResultResponse**](ChatDecisionResultResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## downloadChatAttachment

> Blob downloadChatAttachment(messagingPortal, conversationId, attachmentId)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { DownloadChatAttachmentRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    attachmentId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies DownloadChatAttachmentRequest;

  try {
    const data = await api.downloadChatAttachment(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **attachmentId** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Private authorized bytes; no-store. CLEAN files only. Fulfillment cannot retrieve sales or financial attachments. |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getChatAvatar

> Blob getChatAvatar(messagingPortal, conversationId, userId)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { GetChatAvatarRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number
    userId: 56,
  } satisfies GetChatAvatarRequest;

  try {
    const data = await api.getChatAvatar(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **userId** | `number` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Private authorized bytes; no-store. CLEAN files only. Fulfillment cannot retrieve sales or financial attachments. |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getChatRealtime

> ChatRealtimeResponse getChatRealtime(messagingPortal)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { GetChatRealtimeRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
  } satisfies GetChatRealtimeRequest;

  try {
    const data = await api.getChatRealtime(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |

### Return type

[**ChatRealtimeResponse**](ChatRealtimeResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getConversation

> ConversationDetailResponse getConversation(messagingPortal, conversationId, page, before)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { GetConversationRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
    // string (optional)
    before: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetConversationRequest;

  try {
    const data = await api.getConversation(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **before** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ConversationDetailResponse**](ConversationDetailResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listChatHandlers

> ChatHandlersResponse listChatHandlers(messagingPortal, conversationId, page)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { ListChatHandlersRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new MessagingApi(config);

  const body = {
    // 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
  } satisfies ListChatHandlersRequest;

  try {
    const data = await api.listChatHandlers(body);
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
| **messagingPortal** | `vendor` |  | [Defaults to `undefined`] [Enum: vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ChatHandlersResponse**](ChatHandlersResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listConversations

> ConversationPageResponse listConversations(messagingPortal, page)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { ListConversationsRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // number (optional)
    page: 56,
  } satisfies ListConversationsRequest;

  try {
    const data = await api.listConversations(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ConversationPageResponse**](ConversationPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## publishChatQuotation

> ChatQuotationPageResponse publishChatQuotation(messagingPortal, conversationId, idempotencyKey, chatPublish)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { PublishChatQuotationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new MessagingApi(config);

  const body = {
    // 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChatPublish
    chatPublish: ...,
  } satisfies PublishChatQuotationRequest;

  try {
    const data = await api.publishChatQuotation(body);
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
| **messagingPortal** | `vendor` |  | [Defaults to `undefined`] [Enum: vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **chatPublish** | [ChatPublish](ChatPublish.md) |  | |

### Return type

[**ChatQuotationPageResponse**](ChatQuotationPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## readChatMessages

> ChatEmptyResponse readChatMessages(messagingPortal, conversationId, chatRead)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { ReadChatMessagesRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChatRead
    chatRead: ...,
  } satisfies ReadChatMessagesRequest;

  try {
    const data = await api.readChatMessages(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **chatRead** | [ChatRead](ChatRead.md) |  | |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveChatQuotationDraft

> ChatQuotationPageResponse saveChatQuotationDraft(messagingPortal, conversationId, chatDraftSave)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { SaveChatQuotationDraftRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new MessagingApi(config);

  const body = {
    // 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChatDraftSave
    chatDraftSave: ...,
  } satisfies SaveChatQuotationDraftRequest;

  try {
    const data = await api.saveChatQuotationDraft(body);
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
| **messagingPortal** | `vendor` |  | [Defaults to `undefined`] [Enum: vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **chatDraftSave** | [ChatDraftSave](ChatDraftSave.md) |  | |

### Return type

[**ChatQuotationPageResponse**](ChatQuotationPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## sendChatMessage

> ChatIdResponse sendChatMessage(messagingPortal, conversationId, chatSend)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { SendChatMessageRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChatSend
    chatSend: ...,
  } satisfies SendChatMessageRequest;

  try {
    const data = await api.sendChatMessage(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **chatSend** | [ChatSend](ChatSend.md) |  | |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **201** | Message saved idempotently by client_message_id |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## transferChatHandler

> ChatEmptyResponse transferChatHandler(messagingPortal, conversationId, chatTransfer)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { TransferChatHandlerRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new MessagingApi(config);

  const body = {
    // 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ChatTransfer
    chatTransfer: ...,
  } satisfies TransferChatHandlerRequest;

  try {
    const data = await api.transferChatHandler(body);
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
| **messagingPortal** | `vendor` |  | [Defaults to `undefined`] [Enum: vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **chatTransfer** | [ChatTransfer](ChatTransfer.md) |  | |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## uploadChatAttachment

> ChatEmptyResponse uploadChatAttachment(messagingPortal, conversationId, file, clientMessageId)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

### Example

```ts
import {
  Configuration,
  MessagingApi,
} from '@materyalph/api-client-ts';
import type { UploadChatAttachmentRequest } from '@materyalph/api-client-ts';

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
  const api = new MessagingApi(config);

  const body = {
    // 'buyers' | 'vendor'
    messagingPortal: messagingPortal_example,
    // string
    conversationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // Blob
    file: BINARY_DATA_HERE,
    // string
    clientMessageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies UploadChatAttachmentRequest;

  try {
    const data = await api.uploadChatAttachment(body);
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
| **messagingPortal** | `buyers`, `vendor` |  | [Defaults to `undefined`] [Enum: buyers, vendor] |
| **conversationId** | `string` |  | [Defaults to `undefined`] |
| **file** | `Blob` |  | [Defaults to `undefined`] |
| **clientMessageId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result |  -  |
| **201** | Authorized result |  -  |
| **401** | Authentication required |  -  |
| **403** | Current role or channel access denied |  -  |
| **404** | Conversation unavailable or access revoked |  -  |
| **409** | Recoverable version, deadline, idempotency or stock conflict; re-read the current version |  -  |
| **422** | Invalid fields or undisclosed NRPC |  -  |
| **503** | Provider or scanner unavailable; retry safely |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

