
# BuyerReviewSubmitRequest

Any not-yet-submitted subset; each rating once per order or purchased line. Requires a COMPLETED order inside its 14-day window.

## Properties

Name | Type
------------ | -------------
`displayNameChoice` | string
`vendorRating` | [BuyerReviewSubmitRequestVendorRating](BuyerReviewSubmitRequestVendorRating.md)
`productReviews` | [Array&lt;BuyerReviewSubmitRequestProductReviewsInner&gt;](BuyerReviewSubmitRequestProductReviewsInner.md)

## Example

```typescript
import type { BuyerReviewSubmitRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "displayNameChoice": null,
  "vendorRating": null,
  "productReviews": null,
} satisfies BuyerReviewSubmitRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerReviewSubmitRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


