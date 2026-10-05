
# BuyerOrderReviews

The Vendor\'s rating of the Buyer appears only after the blind reveal and while visible.

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
`speedKind` | string
`speedLabel` | string
`displayNameOptions` | [Array&lt;ReviewDisplayOption&gt;](ReviewDisplayOption.md)
`vendorRating` | [OwnReview](OwnReview.md)
`canSubmitVendorRating` | boolean
`lines` | [Array&lt;ReviewLine&gt;](ReviewLine.md)
`counterpartRating` | [CounterpartRating](CounterpartRating.md)

## Example

```typescript
import type { BuyerOrderReviews } from '@materyalph/api-client-ts'

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
  "speedKind": null,
  "speedLabel": null,
  "displayNameOptions": null,
  "vendorRating": null,
  "canSubmitVendorRating": null,
  "lines": null,
  "counterpartRating": null,
} satisfies BuyerOrderReviews

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerOrderReviews
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


