# materyalph_api_client.api.AdminFinanceOperationsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**approveRemittanceReconciliation**](AdminFinanceOperationsApi.md#approveremittancereconciliation) | **POST** /admin/finance/remittances/{assessmentId}/approve-reconciliation |
[**getFinanceKpis**](AdminFinanceOperationsApi.md#getfinancekpis) | **GET** /admin/finance/kpis |
[**getWithholdingRegister**](AdminFinanceOperationsApi.md#getwithholdingregister) | **GET** /admin/finance/withholding-register |
[**getWithholdingVendor**](AdminFinanceOperationsApi.md#getwithholdingvendor) | **GET** /admin/finance/withholding-register/{vendorId} |
[**listRemittanceQueue**](AdminFinanceOperationsApi.md#listremittancequeue) | **GET** /admin/finance/remittances |
[**listTaxAdjustments**](AdminFinanceOperationsApi.md#listtaxadjustments) | **GET** /admin/finance/tax-adjustments |
[**listTaxEvidenceQueue**](AdminFinanceOperationsApi.md#listtaxevidencequeue) | **GET** /admin/finance/evidence |
[**listTaxIssues**](AdminFinanceOperationsApi.md#listtaxissues) | **GET** /admin/finance/tax-issues |
[**postTaxAdjustment**](AdminFinanceOperationsApi.md#posttaxadjustment) | **POST** /admin/finance/tax-adjustments/{adjustmentId}/post |
[**prepareTaxAdjustment**](AdminFinanceOperationsApi.md#preparetaxadjustment) | **POST** /admin/finance/tax-adjustments/{adjustmentId}/prepare |
[**reviewTaxAdjustment**](AdminFinanceOperationsApi.md#reviewtaxadjustment) | **POST** /admin/finance/tax-adjustments/{adjustmentId}/review |


# **approveRemittanceReconciliation**
> RemittanceReconciliationDecisionEnvelope approveRemittanceReconciliation(assessmentId, idempotencyKey, remittanceReconciliationApproval)



Backup approval of a recorded TEST platform remittance. Requires active ADMIN_SUPERADMIN or ADMIN_FINANCE membership, finance.view, finance.approve_remittance_reconciliation and recent authentication. The supplied source version must match the locked assessment. Collection, calculation and ledger checks must all pass; an approval cannot override a mismatch, open tax adjustment, fully refunded or voided collection. An immutable SIMULATED decision and audit event are recorded once. This never confirms a live settlement, BIR filing or BIR payment.

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
final String assessmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = idempotencyKey_example; // String |
final RemittanceReconciliationApproval remittanceReconciliationApproval = ; // RemittanceReconciliationApproval |

try {
    final response = api.approveRemittanceReconciliation(assessmentId, idempotencyKey, remittanceReconciliationApproval);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->approveRemittanceReconciliation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assessmentId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **remittanceReconciliationApproval** | [**RemittanceReconciliationApproval**](RemittanceReconciliationApproval.md)|  |

### Return type

[**RemittanceReconciliationDecisionEnvelope**](RemittanceReconciliationDecisionEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFinanceKpis**
> FinanceKpiEnvelope getFinanceKpis(from, to)



finance.view. Recorded commission earnings, approved credits, verified allocated collections, confirmed fee refunds, pending and overdue commissions, and net platform earnings after fee VAT and platform processing costs. Earnings/credits, collections and refunds use their event dates; current debt uses statement issue dates. GMV and CWT stay separate. Monthly activity is bounded to the most recent 120 recorded periods. TEST origins are retained; this endpoint does not enable live payments.

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

# **getWithholdingRegister**
> WithholdingRegisterEnvelope getWithholdingRegister(month, page)



finance.view. TEST withholding assessments across Vendors for one collection calendar month in Asia/Manila. Platform and provider obligations stay separate. When month is omitted, use the latest month with a non-voided TEST assessment and linked collection, or the current Manila month if none exist. An explicit month is always respected, including months without assessments. Totals cover all pages, exclude VOIDED assessments and include only POSTED tax. Original assessment amounts precede linked corrections; reviewed packages apply posted corrections. These amounts are not cash held, a BIR payable balance or evidence of deduction, filing or payment. Production assignment stays UNCONFIRMED.

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
final String month = month_example; // String |
final int page = 56; // int |

try {
    final response = api.getWithholdingRegister(month, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->getWithholdingRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **month** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**WithholdingRegisterEnvelope**](WithholdingRegisterEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWithholdingVendor**
> WithholdingVendorDetailEnvelope getWithholdingVendor(vendorId, month, withholdingEntity, page)



Read-only finance.view projection of saved TEST payment assessments for one Vendor, withholding entity and Manila collection month. Paginated payments retain original per-payment rounding and nullable unposted amounts. Declaration status is evaluated at month end or now, whichever is earlier. The yearly meter is returned only for approved in-period evidence and uses the saved full-taxpayer-year accumulator across stores and declared external remittances. No raw taxpayer identity, private evidence or provider payload is returned. No tax is recalculated.

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
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String month = month_example; // String |
final String withholdingEntity = withholdingEntity_example; // String |
final int page = 56; // int |

try {
    final response = api.getWithholdingVendor(vendorId, month, withholdingEntity, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->getWithholdingVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **month** | **String**|  |
 **withholdingEntity** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**WithholdingVendorDetailEnvelope**](WithholdingVendorDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRemittanceQueue**
> RemittanceQueueEnvelope listRemittanceQueue(reconciliationState, calculationState, deductionEvidenceState, page, from, to)



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
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Assessment created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Assessment created_at.

try {
    final response = api.listRemittanceQueue(reconciliationState, calculationState, deductionEvidenceState, page, from, to);
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
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Assessment created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Assessment created_at. | [optional]

### Return type

[**RemittanceQueueEnvelope**](RemittanceQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTaxAdjustments**
> TaxAdjustmentListEnvelope listTaxAdjustments(state, page, from, to)



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
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Adjustment created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Adjustment created_at.

try {
    final response = api.listTaxAdjustments(state, page, from, to);
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
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Adjustment created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Adjustment created_at. | [optional]

### Return type

[**TaxAdjustmentListEnvelope**](TaxAdjustmentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTaxEvidenceQueue**
> TaxEvidenceQueueEnvelope listTaxEvidenceQueue(reviewState, page, from, to)



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
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Evidence created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Evidence created_at.

try {
    final response = api.listTaxEvidenceQueue(reviewState, page, from, to);
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
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Evidence created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Evidence created_at. | [optional]

### Return type

[**TaxEvidenceQueueEnvelope**](TaxEvidenceQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTaxIssues**
> FinanceReviewItemListEnvelope listTaxIssues(page)



Read-only finance.view action queue across all periods. Combines OPEN finance work with non-voided TEST withholding source blockers that have no OPEN work item for the same assessment. WITHHOLDING_SOURCE rows link to source correction and cannot be resolved through the work-item mutation. This projection does not create, resolve or change any financial record.

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
final int page = 56; // int |

try {
    final response = api.listTaxIssues(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceOperationsApi->listTaxIssues: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**FinanceReviewItemListEnvelope**](FinanceReviewItemListEnvelope.md)

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

