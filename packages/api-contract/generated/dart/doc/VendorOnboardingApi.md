# materyalph_api_client.api.VendorOnboardingApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptVendorCommissionTerms**](VendorOnboardingApi.md#acceptvendorcommissionterms) | **POST** /vendors/{organization}/commission-terms/acceptance | accept Vendor Commission Terms
[**activateVendorMarketplace**](VendorOnboardingApi.md#activatevendormarketplace) | **POST** /vendors/{organization}/activation | activate Vendor Marketplace
[**changeVendorTeamMember**](VendorOnboardingApi.md#changevendorteammember) | **PATCH** /vendors/{organization}/team/memberships/{membership} | change Vendor Team Member
[**confirmVendorStoreEmailVerification**](VendorOnboardingApi.md#confirmvendorstoreemailverification) | **POST** /vendors/{organization}/business/store-email/verification/confirm | confirm Vendor Store Email Verification
[**connectVendorTest**](VendorOnboardingApi.md#connectvendortest) | **POST** /vendors/{organization}/payment-connection | connect Vendor Test
[**downloadAdminVendorDocument**](VendorOnboardingApi.md#downloadadminvendordocument) | **GET** /admin/vendor-verification/{organization}/documents/{version}/download | download Admin Vendor Document
[**downloadVendorDocument**](VendorOnboardingApi.md#downloadvendordocument) | **GET** /vendors/{organization}/documents/{version}/download | download Vendor Document
[**getAdminVendorBusiness**](VendorOnboardingApi.md#getadminvendorbusiness) | **GET** /admin/vendor-verification/{organization}/business | get Admin Vendor Business
[**getAdminVendorReadiness**](VendorOnboardingApi.md#getadminvendorreadiness) | **GET** /admin/vendor-verification/{organization}/onboarding | get Admin Vendor Readiness
[**getAdminVendorTaxProfile**](VendorOnboardingApi.md#getadminvendortaxprofile) | **GET** /admin/vendor-verification/{organization}/tax-profile | get Admin Vendor Tax Profile
[**getPublicVendorStoreMedia**](VendorOnboardingApi.md#getpublicvendorstoremedia) | **GET** /public/vendors/{organization}/store-media/{media} | get Public Vendor Store Media
[**getVendorBusiness**](VendorOnboardingApi.md#getvendorbusiness) | **GET** /vendors/{organization}/business | get Vendor Business
[**getVendorCommissionTerms**](VendorOnboardingApi.md#getvendorcommissionterms) | **GET** /vendors/{organization}/commission-terms | get Vendor Commission Terms
[**getVendorReadiness**](VendorOnboardingApi.md#getvendorreadiness) | **GET** /vendors/{organization}/onboarding | get Vendor Readiness
[**getVendorSetup**](VendorOnboardingApi.md#getvendorsetup) | **GET** /vendors/{organization}/setup | get Vendor Setup
[**getVendorTaxProfile**](VendorOnboardingApi.md#getvendortaxprofile) | **GET** /vendors/{organization}/tax-profile | get Vendor Tax Profile
[**getVendorTeam**](VendorOnboardingApi.md#getvendorteam) | **GET** /vendors/{organization}/team | get Vendor Team
[**inviteVendorTeam**](VendorOnboardingApi.md#invitevendorteam) | **POST** /vendors/{organization}/team/invitations | invite Vendor Team
[**issueAdminVendorDocumentLink**](VendorOnboardingApi.md#issueadminvendordocumentlink) | **POST** /admin/vendor-verification/{organization}/documents/{version}/download-link | issue Admin Vendor Document Link
[**issueVendorDocumentLink**](VendorOnboardingApi.md#issuevendordocumentlink) | **POST** /vendors/{organization}/documents/{version}/download-link | issue Vendor Document Link
[**listAdminVendorDocuments**](VendorOnboardingApi.md#listadminvendordocuments) | **GET** /admin/vendor-verification/{organization}/documents | list Admin Vendor Documents
[**listAdminVendorStoreMedia**](VendorOnboardingApi.md#listadminvendorstoremedia) | **GET** /admin/vendor-verification/{organization}/store-media | list Admin Vendor Store Media
[**listVendorDocuments**](VendorOnboardingApi.md#listvendordocuments) | **GET** /vendors/{organization}/documents | list Vendor Documents
[**listVendorStoreMedia**](VendorOnboardingApi.md#listvendorstoremedia) | **GET** /vendors/{organization}/store-media | list Vendor Store Media
[**listVendorTeamInvitations**](VendorOnboardingApi.md#listvendorteaminvitations) | **GET** /vendors/{organization}/team/invitations | list Vendor Team Invitations
[**listVendorVerificationQueue**](VendorOnboardingApi.md#listvendorverificationqueue) | **GET** /admin/vendor-verification | list Vendor Verification Queue
[**previewAdminVendorStoreMedia**](VendorOnboardingApi.md#previewadminvendorstoremedia) | **GET** /admin/vendor-verification/{organization}/store-media/{media} | preview Admin Vendor Store Media
[**previewVendorStoreMedia**](VendorOnboardingApi.md#previewvendorstoremedia) | **GET** /vendors/{organization}/store-media/{media} | preview Vendor Store Media
[**reconcileVendorTestConnection**](VendorOnboardingApi.md#reconcilevendortestconnection) | **POST** /vendors/{organization}/payment-connection/reconciliation | reconcile Vendor Test Connection
[**removeVendorStoreMedia**](VendorOnboardingApi.md#removevendorstoremedia) | **POST** /vendors/{organization}/store-media/{media}/remove | remove Vendor Store Media
[**requestVendorStoreEmailVerification**](VendorOnboardingApi.md#requestvendorstoreemailverification) | **POST** /vendors/{organization}/business/store-email/verification | request Vendor Store Email Verification
[**reviewVendorBusiness**](VendorOnboardingApi.md#reviewvendorbusiness) | **POST** /admin/vendor-verification/{organization}/business/reviews | review Vendor Business
[**reviewVendorDocument**](VendorOnboardingApi.md#reviewvendordocument) | **POST** /admin/vendor-verification/{organization}/documents/{version}/reviews | review Vendor Document
[**reviewVendorStoreMedia**](VendorOnboardingApi.md#reviewvendorstoremedia) | **POST** /admin/vendor-verification/{organization}/store-media/{media}/reviews | review Vendor Store Media
[**reviewVendorTaxProfile**](VendorOnboardingApi.md#reviewvendortaxprofile) | **POST** /admin/vendor-verification/{organization}/tax-profile/versions/{version}/reviews | review Vendor Tax Profile
[**revokeVendorTeamInvitation**](VendorOnboardingApi.md#revokevendorteaminvitation) | **POST** /vendors/{organization}/team/invitations/{invitation}/revoke | revoke Vendor Team Invitation
[**saveVendorBusiness**](VendorOnboardingApi.md#savevendorbusiness) | **PUT** /vendors/{organization}/business | save Vendor Business
[**saveVendorStore**](VendorOnboardingApi.md#savevendorstore) | **PUT** /vendors/{organization}/store-profile | save Vendor Store
[**saveVendorTaxProfile**](VendorOnboardingApi.md#savevendortaxprofile) | **POST** /vendors/{organization}/tax-profile/versions | save Vendor Tax Profile
[**uploadVendorDocument**](VendorOnboardingApi.md#uploadvendordocument) | **POST** /vendors/{organization}/documents | upload Vendor Document
[**uploadVendorStoreMedia**](VendorOnboardingApi.md#uploadvendorstoremedia) | **POST** /vendors/{organization}/store-media | upload Vendor Store Media


# **acceptVendorCommissionTerms**
> VendorCommissionTermsEnvelope acceptVendorCommissionTerms(organization, acceptVendorCommission)

accept Vendor Commission Terms

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AcceptVendorCommission acceptVendorCommission = ; // AcceptVendorCommission |

try {
    final response = api.acceptVendorCommissionTerms(organization, acceptVendorCommission);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->acceptVendorCommissionTerms: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **acceptVendorCommission** | [**AcceptVendorCommission**](AcceptVendorCommission.md)|  |

### Return type

[**VendorCommissionTermsEnvelope**](VendorCommissionTermsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **activateVendorMarketplace**
> VendorReadinessEnvelope activateVendorMarketplace(organization, vendorVersionMutation)

activate Vendor Marketplace

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorVersionMutation vendorVersionMutation = ; // VendorVersionMutation |

try {
    final response = api.activateVendorMarketplace(organization, vendorVersionMutation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->activateVendorMarketplace: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **vendorVersionMutation** | [**VendorVersionMutation**](VendorVersionMutation.md)|  |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **changeVendorTeamMember**
> VendorMutationEnvelope changeVendorTeamMember(organization, membership, changeVendorTeamMember)

change Vendor Team Member

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String membership = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ChangeVendorTeamMember changeVendorTeamMember = ; // ChangeVendorTeamMember |

try {
    final response = api.changeVendorTeamMember(organization, membership, changeVendorTeamMember);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->changeVendorTeamMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **membership** | **String**|  |
 **changeVendorTeamMember** | [**ChangeVendorTeamMember**](ChangeVendorTeamMember.md)|  |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmVendorStoreEmailVerification**
> VendorBusinessEnvelope confirmVendorStoreEmailVerification(organization, vendorStoreEmailVerificationConfirmation)

confirm Vendor Store Email Verification

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorStoreEmailVerificationConfirmation vendorStoreEmailVerificationConfirmation = ; // VendorStoreEmailVerificationConfirmation |

try {
    final response = api.confirmVendorStoreEmailVerification(organization, vendorStoreEmailVerificationConfirmation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->confirmVendorStoreEmailVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **vendorStoreEmailVerificationConfirmation** | [**VendorStoreEmailVerificationConfirmation**](VendorStoreEmailVerificationConfirmation.md)|  |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **connectVendorTest**
> VendorSetupEnvelope connectVendorTest(organization, connectVendorTest)

connect Vendor Test

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ConnectVendorTest connectVendorTest = ; // ConnectVendorTest |

try {
    final response = api.connectVendorTest(organization, connectVendorTest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->connectVendorTest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **connectVendorTest** | [**ConnectVendorTest**](ConnectVendorTest.md)|  |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadAdminVendorDocument**
> Uint8List downloadAdminVendorDocument(organization, version, expires, signature, viewer)

download Admin Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String version = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String expires = expires_example; // String |
final String signature = signature_example; // String |
final String viewer = viewer_example; // String |

try {
    final response = api.downloadAdminVendorDocument(organization, version, expires, signature, viewer);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->downloadAdminVendorDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **version** | **String**|  |
 **expires** | **String**|  |
 **signature** | **String**|  |
 **viewer** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadVendorDocument**
> Uint8List downloadVendorDocument(organization, version, expires, signature, viewer)

download Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String version = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String expires = expires_example; // String |
final String signature = signature_example; // String |
final String viewer = viewer_example; // String |

try {
    final response = api.downloadVendorDocument(organization, version, expires, signature, viewer);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->downloadVendorDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **version** | **String**|  |
 **expires** | **String**|  |
 **signature** | **String**|  |
 **viewer** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminVendorBusiness**
> VendorBusinessEnvelope getAdminVendorBusiness(organization)

get Admin Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminVendorBusiness(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getAdminVendorBusiness: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminVendorReadiness**
> VendorReadinessEnvelope getAdminVendorReadiness(organization)

get Admin Vendor Readiness

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminVendorReadiness(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getAdminVendorReadiness: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminVendorTaxProfile**
> VendorTaxProfileEnvelope getAdminVendorTaxProfile(organization)

get Admin Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminVendorTaxProfile(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getAdminVendorTaxProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorTaxProfileEnvelope**](VendorTaxProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPublicVendorStoreMedia**
> Uint8List getPublicVendorStoreMedia(organization, media)

get Public Vendor Store Media

Public delivery for an approved, unreplaced Store Profile image belonging to an active Vendor.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String media = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getPublicVendorStoreMedia(organization, media);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getPublicVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **media** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorBusiness**
> VendorBusinessEnvelope getVendorBusiness(organization)

get Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorBusiness(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorBusiness: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorCommissionTerms**
> VendorCommissionTermsEnvelope getVendorCommissionTerms(organization)

get Vendor Commission Terms

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorCommissionTerms(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorCommissionTerms: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorCommissionTermsEnvelope**](VendorCommissionTermsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorReadiness**
> VendorReadinessEnvelope getVendorReadiness(organization)

get Vendor Readiness

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorReadiness(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorReadiness: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorSetup**
> VendorSetupEnvelope getVendorSetup(organization)

get Vendor Setup

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorSetup(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorSetup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorTaxProfile**
> VendorTaxProfileEnvelope getVendorTaxProfile(organization)

get Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorTaxProfile(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorTaxProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorTaxProfileEnvelope**](VendorTaxProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorTeam**
> VendorTeamEnvelope getVendorTeam(organization, page, perPage)

get Vendor Team

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final int perPage = 56; // int |

try {
    final response = api.getVendorTeam(organization, page, perPage);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->getVendorTeam: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **page** | **int**|  | [optional] [default to 1]
 **perPage** | **int**|  | [optional] [default to 20]

### Return type

[**VendorTeamEnvelope**](VendorTeamEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inviteVendorTeam**
> VendorMutationEnvelope inviteVendorTeam(organization, idempotencyKey, inviteVendorTeam)

invite Vendor Team

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InviteVendorTeam inviteVendorTeam = ; // InviteVendorTeam |

try {
    final response = api.inviteVendorTeam(organization, idempotencyKey, inviteVendorTeam);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->inviteVendorTeam: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **idempotencyKey** | **String**|  |
 **inviteVendorTeam** | [**InviteVendorTeam**](InviteVendorTeam.md)|  |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **issueAdminVendorDocumentLink**
> VendorDownloadLinkEnvelope issueAdminVendorDocumentLink(organization, version)

issue Admin Vendor Document Link

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String version = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.issueAdminVendorDocumentLink(organization, version);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->issueAdminVendorDocumentLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **version** | **String**|  |

### Return type

[**VendorDownloadLinkEnvelope**](VendorDownloadLinkEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **issueVendorDocumentLink**
> VendorDownloadLinkEnvelope issueVendorDocumentLink(organization, version)

issue Vendor Document Link

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String version = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.issueVendorDocumentLink(organization, version);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->issueVendorDocumentLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **version** | **String**|  |

### Return type

[**VendorDownloadLinkEnvelope**](VendorDownloadLinkEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminVendorDocuments**
> VendorDocumentListEnvelope listAdminVendorDocuments(organization, page, perPage)

list Admin Vendor Documents

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final int perPage = 56; // int |

try {
    final response = api.listAdminVendorDocuments(organization, page, perPage);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listAdminVendorDocuments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **page** | **int**|  | [optional] [default to 1]
 **perPage** | **int**|  | [optional] [default to 20]

### Return type

[**VendorDocumentListEnvelope**](VendorDocumentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminVendorStoreMedia**
> VendorStoreMediaListEnvelope listAdminVendorStoreMedia(organization)

list Admin Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listAdminVendorStoreMedia(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listAdminVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorStoreMediaListEnvelope**](VendorStoreMediaListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorDocuments**
> VendorDocumentListEnvelope listVendorDocuments(organization, page, perPage)

list Vendor Documents

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final int perPage = 56; // int |

try {
    final response = api.listVendorDocuments(organization, page, perPage);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listVendorDocuments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **page** | **int**|  | [optional] [default to 1]
 **perPage** | **int**|  | [optional] [default to 20]

### Return type

[**VendorDocumentListEnvelope**](VendorDocumentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorStoreMedia**
> VendorStoreMediaListEnvelope listVendorStoreMedia(organization)

list Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listVendorStoreMedia(organization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |

### Return type

[**VendorStoreMediaListEnvelope**](VendorStoreMediaListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorTeamInvitations**
> VendorTeamInvitationListEnvelope listVendorTeamInvitations(organization, page, perPage)

list Vendor Team Invitations

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final int perPage = 56; // int |

try {
    final response = api.listVendorTeamInvitations(organization, page, perPage);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listVendorTeamInvitations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **page** | **int**|  | [optional] [default to 1]
 **perPage** | **int**|  | [optional] [default to 20]

### Return type

[**VendorTeamInvitationListEnvelope**](VendorTeamInvitationListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorVerificationQueue**
> VendorVerificationRowListEnvelope listVendorVerificationQueue(page, perPage)

list Vendor Verification Queue

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final int page = 56; // int |
final int perPage = 56; // int |

try {
    final response = api.listVendorVerificationQueue(page, perPage);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->listVendorVerificationQueue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]
 **perPage** | **int**|  | [optional] [default to 20]

### Return type

[**VendorVerificationRowListEnvelope**](VendorVerificationRowListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewAdminVendorStoreMedia**
> Uint8List previewAdminVendorStoreMedia(organization, media)

preview Admin Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String media = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.previewAdminVendorStoreMedia(organization, media);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->previewAdminVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **media** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewVendorStoreMedia**
> Uint8List previewVendorStoreMedia(organization, media)

preview Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOnboardingApi();
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String media = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.previewVendorStoreMedia(organization, media);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->previewVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **media** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reconcileVendorTestConnection**
> VendorSetupEnvelope reconcileVendorTestConnection(organization, vendorVersionMutation)

reconcile Vendor Test Connection

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorVersionMutation vendorVersionMutation = ; // VendorVersionMutation |

try {
    final response = api.reconcileVendorTestConnection(organization, vendorVersionMutation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->reconcileVendorTestConnection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **vendorVersionMutation** | [**VendorVersionMutation**](VendorVersionMutation.md)|  |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeVendorStoreMedia**
> VendorMutationEnvelope removeVendorStoreMedia(organization, media, vendorVersionMutation)

remove Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String media = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorVersionMutation vendorVersionMutation = ; // VendorVersionMutation |

try {
    final response = api.removeVendorStoreMedia(organization, media, vendorVersionMutation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->removeVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **media** | **String**|  |
 **vendorVersionMutation** | [**VendorVersionMutation**](VendorVersionMutation.md)|  |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestVendorStoreEmailVerification**
> VendorBusinessEnvelope requestVendorStoreEmailVerification(organization, vendorStoreEmailVerificationRequest)

request Vendor Store Email Verification

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorStoreEmailVerificationRequest vendorStoreEmailVerificationRequest = ; // VendorStoreEmailVerificationRequest |

try {
    final response = api.requestVendorStoreEmailVerification(organization, vendorStoreEmailVerificationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->requestVendorStoreEmailVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **vendorStoreEmailVerificationRequest** | [**VendorStoreEmailVerificationRequest**](VendorStoreEmailVerificationRequest.md)|  |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewVendorBusiness**
> VendorReadinessEnvelope reviewVendorBusiness(organization, vendorBusinessReview)

review Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorBusinessReview vendorBusinessReview = ; // VendorBusinessReview |

try {
    final response = api.reviewVendorBusiness(organization, vendorBusinessReview);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->reviewVendorBusiness: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **vendorBusinessReview** | [**VendorBusinessReview**](VendorBusinessReview.md)|  |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewVendorDocument**
> VendorReadinessEnvelope reviewVendorDocument(organization, version, vendorDocumentReview)

review Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String version = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorDocumentReview vendorDocumentReview = ; // VendorDocumentReview |

try {
    final response = api.reviewVendorDocument(organization, version, vendorDocumentReview);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->reviewVendorDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **version** | **String**|  |
 **vendorDocumentReview** | [**VendorDocumentReview**](VendorDocumentReview.md)|  |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewVendorStoreMedia**
> VendorMutationEnvelope reviewVendorStoreMedia(organization, media, vendorReview)

review Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String media = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorReview vendorReview = ; // VendorReview |

try {
    final response = api.reviewVendorStoreMedia(organization, media, vendorReview);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->reviewVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **media** | **String**|  |
 **vendorReview** | [**VendorReview**](VendorReview.md)|  |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewVendorTaxProfile**
> VendorReadinessEnvelope reviewVendorTaxProfile(organization, version, vendorReview)

review Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String version = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorReview vendorReview = ; // VendorReview |

try {
    final response = api.reviewVendorTaxProfile(organization, version, vendorReview);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->reviewVendorTaxProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **version** | **String**|  |
 **vendorReview** | [**VendorReview**](VendorReview.md)|  |

### Return type

[**VendorReadinessEnvelope**](VendorReadinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeVendorTeamInvitation**
> VendorMutationEnvelope revokeVendorTeamInvitation(organization, invitation, vendorVersionMutation)

revoke Vendor Team Invitation

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String invitation = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorVersionMutation vendorVersionMutation = ; // VendorVersionMutation |

try {
    final response = api.revokeVendorTeamInvitation(organization, invitation, vendorVersionMutation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->revokeVendorTeamInvitation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **invitation** | **String**|  |
 **vendorVersionMutation** | [**VendorVersionMutation**](VendorVersionMutation.md)|  |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorBusiness**
> VendorBusinessEnvelope saveVendorBusiness(organization, saveVendorBusiness)

save Vendor Business

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final SaveVendorBusiness saveVendorBusiness = ; // SaveVendorBusiness |

try {
    final response = api.saveVendorBusiness(organization, saveVendorBusiness);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->saveVendorBusiness: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **saveVendorBusiness** | [**SaveVendorBusiness**](SaveVendorBusiness.md)|  |

### Return type

[**VendorBusinessEnvelope**](VendorBusinessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorStore**
> VendorSetupEnvelope saveVendorStore(organization, saveVendorStore)

save Vendor Store

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final SaveVendorStore saveVendorStore = ; // SaveVendorStore |

try {
    final response = api.saveVendorStore(organization, saveVendorStore);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->saveVendorStore: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **saveVendorStore** | [**SaveVendorStore**](SaveVendorStore.md)|  |

### Return type

[**VendorSetupEnvelope**](VendorSetupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorTaxProfile**
> VendorTaxProfileEnvelope saveVendorTaxProfile(organization, saveVendorTax)

save Vendor Tax Profile

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final SaveVendorTax saveVendorTax = ; // SaveVendorTax |

try {
    final response = api.saveVendorTaxProfile(organization, saveVendorTax);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->saveVendorTaxProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **saveVendorTax** | [**SaveVendorTax**](SaveVendorTax.md)|  |

### Return type

[**VendorTaxProfileEnvelope**](VendorTaxProfileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadVendorDocument**
> VendorDocumentUploadEnvelope uploadVendorDocument(organization, lockVersion, documentType, file)

upload Vendor Document

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int lockVersion = 56; // int |
final String documentType = documentType_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |

try {
    final response = api.uploadVendorDocument(organization, lockVersion, documentType, file);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->uploadVendorDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **lockVersion** | **int**|  |
 **documentType** | **String**|  |
 **file** | **MultipartFile**|  |

### Return type

[**VendorDocumentUploadEnvelope**](VendorDocumentUploadEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadVendorStoreMedia**
> VendorMutationEnvelope uploadVendorStoreMedia(organization, lockVersion, kind, altText, file)

upload Vendor Store Media

TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.

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
final String organization = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int lockVersion = 56; // int |
final String kind = kind_example; // String |
final String altText = altText_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |

try {
    final response = api.uploadVendorStoreMedia(organization, lockVersion, kind, altText, file);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOnboardingApi->uploadVendorStoreMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization** | **String**|  |
 **lockVersion** | **int**|  |
 **kind** | **String**|  |
 **altText** | **String**|  |
 **file** | **MultipartFile**|  |

### Return type

[**VendorMutationEnvelope**](VendorMutationEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

