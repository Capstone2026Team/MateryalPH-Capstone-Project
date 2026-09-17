# materyalph_api_client.api.VendorOnboardingApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activateVendorStore**](VendorOnboardingApi.md#activatevendorstore) | **POST** /vendors/onboarding/activation |
[**captureVendorPaymentConnection**](VendorOnboardingApi.md#capturevendorpaymentconnection) | **POST** /vendors/onboarding/payment-connection |
[**completeVendorSetup**](VendorOnboardingApi.md#completevendorsetup) | **POST** /vendors/onboarding/setup/complete |
[**confirmVendorStoreEmailVerification**](VendorOnboardingApi.md#confirmvendorstoreemailverification) | **POST** /vendors/onboarding/store-email/confirm |
[**dismissVendorOnboardingWelcome**](VendorOnboardingApi.md#dismissvendoronboardingwelcome) | **POST** /vendors/onboarding/welcome/dismiss |
[**downloadVendorOnboardingFile**](VendorOnboardingApi.md#downloadvendoronboardingfile) | **GET** /vendor-onboarding-files/{fileId}/content |
[**getVendorOnboarding**](VendorOnboardingApi.md#getvendoronboarding) | **GET** /vendors/onboarding |
[**getVendorPrivateFileUrl**](VendorOnboardingApi.md#getvendorprivatefileurl) | **GET** /vendors/onboarding/files/{fileId} |
[**inviteVendorTeamMember**](VendorOnboardingApi.md#invitevendorteammember) | **POST** /vendors/account/invitations |
[**receiveXenditAccountVerificationWebhook**](VendorOnboardingApi.md#receivexenditaccountverificationwebhook) | **POST** /webhooks/xendit/account-verification |
[**reconcileVendorPaymentConnection**](VendorOnboardingApi.md#reconcilevendorpaymentconnection) | **POST** /vendors/onboarding/payment-connection/reconcile |
[**requestVendorStoreEmailVerification**](VendorOnboardingApi.md#requestvendorstoreemailverification) | **POST** /vendors/onboarding/store-email |
[**reverseGeocodeVendorAddress**](VendorOnboardingApi.md#reversegeocodevendoraddress) | **POST** /vendors/onboarding/address/geocode |
[**saveVendorSetupDraft**](VendorOnboardingApi.md#savevendorsetupdraft) | **PATCH** /vendors/onboarding/setup |
[**saveVendorVerificationDraft**](VendorOnboardingApi.md#savevendorverificationdraft) | **PATCH** /vendors/onboarding/verification |
[**submitVendorVerification**](VendorOnboardingApi.md#submitvendorverification) | **POST** /vendors/onboarding/verification/submit |
[**uploadVendorStoreMedia**](VendorOnboardingApi.md#uploadvendorstoremedia) | **POST** /vendors/onboarding/media |
[**uploadVendorVerificationDocument**](VendorOnboardingApi.md#uploadvendorverificationdocument) | **POST** /vendors/onboarding/documents |


# **activateVendorStore**
> VendorOnboardingEnvelope activateVendorStore(idempotencyKey)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.activateVendorStore(idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->activateVendorStore: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **captureVendorPaymentConnection**
> VendorOnboardingEnvelope captureVendorPaymentConnection(idempotencyKey, vendorPaymentConnection)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorPaymentConnection vendorPaymentConnection = ; // VendorPaymentConnection |

try {
    final response = api.captureVendorPaymentConnection(idempotencyKey, vendorPaymentConnection);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->captureVendorPaymentConnection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **vendorPaymentConnection** | [**VendorPaymentConnection**](VendorPaymentConnection.md)|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeVendorSetup**
> VendorOnboardingEnvelope completeVendorSetup(idempotencyKey, vendorSetupComplete)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorSetupComplete vendorSetupComplete = ; // VendorSetupComplete |

try {
    final response = api.completeVendorSetup(idempotencyKey, vendorSetupComplete);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->completeVendorSetup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **vendorSetupComplete** | [**VendorSetupComplete**](VendorSetupComplete.md)|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmVendorStoreEmailVerification**
> VendorOnboardingEnvelope confirmVendorStoreEmailVerification(vendorStoreEmailConfirmation)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final VendorStoreEmailConfirmation vendorStoreEmailConfirmation = ; // VendorStoreEmailConfirmation |

try {
    final response = api.confirmVendorStoreEmailVerification(vendorStoreEmailConfirmation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->confirmVendorStoreEmailVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorStoreEmailConfirmation** | [**VendorStoreEmailConfirmation**](VendorStoreEmailConfirmation.md)|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dismissVendorOnboardingWelcome**
> VendorOnboardingEnvelope dismissVendorOnboardingWelcome()



Persists the Owner welcome completion across refreshes and sessions. Clients continue to Store Verification after success.

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

final api = MateryalphApiClient().getVendorOnboardingApi();

try {
    final response = api.dismissVendorOnboardingWelcome();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->dismissVendorOnboardingWelcome: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadVendorOnboardingFile**
> Uint8List downloadVendorOnboardingFile(fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.downloadVendorOnboardingFile(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->downloadVendorOnboardingFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorOnboarding**
> VendorOnboardingEnvelope getVendorOnboarding()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();

try {
    final response = api.getVendorOnboarding();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorOnboarding: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorPrivateFileUrl**
> VendorFileEnvelope getVendorPrivateFileUrl(fileId)



Returns a five-minute signed URL for clean private verification evidence or ready Store Profile media owned by the current Vendor organization. Download rechecks authentication, permissions, ownership and scan state.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorPrivateFileUrl(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorPrivateFileUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  |

### Return type

[**VendorFileEnvelope**](VendorFileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inviteVendorTeamMember**
> VendorInvitationEnvelope inviteVendorTeamMember(idempotencyKey, vendorInvitationRequest)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorInvitationRequest vendorInvitationRequest = ; // VendorInvitationRequest |

try {
    final response = api.inviteVendorTeamMember(idempotencyKey, vendorInvitationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->inviteVendorTeamMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **vendorInvitationRequest** | [**VendorInvitationRequest**](VendorInvitationRequest.md)|  |

### Return type

[**VendorInvitationEnvelope**](VendorInvitationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **receiveXenditAccountVerificationWebhook**
> VendorWebhookEnvelope receiveXenditAccountVerificationWebhook(xCallbackToken, xenditAccountVerificationWebhook)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String xCallbackToken = xCallbackToken_example; // String |
final XenditAccountVerificationWebhook xenditAccountVerificationWebhook = ; // XenditAccountVerificationWebhook |

try {
    final response = api.receiveXenditAccountVerificationWebhook(xCallbackToken, xenditAccountVerificationWebhook);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->receiveXenditAccountVerificationWebhook: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xCallbackToken** | **String**|  |
 **xenditAccountVerificationWebhook** | [**XenditAccountVerificationWebhook**](XenditAccountVerificationWebhook.md)|  |

### Return type

[**VendorWebhookEnvelope**](VendorWebhookEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reconcileVendorPaymentConnection**
> VendorPaymentReconciliationEnvelope reconcileVendorPaymentConnection()



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

final api = MateryalphApiClient().getVendorOnboardingApi();

try {
    final response = api.reconcileVendorPaymentConnection();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->reconcileVendorPaymentConnection: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VendorPaymentReconciliationEnvelope**](VendorPaymentReconciliationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestVendorStoreEmailVerification**
> VendorStoreEmailEnvelope requestVendorStoreEmailVerification(emailRequest)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final EmailRequest emailRequest = ; // EmailRequest |

try {
    final response = api.requestVendorStoreEmailVerification(emailRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->requestVendorStoreEmailVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailRequest** | [**EmailRequest**](EmailRequest.md)|  |

### Return type

[**VendorStoreEmailEnvelope**](VendorStoreEmailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reverseGeocodeVendorAddress**
> VendorAddressGeocodeEnvelope reverseGeocodeVendorAddress(vendorAddressGeocode)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final VendorAddressGeocode vendorAddressGeocode = ; // VendorAddressGeocode |

try {
    final response = api.reverseGeocodeVendorAddress(vendorAddressGeocode);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->reverseGeocodeVendorAddress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorAddressGeocode** | [**VendorAddressGeocode**](VendorAddressGeocode.md)|  |

### Return type

[**VendorAddressGeocodeEnvelope**](VendorAddressGeocodeEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorSetupDraft**
> VendorOnboardingEnvelope saveVendorSetupDraft(vendorSetupDraft)



Saves version-checked setup progress. Public-name, description and public-contact-only edits preserve completed setup and activation; operational changes reopen setup requirements. Every successful save advances the organization lock version.

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

final api = MateryalphApiClient().getVendorOnboardingApi();
final VendorSetupDraft vendorSetupDraft = ; // VendorSetupDraft |

try {
    final response = api.saveVendorSetupDraft(vendorSetupDraft);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->saveVendorSetupDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorSetupDraft** | [**VendorSetupDraft**](VendorSetupDraft.md)|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorVerificationDraft**
> VendorOnboardingEnvelope saveVendorVerificationDraft(vendorVerificationDraft)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final VendorVerificationDraft vendorVerificationDraft = ; // VendorVerificationDraft |

try {
    final response = api.saveVendorVerificationDraft(vendorVerificationDraft);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->saveVendorVerificationDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorVerificationDraft** | [**VendorVerificationDraft**](VendorVerificationDraft.md)|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitVendorVerification**
> VendorOnboardingEnvelope submitVendorVerification(idempotencyKey, vendorVerificationSubmit)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorVerificationSubmit vendorVerificationSubmit = ; // VendorVerificationSubmit |

try {
    final response = api.submitVendorVerification(idempotencyKey, vendorVerificationSubmit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->submitVendorVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **vendorVerificationSubmit** | [**VendorVerificationSubmit**](VendorVerificationSubmit.md)|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadVendorStoreMedia**
> VendorMediaEnvelope uploadVendorStoreMedia(kind, file, altText)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final String kind = kind_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |
final String altText = altText_example; // String |

try {
    final response = api.uploadVendorStoreMedia(kind, file, altText);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->uploadVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  |
 **file** | **MultipartFile**|  |
 **altText** | **String**|  | [optional]

### Return type

[**VendorMediaEnvelope**](VendorMediaEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadVendorVerificationDocument**
> VendorDocumentEnvelope uploadVendorVerificationDocument(requirementKey, file, metadata)



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

final api = MateryalphApiClient().getVendorOnboardingApi();
final String requirementKey = requirementKey_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |
final BuiltMap<String, String> metadata = Object; // BuiltMap<String, String> |

try {
    final response = api.uploadVendorVerificationDocument(requirementKey, file, metadata);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->uploadVendorVerificationDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requirementKey** | **String**|  |
 **file** | **MultipartFile**|  |
 **metadata** | [**BuiltMap&lt;String, String&gt;**](BuiltMap.md)|  | [optional]

### Return type

[**VendorDocumentEnvelope**](VendorDocumentEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

