
# ListingSearchResult


## Properties

Name | Type
------------ | -------------
`listingId` | string
`variantId` | string
`rank` | number
`displayName` | string
`brand` | string
`category` | [ListingCategoryRef](ListingCategoryRef.md)
`variantLabel` | string
`optionsCount` | number
`image` | [ListingImage](ListingImage.md)
`price` | [ListingPrice](ListingPrice.md)
`comparable` | [ComparableStatus](ComparableStatus.md)
`stockLabel` | string
`stockConfirmedAt` | Date
`productRating` | [ProductRatingSummary](ProductRatingSummary.md)
`unitsSold` | string
`distanceMeters` | number
`badges` | Array&lt;string&gt;
`isFavorite` | boolean
`vendor` | [ListingVendorCard](ListingVendorCard.md)
`fulfillment` | [ListingFulfillmentSummary](ListingFulfillmentSummary.md)
`ranking` | [RankingExplanation](RankingExplanation.md)

## Example

```typescript
import type { ListingSearchResult } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "variantId": null,
  "rank": null,
  "displayName": null,
  "brand": null,
  "category": null,
  "variantLabel": null,
  "optionsCount": null,
  "image": null,
  "price": null,
  "comparable": null,
  "stockLabel": null,
  "stockConfirmedAt": null,
  "productRating": null,
  "unitsSold": null,
  "distanceMeters": null,
  "badges": null,
  "isFavorite": null,
  "vendor": null,
  "fulfillment": null,
  "ranking": null,
} satisfies ListingSearchResult

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingSearchResult
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


