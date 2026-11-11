# materyalph_api_client.api.TutorialsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acknowledgeTutorial**](TutorialsApi.md#acknowledgetutorial) | **PUT** /{tutorialPortal}/account/tutorials/{tutorialKey} | Save completion or dismissal for the signed-in user
[**getTutorialProgress**](TutorialsApi.md#gettutorialprogress) | **GET** /{tutorialPortal}/account/tutorials | Read the signed-in user&#39;s tutorial acknowledgments


# **acknowledgeTutorial**
> TutorialProgressEnvelope acknowledgeTutorial(tutorialPortal, tutorialKey, tutorialAcknowledgment)

Save completion or dismissal for the signed-in user

Idempotent acknowledgment. COMPLETED cannot be downgraded by a replay. Keys are role-scoped; Buyer supports overview/discovery/procurement/projects/messages/orders and Vendor supports overview/store/products/inventory/messages/orders/dashboard/fulfillment/invoices/disputes/reviews/vehicles/finance/commissions/transactions/remittance/performance/analytics/team/tracking/settings/notifications/support. Page acknowledgments are per person and do not grant access to the corresponding workspace. Vendor requests require the existing CSRF header. Replay never resets persisted progress. No other user ID is accepted.

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

final api = MateryalphApiClient().getTutorialsApi();
final String tutorialPortal = tutorialPortal_example; // String |
final String tutorialKey = tutorialKey_example; // String |
final TutorialAcknowledgment tutorialAcknowledgment = ; // TutorialAcknowledgment |

try {
    final response = api.acknowledgeTutorial(tutorialPortal, tutorialKey, tutorialAcknowledgment);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TutorialsApi->acknowledgeTutorial: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tutorialPortal** | **String**|  |
 **tutorialKey** | **String**|  |
 **tutorialAcknowledgment** | [**TutorialAcknowledgment**](TutorialAcknowledgment.md)|  |

### Return type

[**TutorialProgressEnvelope**](TutorialProgressEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTutorialProgress**
> TutorialProgressEnvelope getTutorialProgress(tutorialPortal)

Read the signed-in user's tutorial acknowledgments

Bounded to six Buyer keys or 23 Vendor overview/page keys for this account type. An absent key is unseen. Buyer uses native bearer transport; Vendor uses cookie transport. Does not alter account or store onboarding.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getTutorialsApi();
final String tutorialPortal = tutorialPortal_example; // String |

try {
    final response = api.getTutorialProgress(tutorialPortal);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TutorialsApi->getTutorialProgress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tutorialPortal** | **String**|  |

### Return type

[**TutorialProgressEnvelope**](TutorialProgressEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

