# materyalph_api_client.api.AdminFinanceOperationsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getFinanceKpis**](AdminFinanceOperationsApi.md#getfinancekpis) | **GET** /admin/finance/kpis |
[**listRemittanceQueue**](AdminFinanceOperationsApi.md#listremittancequeue) | **GET** /admin/finance/remittances |
[**listTaxAdjustments**](AdminFinanceOperationsApi.md#listtaxadjustments) | **GET** /admin/finance/tax-adjustments |
[**listTaxEvidenceQueue**](AdminFinanceOperationsApi.md#listtaxevidencequeue) | **GET** /admin/finance/evidence |
[**postTaxAdjustment**](AdminFinanceOperationsApi.md#posttaxadjustment) | **POST** /admin/finance/tax-adjustments/{adjustmentId}/post |
[**prepareTaxAdjustment**](AdminFinanceOperationsApi.md#preparetaxadjustment) | **POST** /admin/finance/tax-adjustments/{adjustmentId}/prepare |
[**reviewTaxAdjustment**](AdminFinanceOperationsApi.md#reviewtaxadjustment) | **POST** /admin/finance/tax-adjustments/{adjustmentId}/review |


# **getFinanceKpis**
> FinanceKpiEnvelope getFinanceKpis(from, to)



finance.view. Gross and net GMV beside assessed CWT, commission, platform revenue, collected cash and receivables (DEMO).

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

final api = MateryalphApiClient().getAdminFinanceOperationsApi();
final Date from = 2013-10-20; // Date |
final Date to = 2013-10-20; // Date |

try {
    final response = api.getFinanceKpis(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->getFinanceKpis: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | [optional]
 **to** | **Date**|  | [optional]

### Return type

[**FinanceKpiEnvelope**](FinanceKpiEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRemittanceQueue**
> RemittanceQueueEnvelope listRemittanceQueue(reconciliationState, calculationState, deductionEvidenceState, page)



finance.view. Remittance reconciliation queue with FIN-05 components and FIN-04A threshold before/after.

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

final api = MateryalphApiClient().getAdminFinanceOperationsApi();
final String reconciliationState = reconciliationState_example; // String |
final String calculationState = calculationState_example; // String |
final String deductionEvidenceState = deductionEvidenceState_example; // String |
final int page = 56; // int |

try {
    final response = api.listRemittanceQueue(reconciliationState, calculationState, deductionEvidenceState, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->listRemittanceQueue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reconciliationState** | **String**|  | [optional]
 **calculationState** | **String**|  | [optional]
 **deductionEvidenceState** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**RemittanceQueueEnvelope**](RemittanceQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTaxAdjustments**
> TaxAdjustmentListEnvelope listTaxAdjustments(state, page)



finance.view. Tax adjustments with preparer, reviewer and the actions available to you.

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

final api = MateryalphApiClient().getAdminFinanceOperationsApi();
final String state = state_example; // String |
final int page = 56; // int |

try {
    final response = api.listTaxAdjustments(state, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->listTaxAdjustments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **state** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**TaxAdjustmentListEnvelope**](TaxAdjustmentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTaxEvidenceQueue**
> TaxEvidenceQueueEnvelope listTaxEvidenceQueue(reviewState, page)



finance.view. Tax evidence review state; decisions are made in the Vendor Verification case.

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

final api = MateryalphApiClient().getAdminFinanceOperationsApi();
final String reviewState = reviewState_example; // String |
final int page = 56; // int |

try {
    final response = api.listTaxEvidenceQueue(reviewState, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->listTaxEvidenceQueue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewState** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**TaxEvidenceQueueEnvelope**](TaxEvidenceQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postTaxAdjustment**
> TaxAdjustmentEnvelope postTaxAdjustment(adjustmentId)



finance.review_tax. Post an approved adjustment as a linked compensating entry; posted assessments and the FIN-04A counter are never rewritten.

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

final api = MateryalphApiClient().getAdminFinanceOperationsApi();
final String adjustmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.postTaxAdjustment(adjustmentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->postTaxAdjustment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adjustmentId** | **String**|  |

### Return type

[**TaxAdjustmentEnvelope**](TaxAdjustmentEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **prepareTaxAdjustment**
> TaxAdjustmentEnvelope prepareTaxAdjustment(adjustmentId, taxAdjustmentPrepareRequest)



finance.review_tax. Record the proposed correction, reason, evidence reference and certificate impact.

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

final api = MateryalphApiClient().getAdminFinanceOperationsApi();
final String adjustmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final TaxAdjustmentPrepareRequest taxAdjustmentPrepareRequest = ; // TaxAdjustmentPrepareRequest |

try {
    final response = api.prepareTaxAdjustment(adjustmentId, taxAdjustmentPrepareRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->prepareTaxAdjustment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adjustmentId** | **String**|  |
 **taxAdjustmentPrepareRequest** | [**TaxAdjustmentPrepareRequest**](TaxAdjustmentPrepareRequest.md)|  |

### Return type

[**TaxAdjustmentEnvelope**](TaxAdjustmentEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewTaxAdjustment**
> TaxAdjustmentEnvelope reviewTaxAdjustment(adjustmentId, taxAdjustmentReviewRequest)



finance.review_tax by a different user than the preparer.

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

final api = MateryalphApiClient().getAdminFinanceOperationsApi();
final String adjustmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final TaxAdjustmentReviewRequest taxAdjustmentReviewRequest = ; // TaxAdjustmentReviewRequest |

try {
    final response = api.reviewTaxAdjustment(adjustmentId, taxAdjustmentReviewRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->reviewTaxAdjustment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adjustmentId** | **String**|  |
 **taxAdjustmentReviewRequest** | [**TaxAdjustmentReviewRequest**](TaxAdjustmentReviewRequest.md)|  |

### Return type

[**TaxAdjustmentEnvelope**](TaxAdjustmentEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

