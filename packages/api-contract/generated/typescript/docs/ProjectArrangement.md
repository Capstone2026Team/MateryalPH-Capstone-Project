
# ProjectArrangement

A Work Package procurement arrangement with equal suppliers, independent vendor quotations and orders. Version zero is a computed proposal; explicit preview saves a draft without orders, reservations or payment. Vendor objects include assigned items, specification choices, current fulfillment/payment options, delivery preview, public map facts and individual quotation/order status.

## Properties

Name | Type
------------ | -------------
`fms` | { [key: string]: any; }
`rank` | number
`proposalToken` | string
`id` | string
`sourceCandidateId` | string
`version` | number
`workPackageVersionId` | string
`vendors` | Array&lt;{ [key: string]: any; }&gt;
`vendorCount` | number
`coverage` | { [key: string]: any; }
`materialsCentavos` | number
`deliveryCentavos` | number
`totalCentavos` | number
`budgetLabel` | string
`fingerprint` | string
`issues` | Array&lt;string&gt;
`submitted` | boolean
`stale` | boolean
`previousVendors` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { ProjectArrangement } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fms": null,
  "rank": null,
  "proposalToken": null,
  "id": null,
  "sourceCandidateId": null,
  "version": null,
  "workPackageVersionId": null,
  "vendors": null,
  "vendorCount": null,
  "coverage": null,
  "materialsCentavos": null,
  "deliveryCentavos": null,
  "totalCentavos": null,
  "budgetLabel": null,
  "fingerprint": null,
  "issues": null,
  "submitted": null,
  "stale": null,
  "previousVendors": null,
} satisfies ProjectArrangement

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectArrangement
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


