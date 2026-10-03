# materyalph_api_client.api.MessagingApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**archiveChatConversation**](MessagingApi.md#archivechatconversation) | **PUT** /{messagingPortal}/conversations/{conversationId}/archive |
[**authorizeChatChannel**](MessagingApi.md#authorizechatchannel) | **POST** /{messagingPortal}/messaging/auth |
[**createConversation**](MessagingApi.md#createconversation) | **POST** /{messagingPortal}/conversations |
[**decideChatQuotation**](MessagingApi.md#decidechatquotation) | **POST** /{messagingPortal}/conversations/{conversationId}/quotation/{action} |
[**downloadChatAttachment**](MessagingApi.md#downloadchatattachment) | **GET** /{messagingPortal}/conversations/{conversationId}/attachments/{attachmentId} |
[**getChatAvatar**](MessagingApi.md#getchatavatar) | **GET** /{messagingPortal}/conversations/{conversationId}/avatars/{userId} |
[**getChatRealtime**](MessagingApi.md#getchatrealtime) | **GET** /{messagingPortal}/messaging/realtime |
[**getConversation**](MessagingApi.md#getconversation) | **GET** /{messagingPortal}/conversations/{conversationId} |
[**listChatHandlers**](MessagingApi.md#listchathandlers) | **GET** /{messagingPortal}/conversations/{conversationId}/handlers |
[**listChatProducts**](MessagingApi.md#listchatproducts) | **GET** /{messagingPortal}/conversations/{conversationId}/products |
[**listConversations**](MessagingApi.md#listconversations) | **GET** /{messagingPortal}/conversations |
[**publishChatQuotation**](MessagingApi.md#publishchatquotation) | **POST** /{messagingPortal}/conversations/{conversationId}/quotation/publish |
[**readChatMessages**](MessagingApi.md#readchatmessages) | **POST** /{messagingPortal}/conversations/{conversationId}/read |
[**restoreChatConversation**](MessagingApi.md#restorechatconversation) | **DELETE** /{messagingPortal}/conversations/{conversationId}/archive |
[**saveChatQuotationDraft**](MessagingApi.md#savechatquotationdraft) | **PUT** /{messagingPortal}/conversations/{conversationId}/quotation/draft |
[**sendChatMessage**](MessagingApi.md#sendchatmessage) | **POST** /{messagingPortal}/conversations/{conversationId}/messages |
[**sendChatTyping**](MessagingApi.md#sendchattyping) | **POST** /{messagingPortal}/conversations/{conversationId}/typing |
[**startNextChatQuotation**](MessagingApi.md#startnextchatquotation) | **POST** /{messagingPortal}/conversations/{conversationId}/quotation/start |
[**transferChatHandler**](MessagingApi.md#transferchathandler) | **POST** /{messagingPortal}/conversations/{conversationId}/transfer |
[**updateChatDestination**](MessagingApi.md#updatechatdestination) | **PUT** /{messagingPortal}/conversations/{conversationId}/destination |
[**uploadChatAttachment**](MessagingApi.md#uploadchatattachment) | **POST** /{messagingPortal}/conversations/{conversationId}/attachments |


# **archiveChatConversation**
> ChatEmptyResponse archiveChatConversation(messagingPortal, conversationId)



Hides one sales or quotation conversation from the Buyer's own inbox. It is idempotent, personal and reversible; messages, quotations and orders are never changed or deleted. Fulfillment threads stay with their order (409 CONVERSATION_NOT_ARCHIVABLE). New activity returns the conversation to the inbox.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.archiveChatConversation(messagingPortal, conversationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->archiveChatConversation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authorizeChatChannel**
> ChatChannelSignature authorizeChatChannel(messagingPortal, chatChannelAuth)



Pusher protocol signature for an authorized per-viewer Reverb channel. Purpose, membership and assignment epoch must match. Broadcasts carry only invalidations; message/file data always requires a fresh authorized REST request. No client events are accepted.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final ChatChannelAuth chatChannelAuth = ; // ChatChannelAuth |

try {
    final response = api.authorizeChatChannel(messagingPortal, chatChannelAuth);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->authorizeChatChannel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **chatChannelAuth** | [**ChatChannelAuth**](ChatChannelAuth.md)|  |

### Return type

[**ChatChannelSignature**](ChatChannelSignature.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createConversation**
> ChatIdResponse createConversation(messagingPortal, idempotencyKey, chatCreate)



Buyer-only Item-Based inquiry. Project inquiry entry remains gated until Phase 10; both contexts use the same quotation engine. Fulfillment thread creation has no public endpoint and Phase 12 entry remains disabled.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatCreate chatCreate = ; // ChatCreate |

try {
    final response = api.createConversation(messagingPortal, idempotencyKey, chatCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->createConversation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **idempotencyKey** | **String**|  |
 **chatCreate** | [**ChatCreate**](ChatCreate.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decideChatQuotation**
> ChatDecisionResultResponse decideChatQuotation(messagingPortal, conversationId, action, idempotencyKey, chatDecision)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String action = action_example; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatDecision chatDecision = ; // ChatDecision |

try {
    final response = api.decideChatQuotation(messagingPortal, conversationId, action, idempotencyKey, chatDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->decideChatQuotation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **action** | **String**|  |
 **idempotencyKey** | **String**|  |
 **chatDecision** | [**ChatDecision**](ChatDecision.md)|  |

### Return type

[**ChatDecisionResultResponse**](ChatDecisionResultResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadChatAttachment**
> Uint8List downloadChatAttachment(messagingPortal, conversationId, attachmentId)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String attachmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.downloadChatAttachment(messagingPortal, conversationId, attachmentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->downloadChatAttachment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **attachmentId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChatAvatar**
> Uint8List getChatAvatar(messagingPortal, conversationId, userId)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int userId = 56; // int |

try {
    final response = api.getChatAvatar(messagingPortal, conversationId, userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->getChatAvatar: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **userId** | **int**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChatRealtime**
> ChatRealtimeResponse getChatRealtime(messagingPortal)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |

try {
    final response = api.getChatRealtime(messagingPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->getChatRealtime: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |

### Return type

[**ChatRealtimeResponse**](ChatRealtimeResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getConversation**
> ConversationDetailResponse getConversation(messagingPortal, conversationId, page, before, legacyPage)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final String before = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int legacyPage = 56; // int | Page of preserved legacy inquiry references, 25 per page.

try {
    final response = api.getConversation(messagingPortal, conversationId, page, before, legacyPage);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->getConversation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **page** | **int**|  | [optional]
 **before** | **String**|  | [optional]
 **legacyPage** | **int**| Page of preserved legacy inquiry references, 25 per page. | [optional]

### Return type

[**ConversationDetailResponse**](ConversationDetailResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listChatHandlers**
> ChatHandlersResponse listChatHandlers(messagingPortal, conversationId, page)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.listChatHandlers(messagingPortal, conversationId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->listChatHandlers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**ChatHandlersResponse**](ChatHandlersResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listChatProducts**
> ChatProductPageResponse listChatProducts(messagingPortal, conversationId, q, productId, page)



Search active eligible products of this conversation store. product_id filters one listing variant for a local unsent draft.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String q = q_example; // String |
final String productId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.listChatProducts(messagingPortal, conversationId, q, productId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->listChatProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **q** | **String**|  | [optional]
 **productId** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**ChatProductPageResponse**](ChatProductPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listConversations**
> ConversationPageResponse listConversations(messagingPortal, page, archived)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final int page = 56; // int |
final bool archived = true; // bool | Buyer only. true lists the Buyer's archived sales conversations; omitted or false lists the active inbox. Order fulfillment threads are never listed for a Buyer; they open from Order Details.

try {
    final response = api.listConversations(messagingPortal, page, archived);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->listConversations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **page** | **int**|  | [optional]
 **archived** | **bool**| Buyer only. true lists the Buyer's archived sales conversations; omitted or false lists the active inbox. Order fulfillment threads are never listed for a Buyer; they open from Order Details. | [optional]

### Return type

[**ConversationPageResponse**](ConversationPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publishChatQuotation**
> ChatQuotationPageResponse publishChatQuotation(messagingPortal, conversationId, idempotencyKey, chatPublish)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatPublish chatPublish = ; // ChatPublish |

try {
    final response = api.publishChatQuotation(messagingPortal, conversationId, idempotencyKey, chatPublish);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->publishChatQuotation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **chatPublish** | [**ChatPublish**](ChatPublish.md)|  |

### Return type

[**ChatQuotationPageResponse**](ChatQuotationPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readChatMessages**
> ChatEmptyResponse readChatMessages(messagingPortal, conversationId, chatRead)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatRead chatRead = ; // ChatRead |

try {
    final response = api.readChatMessages(messagingPortal, conversationId, chatRead);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->readChatMessages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **chatRead** | [**ChatRead**](ChatRead.md)|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **restoreChatConversation**
> ChatEmptyResponse restoreChatConversation(messagingPortal, conversationId)



Returns an archived conversation to the Buyer's inbox. Idempotent.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.restoreChatConversation(messagingPortal, conversationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->restoreChatConversation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveChatQuotationDraft**
> ChatQuotationPageResponse saveChatQuotationDraft(messagingPortal, conversationId, chatDraftSave)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatDraftSave chatDraftSave = ; // ChatDraftSave |

try {
    final response = api.saveChatQuotationDraft(messagingPortal, conversationId, chatDraftSave);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->saveChatQuotationDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **chatDraftSave** | [**ChatDraftSave**](ChatDraftSave.md)|  |

### Return type

[**ChatQuotationPageResponse**](ChatQuotationPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendChatMessage**
> ChatIdResponse sendChatMessage(messagingPortal, conversationId, chatSend)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatSend chatSend = ; // ChatSend |

try {
    final response = api.sendChatMessage(messagingPortal, conversationId, chatSend);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->sendChatMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **chatSend** | [**ChatSend**](ChatSend.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendChatTyping**
> ChatEmptyResponse sendChatTyping(messagingPortal, conversationId, chatTyping)



Ephemeral authorized conversation.typing event on existing viewer channels, with typing boolean and server millisecond timestamp at. Never persisted; receivers ignore older events and clear after three seconds. Existing account rate limits apply.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatTyping chatTyping = ; // ChatTyping |

try {
    final response = api.sendChatTyping(messagingPortal, conversationId, chatTyping);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->sendChatTyping: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **chatTyping** | [**ChatTyping**](ChatTyping.md)|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startNextChatQuotation**
> ChatQuotationPageResponse startNextChatQuotation(messagingPortal, conversationId, idempotencyKey, chatPublish)



Start a separate quotation after acceptance in the canonical general store chat. Prior accepted quotations and orders stay immutable. Work Package and fulfillment threads cannot start a later quotation. Requires the latest quotation lock_version and Idempotency-Key.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatPublish chatPublish = ; // ChatPublish |

try {
    final response = api.startNextChatQuotation(messagingPortal, conversationId, idempotencyKey, chatPublish);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->startNextChatQuotation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **chatPublish** | [**ChatPublish**](ChatPublish.md)|  |

### Return type

[**ChatQuotationPageResponse**](ChatQuotationPageResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transferChatHandler**
> ChatEmptyResponse transferChatHandler(messagingPortal, conversationId, chatTransfer)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatTransfer chatTransfer = ; // ChatTransfer |

try {
    final response = api.transferChatHandler(messagingPortal, conversationId, chatTransfer);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->transferChatHandler: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **chatTransfer** | [**ChatTransfer**](ChatTransfer.md)|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateChatDestination**
> ChatEmptyResponse updateChatDestination(messagingPortal, conversationId, chatDestinationUpdate)



Buyer-owned saved destination and heavy access for a general store chat. Requires the current conversation lock_version; rejects changes while a quotation is published/viewed. Accepted snapshots stay immutable. An active draft must be reviewed against its incremented quotation lock_version.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChatDestinationUpdate chatDestinationUpdate = ; // ChatDestinationUpdate |

try {
    final response = api.updateChatDestination(messagingPortal, conversationId, chatDestinationUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->updateChatDestination: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **chatDestinationUpdate** | [**ChatDestinationUpdate**](ChatDestinationUpdate.md)|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadChatAttachment**
> ChatEmptyResponse uploadChatAttachment(messagingPortal, conversationId, file, clientMessageId)



Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.

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

final api = MateryalphApiClient().getMessagingApi();
final String messagingPortal = messagingPortal_example; // String |
final String conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |
final String clientMessageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.uploadChatAttachment(messagingPortal, conversationId, file, clientMessageId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MessagingApi->uploadChatAttachment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messagingPortal** | **String**|  |
 **conversationId** | **String**|  |
 **file** | **MultipartFile**|  |
 **clientMessageId** | **String**|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

