
# VendorOrderReviews


## Properties

Name | Type
------------ | -------------
`orderId` | string
`orderReference` | string
`state` | string
`completedAt` | Date
`closesAt` | Date
`closesAtLabel` | string
`revealed` | boolean
`revealedAt` | Date
`revealReason` | string
`withheldForDispute` | boolean
`rules` | [ReviewWindowRules](ReviewWindowRules.md)
`party` | string
`buyerRating` | [OwnReview](OwnReview.md)
`canSubmitBuyerRating` | boolean
`received` | [Array&lt;PublicReview&gt;](PublicReview.md)

## Example

```typescript
import type { VendorOrderReviews } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderId": null,
  "orderReference": null,
  "state": null,
  "completedAt": null,
  "closesAt": null,
  "closesAtLabel": null,
  "revealed": null,
  "revealedAt": null,
  "revealReason": null,
  "withheldForDispute": null,
  "rules": null,
  "party": null,
  "buyerRating": null,
  "canSubmitBuyerRating": null,
  "received": null,
} satisfies VendorOrderReviews

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOrderReviews
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


