# materyalph_api_client.api.AuthenticationApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptAdminInvitation**](AuthenticationApi.md#acceptadmininvitation) | **POST** /auth/admin-invitations/accept |
[**completeBuyerMobileMfaChallenge**](AuthenticationApi.md#completebuyermobilemfachallenge) | **POST** /mobile/auth/mfa/challenge |
[**completeGoogleOidc**](AuthenticationApi.md#completegoogleoidc) | **GET** /auth/google/callback |
[**completeMfaChallenge**](AuthenticationApi.md#completemfachallenge) | **POST** /auth/mfa/challenge |
[**confirmMfaEnrollment**](AuthenticationApi.md#confirmmfaenrollment) | **POST** /auth/mfa/enrollment/confirm |
[**exchangeBuyerMobileGoogleCode**](AuthenticationApi.md#exchangebuyermobilegooglecode) | **POST** /mobile/auth/google/exchange |
[**getBuyerMobileSession**](AuthenticationApi.md#getbuyermobilesession) | **GET** /mobile/auth/session |
[**getMfaChallengeStatus**](AuthenticationApi.md#getmfachallengestatus) | **GET** /auth/mfa/status |
[**getSession**](AuthenticationApi.md#getsession) | **GET** /auth/session |
[**issueWebCsrfToken**](AuthenticationApi.md#issuewebcsrftoken) | **GET** /auth/csrf |
[**login**](AuthenticationApi.md#login) | **POST** /auth/login |
[**loginBuyerMobile**](AuthenticationApi.md#loginbuyermobile) | **POST** /mobile/auth/login |
[**logout**](AuthenticationApi.md#logout) | **POST** /auth/logout |
[**logoutBuyerMobile**](AuthenticationApi.md#logoutbuyermobile) | **POST** /mobile/auth/logout |
[**recoverBuyerMobileMfaChallenge**](AuthenticationApi.md#recoverbuyermobilemfachallenge) | **POST** /mobile/auth/mfa/recovery |
[**recoverMfaChallenge**](AuthenticationApi.md#recovermfachallenge) | **POST** /auth/mfa/recovery |
[**refreshBuyerMobileSession**](AuthenticationApi.md#refreshbuyermobilesession) | **POST** /mobile/auth/refresh |
[**refreshSession**](AuthenticationApi.md#refreshsession) | **POST** /auth/refresh |
[**registerAccount**](AuthenticationApi.md#registeraccount) | **POST** /auth/register |
[**registerBuyerMobile**](AuthenticationApi.md#registerbuyermobile) | **POST** /mobile/auth/register |
[**requestBuyerMobilePasswordRecovery**](AuthenticationApi.md#requestbuyermobilepasswordrecovery) | **POST** /mobile/auth/password/forgot |
[**requestPasswordRecovery**](AuthenticationApi.md#requestpasswordrecovery) | **POST** /auth/password/forgot |
[**resendBuyerMobileBotChallenge**](AuthenticationApi.md#resendbuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/resend |
[**resendBuyerMobileEmailVerification**](AuthenticationApi.md#resendbuyermobileemailverification) | **POST** /mobile/auth/verify-email/resend |
[**resendEmailVerification**](AuthenticationApi.md#resendemailverification) | **POST** /auth/verify-email/resend |
[**resendWebBotChallenge**](AuthenticationApi.md#resendwebbotchallenge) | **POST** /auth/bot-challenges/{challenge_id}/resend |
[**resetBuyerMobilePassword**](AuthenticationApi.md#resetbuyermobilepassword) | **POST** /mobile/auth/password/reset |
[**resetPassword**](AuthenticationApi.md#resetpassword) | **POST** /auth/password/reset |
[**startBuyerMobileGoogleOidc**](AuthenticationApi.md#startbuyermobilegoogleoidc) | **POST** /mobile/auth/google/start |
[**startGoogleOidc**](AuthenticationApi.md#startgoogleoidc) | **POST** /auth/google/start |
[**startMfaEnrollment**](AuthenticationApi.md#startmfaenrollment) | **POST** /auth/mfa/enrollment |
[**verifyBuyerMobileBotChallenge**](AuthenticationApi.md#verifybuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/verify |
[**verifyBuyerMobileEmail**](AuthenticationApi.md#verifybuyermobileemail) | **POST** /mobile/auth/verify-email |
[**verifyEmail**](AuthenticationApi.md#verifyemail) | **POST** /auth/verify-email |
[**verifyWebBotChallenge**](AuthenticationApi.md#verifywebbotchallenge) | **POST** /auth/bot-challenges/{challenge_id}/verify |


# **acceptAdminInvitation**
> RegistrationEnvelope acceptAdminInvitation(adminInvitationRequest)



Invitation-only Admin registration. Validates the invitation, recipient when supplied, and current inviter authority before bot verification or email delivery. When bot protection is enabled, requires the server-selected admin_invitation_accept checkbox action and configured hostname, or an accessible email proof bound to the invited email, portal, and action. Acceptance rechecks invitation availability after the provider call. No account or membership is created and no invitation consumed when bot validation fails. Authenticator enrollment remains required before staff access.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final AdminInvitationRequest adminInvitationRequest = ; // AdminInvitationRequest |

try {
    final response = api.acceptAdminInvitation(adminInvitationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->acceptAdminInvitation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminInvitationRequest** | [**AdminInvitationRequest**](AdminInvitationRequest.md)|  |

### Return type

[**RegistrationEnvelope**](RegistrationEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeBuyerMobileMfaChallenge**
> AuthEnvelope completeBuyerMobileMfaChallenge(buyerMobileMfaChallengeRequest)



Completes a Buyer sign-in (password or Google) when the Buyer enrolled an authenticator. The challenge_token comes from the login or Google exchange body, is opaque, single-use, expires with challenge_expires_in and is bound to the MOBILE transport. Five wrong codes end the challenge. Codes cannot be replayed.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final BuyerMobileMfaChallengeRequest buyerMobileMfaChallengeRequest = ; // BuyerMobileMfaChallengeRequest |

try {
    final response = api.completeBuyerMobileMfaChallenge(buyerMobileMfaChallengeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->completeBuyerMobileMfaChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMobileMfaChallengeRequest** | [**BuyerMobileMfaChallengeRequest**](BuyerMobileMfaChallengeRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeGoogleOidc**
> completeGoogleOidc(state, code)



Browser requests accepting text/html receive a safe branded error page on callback failure. JSON requests retain the canonical error envelope. No callback parameters are reflected into the HTML page.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final String state = state_example; // String |
final String code = code_example; // String |

try {
    api.completeGoogleOidc(state, code);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->completeGoogleOidc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **state** | **String**|  |
 **code** | **String**|  |

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/html, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeMfaChallenge**
> AuthEnvelope completeMfaChallenge(mfaCodeRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: mfaChallengeCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final MfaCodeRequest mfaCodeRequest = ; // MfaCodeRequest |

try {
    final response = api.completeMfaChallenge(mfaCodeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->completeMfaChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mfaCodeRequest** | [**MfaCodeRequest**](MfaCodeRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmMfaEnrollment**
> AuthEnvelope confirmMfaEnrollment(mfaCodeRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: mfaChallengeCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final MfaCodeRequest mfaCodeRequest = ; // MfaCodeRequest |

try {
    final response = api.confirmMfaEnrollment(mfaCodeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->confirmMfaEnrollment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mfaCodeRequest** | [**MfaCodeRequest**](MfaCodeRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exchangeBuyerMobileGoogleCode**
> AuthEnvelope exchangeBuyerMobileGoogleCode(googleMobileExchangeRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final GoogleMobileExchangeRequest googleMobileExchangeRequest = ; // GoogleMobileExchangeRequest |

try {
    final response = api.exchangeBuyerMobileGoogleCode(googleMobileExchangeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->exchangeBuyerMobileGoogleCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **googleMobileExchangeRequest** | [**GoogleMobileExchangeRequest**](GoogleMobileExchangeRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerMobileSession**
> AuthEnvelope getBuyerMobileSession()



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.getBuyerMobileSession();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->getBuyerMobileSession: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMfaChallengeStatus**
> MfaStatusEnvelope getMfaChallengeStatus()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: mfaChallengeCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.getMfaChallengeStatus();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->getMfaChallengeStatus: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MfaStatusEnvelope**](MfaStatusEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSession**
> AuthEnvelope getSession()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.getSession();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->getSession: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **issueWebCsrfToken**
> CsrfEnvelope issueWebCsrfToken()



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.issueWebCsrfToken();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->issueWebCsrfToken: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CsrfEnvelope**](CsrfEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> AuthEnvelope login(loginRequest)



Vendor and Admin browser login requires an Enterprise checkbox assessment when bot protection is enabled, or an accessible single-use email security proof. The server selects vendor_login or admin_login and validates the configured hostname. Admin MFA remains mandatory after bot validation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final LoginRequest loginRequest = ; // LoginRequest |

try {
    final response = api.login(loginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginBuyerMobile**
> AuthEnvelope loginBuyerMobile(buyerMobileLoginRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final BuyerMobileLoginRequest buyerMobileLoginRequest = ; // BuyerMobileLoginRequest |

try {
    final response = api.loginBuyerMobile(buyerMobileLoginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->loginBuyerMobile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMobileLoginRequest** | [**BuyerMobileLoginRequest**](BuyerMobileLoginRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> SuccessEnvelope logout()



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

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.logout();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->logout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logoutBuyerMobile**
> SuccessEnvelope logoutBuyerMobile()



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.logoutBuyerMobile();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->logoutBuyerMobile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recoverBuyerMobileMfaChallenge**
> AuthEnvelope recoverBuyerMobileMfaChallenge(buyerMobileMfaRecoveryRequest)



Completes the Buyer challenge with a single-use recovery code when the authenticator is unavailable. All other sessions are revoked and a replacement set of recovery codes is returned once.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final BuyerMobileMfaRecoveryRequest buyerMobileMfaRecoveryRequest = ; // BuyerMobileMfaRecoveryRequest |

try {
    final response = api.recoverBuyerMobileMfaChallenge(buyerMobileMfaRecoveryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->recoverBuyerMobileMfaChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMobileMfaRecoveryRequest** | [**BuyerMobileMfaRecoveryRequest**](BuyerMobileMfaRecoveryRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recoverMfaChallenge**
> AuthEnvelope recoverMfaChallenge(mfaRecoveryRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: mfaChallengeCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final MfaRecoveryRequest mfaRecoveryRequest = ; // MfaRecoveryRequest |

try {
    final response = api.recoverMfaChallenge(mfaRecoveryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->recoverMfaChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mfaRecoveryRequest** | [**MfaRecoveryRequest**](MfaRecoveryRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshBuyerMobileSession**
> AuthEnvelope refreshBuyerMobileSession(buyerMobileRefreshRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final BuyerMobileRefreshRequest buyerMobileRefreshRequest = ; // BuyerMobileRefreshRequest |

try {
    final response = api.refreshBuyerMobileSession(buyerMobileRefreshRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->refreshBuyerMobileSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMobileRefreshRequest** | [**BuyerMobileRefreshRequest**](BuyerMobileRefreshRequest.md)|  |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshSession**
> AuthEnvelope refreshSession()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.refreshSession();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->refreshSession: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerAccount**
> RegistrationEnvelope registerAccount(registerRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final RegisterRequest registerRequest = ; // RegisterRequest |

try {
    final response = api.registerAccount(registerRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->registerAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)|  |

### Return type

[**RegistrationEnvelope**](RegistrationEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerBuyerMobile**
> RegistrationEnvelope registerBuyerMobile(buyerMobileRegisterRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final BuyerMobileRegisterRequest buyerMobileRegisterRequest = ; // BuyerMobileRegisterRequest |

try {
    final response = api.registerBuyerMobile(buyerMobileRegisterRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->registerBuyerMobile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMobileRegisterRequest** | [**BuyerMobileRegisterRequest**](BuyerMobileRegisterRequest.md)|  |

### Return type

[**RegistrationEnvelope**](RegistrationEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestBuyerMobilePasswordRecovery**
> SuccessEnvelope requestBuyerMobilePasswordRecovery(buyerMobilePasswordRecoveryRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final BuyerMobilePasswordRecoveryRequest buyerMobilePasswordRecoveryRequest = ; // BuyerMobilePasswordRecoveryRequest |

try {
    final response = api.requestBuyerMobilePasswordRecovery(buyerMobilePasswordRecoveryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->requestBuyerMobilePasswordRecovery: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMobilePasswordRecoveryRequest** | [**BuyerMobilePasswordRecoveryRequest**](BuyerMobilePasswordRecoveryRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestPasswordRecovery**
> SuccessEnvelope requestPasswordRecovery(passwordRecoveryRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final PasswordRecoveryRequest passwordRecoveryRequest = ; // PasswordRecoveryRequest |

try {
    final response = api.requestPasswordRecovery(passwordRecoveryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->requestPasswordRecovery: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passwordRecoveryRequest** | [**PasswordRecoveryRequest**](PasswordRecoveryRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendBuyerMobileBotChallenge**
> SuccessEnvelope resendBuyerMobileBotChallenge(challengeId, resendBotChallengeRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final String challengeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ResendBotChallengeRequest resendBotChallengeRequest = ; // ResendBotChallengeRequest |

try {
    final response = api.resendBuyerMobileBotChallenge(challengeId, resendBotChallengeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->resendBuyerMobileBotChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **challengeId** | **String**|  |
 **resendBotChallengeRequest** | [**ResendBotChallengeRequest**](ResendBotChallengeRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendBuyerMobileEmailVerification**
> SuccessEnvelope resendBuyerMobileEmailVerification(emailRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final EmailRequest emailRequest = ; // EmailRequest |

try {
    final response = api.resendBuyerMobileEmailVerification(emailRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->resendBuyerMobileEmailVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailRequest** | [**EmailRequest**](EmailRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendEmailVerification**
> SuccessEnvelope resendEmailVerification(emailRequest)



Issues a new code for a pending Vendor account or an active Vendor account whose Owner email is still unverified. The response does not reveal whether an eligible account exists.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final EmailRequest emailRequest = ; // EmailRequest |

try {
    final response = api.resendEmailVerification(emailRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->resendEmailVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailRequest** | [**EmailRequest**](EmailRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendWebBotChallenge**
> SuccessEnvelope resendWebBotChallenge(challengeId, webResendBotChallengeRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final String challengeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final WebResendBotChallengeRequest webResendBotChallengeRequest = ; // WebResendBotChallengeRequest |

try {
    final response = api.resendWebBotChallenge(challengeId, webResendBotChallengeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->resendWebBotChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **challengeId** | **String**|  |
 **webResendBotChallengeRequest** | [**WebResendBotChallengeRequest**](WebResendBotChallengeRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetBuyerMobilePassword**
> SuccessEnvelope resetBuyerMobilePassword(passwordResetRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final PasswordResetRequest passwordResetRequest = ; // PasswordResetRequest |

try {
    final response = api.resetBuyerMobilePassword(passwordResetRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->resetBuyerMobilePassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passwordResetRequest** | [**PasswordResetRequest**](PasswordResetRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPassword**
> SuccessEnvelope resetPassword(passwordResetRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final PasswordResetRequest passwordResetRequest = ; // PasswordResetRequest |

try {
    final response = api.resetPassword(passwordResetRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->resetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passwordResetRequest** | [**PasswordResetRequest**](PasswordResetRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startBuyerMobileGoogleOidc**
> SuccessEnvelope startBuyerMobileGoogleOidc(buyerMobileGoogleOidcStartRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final BuyerMobileGoogleOidcStartRequest buyerMobileGoogleOidcStartRequest = ; // BuyerMobileGoogleOidcStartRequest |

try {
    final response = api.startBuyerMobileGoogleOidc(buyerMobileGoogleOidcStartRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->startBuyerMobileGoogleOidc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMobileGoogleOidcStartRequest** | [**BuyerMobileGoogleOidcStartRequest**](BuyerMobileGoogleOidcStartRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startGoogleOidc**
> SuccessEnvelope startGoogleOidc(googleOidcStartRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final GoogleOidcStartRequest googleOidcStartRequest = ; // GoogleOidcStartRequest |

try {
    final response = api.startGoogleOidc(googleOidcStartRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->startGoogleOidc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **googleOidcStartRequest** | [**GoogleOidcStartRequest**](GoogleOidcStartRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startMfaEnrollment**
> MfaEnrollmentEnvelope startMfaEnrollment()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: mfaChallengeCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('mfaChallengeCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();

try {
    final response = api.startMfaEnrollment();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->startMfaEnrollment: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MfaEnrollmentEnvelope**](MfaEnrollmentEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyBuyerMobileBotChallenge**
> BotProofEnvelope verifyBuyerMobileBotChallenge(challengeId, verifyBotChallengeRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final String challengeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VerifyBotChallengeRequest verifyBotChallengeRequest = ; // VerifyBotChallengeRequest |

try {
    final response = api.verifyBuyerMobileBotChallenge(challengeId, verifyBotChallengeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->verifyBuyerMobileBotChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **challengeId** | **String**|  |
 **verifyBotChallengeRequest** | [**VerifyBotChallengeRequest**](VerifyBotChallengeRequest.md)|  |

### Return type

[**BotProofEnvelope**](BotProofEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyBuyerMobileEmail**
> SuccessEnvelope verifyBuyerMobileEmail(verifyEmailRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAuthenticationApi();
final VerifyEmailRequest verifyEmailRequest = ; // VerifyEmailRequest |

try {
    final response = api.verifyBuyerMobileEmail(verifyEmailRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->verifyBuyerMobileEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyEmailRequest** | [**VerifyEmailRequest**](VerifyEmailRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyEmail**
> SuccessEnvelope verifyEmail(verifyEmailRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final VerifyEmailRequest verifyEmailRequest = ; // VerifyEmailRequest |

try {
    final response = api.verifyEmail(verifyEmailRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->verifyEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyEmailRequest** | [**VerifyEmailRequest**](VerifyEmailRequest.md)|  |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyWebBotChallenge**
> BotProofEnvelope verifyWebBotChallenge(challengeId, webVerifyBotChallengeRequest)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAuthenticationApi();
final String challengeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final WebVerifyBotChallengeRequest webVerifyBotChallengeRequest = ; // WebVerifyBotChallengeRequest |

try {
    final response = api.verifyWebBotChallenge(challengeId, webVerifyBotChallengeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->verifyWebBotChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **challengeId** | **String**|  |
 **webVerifyBotChallengeRequest** | [**WebVerifyBotChallengeRequest**](WebVerifyBotChallengeRequest.md)|  |

### Return type

[**BotProofEnvelope**](BotProofEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

