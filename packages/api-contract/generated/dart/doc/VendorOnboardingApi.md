# materyalph_api_client.api.VendorOnboardingApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptVendorCommission**](VendorOnboardingApi.md#acceptvendorcommission) | **POST** /vendors/onboarding/verification/commission |
[**activateVendorStore**](VendorOnboardingApi.md#activatevendorstore) | **POST** /vendors/onboarding/activation |
[**changeVendorStaffDisputes**](VendorOnboardingApi.md#changevendorstaffdisputes) | **PATCH** /vendors/account/staff-disputes |
[**completeVendorSetup**](VendorOnboardingApi.md#completevendorsetup) | **POST** /vendors/onboarding/setup/complete |
[**confirmVendorStoreEmailVerification**](VendorOnboardingApi.md#confirmvendorstoreemailverification) | **POST** /vendors/onboarding/store-email/confirm |
[**connectVendorPayment**](VendorOnboardingApi.md#connectvendorpayment) | **POST** /vendors/onboarding/payment-connection |
[**dismissVendorOnboardingWelcome**](VendorOnboardingApi.md#dismissvendoronboardingwelcome) | **POST** /vendors/onboarding/welcome/dismiss |
[**downloadVendorOnboardingFile**](VendorOnboardingApi.md#downloadvendoronboardingfile) | **GET** /vendor-onboarding-files/{fileId}/content |
[**getAuthoritativeVendorOnboarding**](VendorOnboardingApi.md#getauthoritativevendoronboarding) | **GET** /vendor/onboarding |
[**getVendorOnboarding**](VendorOnboardingApi.md#getvendoronboarding) | **GET** /vendors/onboarding |
[**getVendorPrivateFileUrl**](VendorOnboardingApi.md#getvendorprivatefileurl) | **GET** /vendors/onboarding/files/{fileId} |
[**inviteVendorTeamMember**](VendorOnboardingApi.md#invitevendorteammember) | **POST** /vendors/account/invitations |
[**listVendorTeamActivity**](VendorOnboardingApi.md#listvendorteamactivity) | **GET** /vendors/account/activity |
[**listVendorTeamInvitations**](VendorOnboardingApi.md#listvendorteaminvitations) | **GET** /vendors/account/invitations |
[**previewVendorRequirements**](VendorOnboardingApi.md#previewvendorrequirements) | **GET** /vendors/onboarding/requirements |
[**receiveXenditAccountVerificationWebhook**](VendorOnboardingApi.md#receivexenditaccountverificationwebhook) | **POST** /webhooks/xendit/account-verification |
[**reconcileVendorPaymentConnection**](VendorOnboardingApi.md#reconcilevendorpaymentconnection) | **POST** /vendors/onboarding/payment-connection/reconcile |
[**removePendingVendorDocument**](VendorOnboardingApi.md#removependingvendordocument) | **DELETE** /vendors/onboarding/documents/pending/{requirementKey} |
[**removeVendorStoreMedia**](VendorOnboardingApi.md#removevendorstoremedia) | **DELETE** /vendors/onboarding/media/{mediaId} |
[**requestVendorStoreEmailVerification**](VendorOnboardingApi.md#requestvendorstoreemailverification) | **POST** /vendors/onboarding/store-email |
[**resolveVendorAddress**](VendorOnboardingApi.md#resolvevendoraddress) | **POST** /vendors/onboarding/address/resolve |
[**resolveVendorAddressPin**](VendorOnboardingApi.md#resolvevendoraddresspin) | **POST** /vendors/onboarding/address/pin |
[**reverseGeocodeVendorAddress**](VendorOnboardingApi.md#reversegeocodevendoraddress) | **POST** /vendors/onboarding/address/geocode |
[**saveVendorSetupDraft**](VendorOnboardingApi.md#savevendorsetupdraft) | **PATCH** /vendors/onboarding/setup |
[**saveVendorVerificationDraft**](VendorOnboardingApi.md#savevendorverificationdraft) | **PATCH** /vendors/onboarding/verification |
[**searchVendorAddressAreas**](VendorOnboardingApi.md#searchvendoraddressareas) | **GET** /vendors/onboarding/address/areas |
[**submitVendorVerification**](VendorOnboardingApi.md#submitvendorverification) | **POST** /vendors/onboarding/verification/submit |
[**uploadVendorStoreMedia**](VendorOnboardingApi.md#uploadvendorstoremedia) | **POST** /vendors/onboarding/media |
[**uploadVendorVerificationDocument**](VendorOnboardingApi.md#uploadvendorverificationdocument) | **POST** /vendors/onboarding/documents |


# **acceptVendorCommission**
> VendorOnboardingEnvelope acceptVendorCommission(idempotencyKey, vendorCommissionAcceptance)



Explicit version-bound acceptance in Store Verification. Owner only; applicable current representative authority requires the COMMISSION_AGREEMENT scope. Autosaving or submitting evidence never implies consent. Initial evidence submission remains available while authority approval is pending.

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
final VendorCommissionAcceptance vendorCommissionAcceptance = ; // VendorCommissionAcceptance |

try {
    final response = api.acceptVendorCommission(idempotencyKey, vendorCommissionAcceptance);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->acceptVendorCommission: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **vendorCommissionAcceptance** | [**VendorCommissionAcceptance**](VendorCommissionAcceptance.md)|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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

# **changeVendorStaffDisputes**
> AccountMutationResultEnvelope changeVendorStaffDisputes(vendorStaffDisputeSetting)



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
final VendorStaffDisputeSetting vendorStaffDisputeSetting = ; // VendorStaffDisputeSetting |

try {
    final response = api.changeVendorStaffDisputes(vendorStaffDisputeSetting);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->changeVendorStaffDisputes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorStaffDisputeSetting** | [**VendorStaffDisputeSetting**](VendorStaffDisputeSetting.md)|  |

### Return type

[**AccountMutationResultEnvelope**](AccountMutationResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeVendorSetup**
> VendorOnboardingEnvelope completeVendorSetup(idempotencyKey, vendorSetupComplete)



Requires a valid seven-day Store Operation schedule, applicable setup configuration and confirmed TEST payment connection. Missing or invalid hours return STORE_OPERATION_REQUIRED. Completion does not activate the store or approve verification.

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

# **connectVendorPayment**
> VendorPaymentOnboardingEnvelope connectVendorPayment(idempotencyKey)



Owner and current PAYMENT_CONFIGURATION authority only. Creates a platform-controlled TEST OWNED sub-account through backend POST /v2/accounts for simulated payments, without a Vendor invitation or separate Xendit login. A validated create response is PENDING until backend GET /v2/accounts/{id} confirms LIVE, which yields CONNECTED_TEST. Reuses existing associations and rejects uncertain duplicate attempts. No client-supplied account ID or URL is accepted. Responses are private and no-store.

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
    final response = api.connectVendorPayment(idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->connectVendorPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |

### Return type

[**VendorPaymentOnboardingEnvelope**](VendorPaymentOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
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

# **getAuthoritativeVendorOnboarding**
> VendorOnboardingEnvelope getAuthoritativeVendorOnboarding()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();

try {
    final response = api.getAuthoritativeVendorOnboarding();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getAuthoritativeVendorOnboarding: $e\n');
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

# **listVendorTeamActivity**
> VendorTeamActivityEnvelope listVendorTeamActivity(page)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final int page = 56; // int |

try {
    final response = api.listVendorTeamActivity(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listVendorTeamActivity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**VendorTeamActivityEnvelope**](VendorTeamActivityEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorTeamInvitations**
> VendorTeamInvitationListEnvelope listVendorTeamInvitations(page)



Paginated organization-scoped invitation history. Delegated Managers cannot view Manager invitations. Invitation status is derived from acceptance, revocation and expiry.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final int page = 56; // int |

try {
    final response = api.listVendorTeamInvitations(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listVendorTeamInvitations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**VendorTeamInvitationListEnvelope**](VendorTeamInvitationListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewVendorRequirements**
> GenericDataEnvelope previewVendorRequirements(businessType, representativeRole, identityIdType, representativeIdType, authorityEvidenceVersionId, declarationClaim)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String businessType = businessType_example; // String |
final String representativeRole = representativeRole_example; // String |
final String identityIdType = identityIdType_example; // String |
final String representativeIdType = representativeIdType_example; // String |
final String authorityEvidenceVersionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int declarationClaim = 56; // int |

try {
    final response = api.previewVendorRequirements(businessType, representativeRole, identityIdType, representativeIdType, authorityEvidenceVersionId, declarationClaim);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->previewVendorRequirements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **businessType** | **String**|  |
 **representativeRole** | **String**|  | [optional]
 **identityIdType** | **String**|  | [optional]
 **representativeIdType** | **String**|  | [optional]
 **authorityEvidenceVersionId** | **String**|  | [optional]
 **declarationClaim** | **int**|  | [optional]

### Return type

[**GenericDataEnvelope**](GenericDataEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
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

# **removePendingVendorDocument**
> VendorOnboardingEnvelope removePendingVendorDocument(requirementKey)



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

try {
    final response = api.removePendingVendorDocument(requirementKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->removePendingVendorDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requirementKey** | **String**|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeVendorStoreMedia**
> VendorOnboardingEnvelope removeVendorStoreMedia(mediaId)



Removes the current Store Logo or Banner record. A stale media ID cannot remove its replacement; the returned onboarding snapshot recalculates the profile checklist.

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
final String mediaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.removeVendorStoreMedia(mediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->removeVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaId** | **String**|  |

### Return type

[**VendorOnboardingEnvelope**](VendorOnboardingEnvelope.md)

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

# **resolveVendorAddress**
> GenericDataEnvelope resolveVendorAddress(vendorAddressSelection)



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
final VendorAddressSelection vendorAddressSelection = ; // VendorAddressSelection |

try {
    final response = api.resolveVendorAddress(vendorAddressSelection);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->resolveVendorAddress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorAddressSelection** | [**VendorAddressSelection**](VendorAddressSelection.md)|  |

### Return type

[**GenericDataEnvelope**](GenericDataEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveVendorAddressPin**
> GenericDataEnvelope resolveVendorAddressPin(vendorAddressGeocode)



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
    final response = api.resolveVendorAddressPin(vendorAddressGeocode);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->resolveVendorAddressPin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorAddressGeocode** | [**VendorAddressGeocode**](VendorAddressGeocode.md)|  |

### Return type

[**GenericDataEnvelope**](GenericDataEnvelope.md)

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



Saves version-checked setup progress. Public profile and weekly operating schedule edits preserve completed setup and activation; fulfillment changes reopen setup requirements. Every successful save advances the organization lock version.

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

# **searchVendorAddressAreas**
> PsgcSearchEnvelope searchVendorAddressAreas(level, parentCode, q, page)



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
final String level = level_example; // String |
final String parentCode = parentCode_example; // String |
final String q = q_example; // String |
final int page = 56; // int |

try {
    final response = api.searchVendorAddressAreas(level, parentCode, q, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->searchVendorAddressAreas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **level** | **String**|  |
 **parentCode** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **page** | **int**|  | [optional] [default to 1]

### Return type

[**PsgcSearchEnvelope**](PsgcSearchEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
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

