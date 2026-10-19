
# WorkPackageAlternative


## Properties

Name | Type
------------ | -------------
`listingId` | string
`variantId` | string
`priceVersionId` | string
`displayName` | string
`variantLabel` | string
`brand` | string
`vendorId` | string
`storeName` | string
`image` | [ListingImage](ListingImage.md)
`unitPriceCentavos` | number
`unitCode` | string
`unitPrecision` | number
`distanceMeters` | number
`stockLabel` | string
`specifications` | [Array&lt;ProjectSpecificationDetail&gt;](ProjectSpecificationDetail.md)
`exactMatch` | boolean
`availability` | string
`estimatedTotalCentavos` | number
`fulfillmentMethods` | Array&lt;string&gt;
`alreadyAdded` | boolean

## Example

```typescript
import type { WorkPackageAlternative } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "variantId": null,
  "priceVersionId": null,
  "displayName": null,
  "variantLabel": null,
  "brand": null,
  "vendorId": null,
  "storeName": null,
  "image": null,
  "unitPriceCentavos": null,
  "unitCode": null,
  "unitPrecision": null,
  "distanceMeters": null,
  "stockLabel": null,
  "specifications": null,
  "exactMatch": null,
  "availability": null,
  "estimatedTotalCentavos": null,
  "fulfillmentMethods": null,
  "alreadyAdded": null,
} satisfies WorkPackageAlternative

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageAlternative
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


