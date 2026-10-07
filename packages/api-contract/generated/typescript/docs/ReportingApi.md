# ReportingApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**downloadDocumentExport**](ReportingApi.md#downloaddocumentexport) | **GET** /{audience}/reports/{exportId}/download | download Document Export |
| [**getTaxPackage**](ReportingApi.md#gettaxpackage) | **GET** /admin/reports/tax/{packageId} | get Tax Package |
| [**listDocumentExports**](ReportingApi.md#listdocumentexports) | **GET** /{audience}/reports | list Document Exports |
| [**listTaxPackages**](ReportingApi.md#listtaxpackages) | **GET** /admin/reports/tax | list Tax Packages |
| [**prepareTaxPackage**](ReportingApi.md#preparetaxpackage) | **POST** /admin/reports/tax | prepare Tax Package |
| [**recordTaxSimulation**](ReportingApi.md#recordtaxsimulation) | **POST** /admin/reports/tax/{packageId}/simulation | record Tax Simulation |
| [**requestDocumentExport**](ReportingApi.md#requestdocumentexport) | **POST** /{audience}/reports | request Document Export |
| [**reviewTaxPackage**](ReportingApi.md#reviewtaxpackage) | **POST** /admin/reports/tax/{packageId}/review | review Tax Package |



## downloadDocumentExport

> Blob downloadDocumentExport(audience, exportId)

download Document Export



### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { DownloadDocumentExportRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // string
    exportId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies DownloadDocumentExportRequest;

  try {
    const data = await api.downloadDocumentExport(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **exportId** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getTaxPackage

> PrepareTaxPackage201Response getTaxPackage(packageId)

get Tax Package



### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { GetTaxPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetTaxPackageRequest;

  try {
    const data = await api.getTaxPackage(body);
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
| **packageId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**PrepareTaxPackage201Response**](PrepareTaxPackage201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listDocumentExports

> ListDocumentExports200Response listDocumentExports(audience, page)

list Document Exports



### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { ListDocumentExportsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // number (optional)
    page: 56,
  } satisfies ListDocumentExportsRequest;

  try {
    const data = await api.listDocumentExports(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ListDocumentExports200Response**](ListDocumentExports200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listTaxPackages

> ListTaxPackages200Response listTaxPackages(page)

list Tax Packages



### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { ListTaxPackagesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // number (optional)
    page: 56,
  } satisfies ListTaxPackagesRequest;

  try {
    const data = await api.listTaxPackages(body);
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
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ListTaxPackages200Response**](ListTaxPackages200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## prepareTaxPackage

> PrepareTaxPackage201Response prepareTaxPackage(idempotencyKey, taxPackageInput)

prepare Tax Package



### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { PrepareTaxPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // string
    idempotencyKey: idempotencyKey_example,
    // TaxPackageInput
    taxPackageInput: ...,
  } satisfies PrepareTaxPackageRequest;

  try {
    const data = await api.prepareTaxPackage(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **taxPackageInput** | [TaxPackageInput](TaxPackageInput.md) |  | |

### Return type

[**PrepareTaxPackage201Response**](PrepareTaxPackage201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## recordTaxSimulation

> RecordTaxSimulation200Response recordTaxSimulation(packageId)

record Tax Simulation

Only SIMULATED_SUBMISSION_RECORDED after export; never FILED or BIR_PAID, no government receipt.

### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { RecordTaxSimulationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies RecordTaxSimulationRequest;

  try {
    const data = await api.recordTaxSimulation(body);
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
| **packageId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**RecordTaxSimulation200Response**](RecordTaxSimulation200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## requestDocumentExport

> RequestDocumentExport202Response requestDocumentExport(audience, idempotencyKey, documentExportInput)

request Document Export

Private immutable snapshot. Current access checked at request, generation and download. Admin requires recent authentication. Files expire 24 hours after generation. MAT audience suppression applies.

### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { RequestDocumentExportRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // string
    idempotencyKey: idempotencyKey_example,
    // DocumentExportInput
    documentExportInput: ...,
  } satisfies RequestDocumentExportRequest;

  try {
    const data = await api.requestDocumentExport(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **documentExportInput** | [DocumentExportInput](DocumentExportInput.md) |  | |

### Return type

[**RequestDocumentExport202Response**](RequestDocumentExport202Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reviewTaxPackage

> PrepareTaxPackage201Response reviewTaxPackage(packageId, taxPackageReview)

review Tax Package

Independent finance reviewer, source reconciliation and cited actual deadline required. Nominal deadline retained. No live tax filing.

### Example

```ts
import {
  Configuration,
  ReportingApi,
} from '@materyalph/api-client-ts';
import type { ReviewTaxPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ReportingApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // TaxPackageReview
    taxPackageReview: ...,
  } satisfies ReviewTaxPackageRequest;

  try {
    const data = await api.reviewTaxPackage(body);
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
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **taxPackageReview** | [TaxPackageReview](TaxPackageReview.md) |  | |

### Return type

[**PrepareTaxPackage201Response**](PrepareTaxPackage201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

