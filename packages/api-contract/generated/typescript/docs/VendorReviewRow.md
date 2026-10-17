
# VendorReviewRow


## Properties

Name | Type
------------ | -------------
`id` | string
`type` | string
`ratings` | [ReviewRatings](ReviewRatings.md)
`comment` | string
`displayName` | string
`verifiedPurchase` | boolean
`submittedAt` | Date
`edited` | boolean
`variantLabel` | string
`product` | [ReviewProduct](ReviewProduct.md)
`media` | [Array&lt;ReviewMediaLink&gt;](ReviewMediaLink.md)
`visibility` | string
`orderId` | string
`orderReference` | string
`canReport` | boolean

## Example

```typescript
import type { VendorReviewRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "type": null,
  "ratings": null,
  "comment": null,
  "displayName": null,
  "verifiedPurchase": null,
  "submittedAt": null,
  "edited": null,
  "variantLabel": null,
  "product": null,
  "media": null,
  "visibility": null,
  "orderId": null,
  "orderReference": null,
  "canReport": null,
} satisfies VendorReviewRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorReviewRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


