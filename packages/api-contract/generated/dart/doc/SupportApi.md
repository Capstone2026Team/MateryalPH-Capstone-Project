# materyalph_api_client.api.SupportApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createSupportTicket**](SupportApi.md#createsupportticket) | **POST** /support/{supportPortal}/tickets |
[**downloadSupportAttachment**](SupportApi.md#downloadsupportattachment) | **GET** /support/{supportPortal}/tickets/{ticketId}/attachments/{fileId} |
[**exchangeSupportAccess**](SupportApi.md#exchangesupportaccess) | **POST** /support/guest/access |
[**getSupportTicket**](SupportApi.md#getsupportticket) | **GET** /support/{supportPortal}/tickets/{ticketId} |
[**listSupportEntries**](SupportApi.md#listsupportentries) | **GET** /support/{supportPortal}/tickets/{ticketId}/entries |
[**listSupportHandlers**](SupportApi.md#listsupporthandlers) | **GET** /support/admin/handlers |
[**listSupportTickets**](SupportApi.md#listsupporttickets) | **GET** /support/{supportPortal}/tickets |
[**replyToSupportTicket**](SupportApi.md#replytosupportticket) | **POST** /support/{supportPortal}/tickets/{ticketId}/entries |
[**requestSupportAccessEmail**](SupportApi.md#requestsupportaccessemail) | **POST** /support/guest/access-email |
[**updateSupportTicket**](SupportApi.md#updatesupportticket) | **PATCH** /support/{supportPortal}/tickets/{ticketId} |


# **createSupportTicket**
> SupportReceiptResponse createSupportTicket(supportPortal, idempotencyKey, userType, category, subject, message, privacyAcknowledged, fullName, email, referenceType, reference, website, files)



Buyers use mobile bearer authentication; Vendors use existing browser cookies and CSRF. Guests use CSRF without account authentication. Admin creation is unavailable. Guest name/email are required; authenticated identity and user type always come from the server. A receipt contains no conversation or access secret. IP/email throttles and a blank website honeypot protect intake. Same key and body replay the receipt; changed bodies conflict.

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

final api = MateryalphApiClient().getSupportApi();
final SupportPortal supportPortal = ; // SupportPortal |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final SupportUserType userType = ; // SupportUserType |
final SupportCategory category = ; // SupportCategory |
final String subject = subject_example; // String |
final String message = message_example; // String |
final bool privacyAcknowledged = true; // bool |
final String fullName = fullName_example; // String |
final String email = email_example; // String |
final SupportReferenceType referenceType = ; // SupportReferenceType |
final String reference = reference_example; // String | User-supplied investigation reference; does not grant access to the referenced record.
final String website = website_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Optional private JPG, PNG or PDF files, at most 3 MB each and 3 per message. Server validates content and fails closed on scanning errors.

try {
    final response = api.createSupportTicket(supportPortal, idempotencyKey, userType, category, subject, message, privacyAcknowledged, fullName, email, referenceType, reference, website, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->createSupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportPortal** | [**SupportPortal**](.md)|  |
 **idempotencyKey** | **String**|  |
 **userType** | [**SupportUserType**](SupportUserType.md)|  |
 **category** | [**SupportCategory**](SupportCategory.md)|  |
 **subject** | **String**|  |
 **message** | **String**|  |
 **privacyAcknowledged** | **bool**|  |
 **fullName** | **String**|  | [optional]
 **email** | **String**|  | [optional]
 **referenceType** | [**SupportReferenceType**](SupportReferenceType.md)|  | [optional]
 **reference** | **String**| User-supplied investigation reference; does not grant access to the referenced record. | [optional]
 **website** | **String**|  | [optional]
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Optional private JPG, PNG or PDF files, at most 3 MB each and 3 per message. Server validates content and fails closed on scanning errors. | [optional]

### Return type

[**SupportReceiptResponse**](SupportReceiptResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadSupportAttachment**
> Uint8List downloadSupportAttachment(supportPortal, ticketId, fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: supportGuestCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportPortal supportPortal = ; // SupportPortal |
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.downloadSupportAttachment(supportPortal, ticketId, fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->downloadSupportAttachment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportPortal** | [**SupportPortal**](.md)|  |
 **ticketId** | **String**|  |
 **fileId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[supportGuestCookie](../README.md#supportGuestCookie), [accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exchangeSupportAccess**
> SupportAccessResponse exchangeSupportAccess(supportAccessExchange)



Atomically consumes a hashed 24-hour email link, sets a Secure HttpOnly SameSite=Strict ticket-scoped 30-minute cookie, and returns only the ticket ID. The email frontend keeps the link token in the URL fragment and removes it before making requests.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportAccessExchange supportAccessExchange = ; // SupportAccessExchange |

try {
    final response = api.exchangeSupportAccess(supportAccessExchange);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->exchangeSupportAccess: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportAccessExchange** | [**SupportAccessExchange**](SupportAccessExchange.md)|  |

### Return type

[**SupportAccessResponse**](SupportAccessResponse.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSupportTicket**
> SupportTicketResponse getSupportTicket(supportPortal, ticketId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: supportGuestCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportPortal supportPortal = ; // SupportPortal |
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getSupportTicket(supportPortal, ticketId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->getSupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportPortal** | [**SupportPortal**](.md)|  |
 **ticketId** | **String**|  |

### Return type

[**SupportTicketResponse**](SupportTicketResponse.md)

### Authorization

[supportGuestCookie](../README.md#supportGuestCookie), [accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSupportEntries**
> SupportEntryListResponse listSupportEntries(supportPortal, ticketId, cursor)



Chronological, paginated immutable messages, status and assignment history. The newest 50 entries are returned chronologically; next_cursor retrieves earlier entries.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: supportGuestCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportPortal supportPortal = ; // SupportPortal |
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listSupportEntries(supportPortal, ticketId, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->listSupportEntries: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportPortal** | [**SupportPortal**](.md)|  |
 **ticketId** | **String**|  |
 **cursor** | **String**|  | [optional]

### Return type

[**SupportEntryListResponse**](SupportEntryListResponse.md)

### Authorization

[supportGuestCookie](../README.md#supportGuestCookie), [accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSupportHandlers**
> SupportHandlerListResponse listSupportHandlers(cursor)



Active eligible support administrators; support.view required.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: supportGuestCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listSupportHandlers(cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->listSupportHandlers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional]

### Return type

[**SupportHandlerListResponse**](SupportHandlerListResponse.md)

### Authorization

[supportGuestCookie](../README.md#supportGuestCookie), [accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSupportTickets**
> SupportTicketListResponse listSupportTickets(supportPortal, cursor, q, category, status, userType, from, to)



Paginated newest-first own tickets for buyers/vendors, or all tickets for administrators with support.view. No guest list. Dates use inclusive Asia/Manila calendar days.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: supportGuestCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportPortal supportPortal = ; // SupportPortal |
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String q = q_example; // String |
final SupportCategory category = ; // SupportCategory |
final SupportStatus status = ; // SupportStatus |
final SupportUserType userType = ; // SupportUserType |
final Date from = 2013-10-20; // Date |
final Date to = 2013-10-20; // Date |

try {
    final response = api.listSupportTickets(supportPortal, cursor, q, category, status, userType, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->listSupportTickets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportPortal** | [**SupportPortal**](.md)|  |
 **cursor** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **category** | [**SupportCategory**](.md)|  | [optional]
 **status** | [**SupportStatus**](.md)|  | [optional]
 **userType** | [**SupportUserType**](.md)|  | [optional]
 **from** | **Date**|  | [optional]
 **to** | **Date**|  | [optional]

### Return type

[**SupportTicketListResponse**](SupportTicketListResponse.md)

### Authorization

[supportGuestCookie](../README.md#supportGuestCookie), [accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **replyToSupportTicket**
> SupportReplyResponse replyToSupportTicket(supportPortal, ticketId, idempotencyKey, message, files)



Append a reply and optional attachments. Admins require support.manage. Closed tickets require Admin reopening. A user follow-up reopens Waiting for User or Resolved requests. No real-time chat transport.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: supportGuestCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportPortal supportPortal = ; // SupportPortal |
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String message = message_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Optional private JPG, PNG or PDF files, at most 3 MB each and 3 per message. Server validates content and fails closed on scanning errors.

try {
    final response = api.replyToSupportTicket(supportPortal, ticketId, idempotencyKey, message, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->replyToSupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportPortal** | [**SupportPortal**](.md)|  |
 **ticketId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **message** | **String**|  |
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Optional private JPG, PNG or PDF files, at most 3 MB each and 3 per message. Server validates content and fails closed on scanning errors. | [optional]

### Return type

[**SupportReplyResponse**](SupportReplyResponse.md)

### Authorization

[supportGuestCookie](../README.md#supportGuestCookie), [accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestSupportAccessEmail**
> SupportEmailResponse requestSupportAccessEmail(supportAccessEmail)



Always returns the same response. If guest email and ticket number match, queues a secure single-use link. Rate-limited by IP and hashed identity. Never discloses whether a ticket exists.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportAccessEmail supportAccessEmail = ; // SupportAccessEmail |

try {
    final response = api.requestSupportAccessEmail(supportAccessEmail);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->requestSupportAccessEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportAccessEmail** | [**SupportAccessEmail**](SupportAccessEmail.md)|  |

### Return type

[**SupportEmailResponse**](SupportEmailResponse.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSupportTicket**
> SupportCommandResponse updateSupportTicket(supportPortal, ticketId, idempotencyKey, supportUpdate)



Admin only; support.view and support.manage required. Version-checked status/assignment changes record attributable append-only history and a reason. All five statuses can be selected, including reopening a closed request. Assignees must still hold support authority.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: supportGuestCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supportGuestCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getSupportApi();
final SupportPortal supportPortal = ; // SupportPortal |
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final SupportUpdate supportUpdate = ; // SupportUpdate |

try {
    final response = api.updateSupportTicket(supportPortal, ticketId, idempotencyKey, supportUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->updateSupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportPortal** | [**SupportPortal**](.md)|  |
 **ticketId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **supportUpdate** | [**SupportUpdate**](SupportUpdate.md)|  |

### Return type

[**SupportCommandResponse**](SupportCommandResponse.md)

### Authorization

[supportGuestCookie](../README.md#supportGuestCookie), [accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

