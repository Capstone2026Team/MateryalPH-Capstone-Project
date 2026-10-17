
# VendorFinanceReviews

Owner only. Statement approval and payment status, tax adjustments, evidence review state and open finance reviews; no reviewer notes or taxpayer identifiers.

## Properties

Name | Type
------------ | -------------
`label` | string
`statements` | Array&lt;{ [key: string]: any; }&gt;
`taxAdjustments` | Array&lt;{ [key: string]: any; }&gt;
`evidence` | Array&lt;{ [key: string]: any; }&gt;
`openReviews` | [Array&lt;VendorFinanceReviewsOpenReviewsInner&gt;](VendorFinanceReviewsOpenReviewsInner.md)

## Example

```typescript
import type { VendorFinanceReviews } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "label": null,
  "statements": null,
  "taxAdjustments": null,
  "evidence": null,
  "openReviews": null,
} satisfies VendorFinanceReviews

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorFinanceReviews
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


