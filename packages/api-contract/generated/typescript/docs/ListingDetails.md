
# ListingDetails


## Properties

Name | Type
------------ | -------------
`listingId` | string
`publicationVersion` | number
`displayName` | string
`description` | string
`brand` | string
`model` | string
`manufacturer` | string
`countryOfManufacture` | string
`category` | [ListingCategoryRef](ListingCategoryRef.md)
`technicalAttributes` | { [key: string]: any; }
`images` | [Array&lt;ListingImage&gt;](ListingImage.md)
`compliance` | [ListingCompliance](ListingCompliance.md)
`productRating` | [ProductRatingSummary](ProductRatingSummary.md)
`unitsSold` | string
`isFavorite` | boolean
`purchasable` | boolean
`notPurchasableReason` | string
`distanceMeters` | number
`vendor` | [ListingDetailVendor](ListingDetailVendor.md)
`fulfillment` | [ListingDetailFulfillment](ListingDetailFulfillment.md)
`variants` | [Array&lt;ListingVariantOffer&gt;](ListingVariantOffer.md)
`scope` | [DiscoveryScope](DiscoveryScope.md)
`currentAsOf` | Date
`eligibilityVersion` | string

## Example

```typescript
import type { ListingDetails } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "publicationVersion": null,
  "displayName": null,
  "description": null,
  "brand": null,
  "model": null,
  "manufacturer": null,
  "countryOfManufacture": null,
  "category": null,
  "technicalAttributes": null,
  "images": null,
  "compliance": null,
  "productRating": null,
  "unitsSold": null,
  "isFavorite": null,
  "purchasable": null,
  "notPurchasableReason": null,
  "distanceMeters": null,
  "vendor": null,
  "fulfillment": null,
  "variants": null,
  "scope": null,
  "currentAsOf": null,
  "eligibilityVersion": null,
} satisfies ListingDetails

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingDetails
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


