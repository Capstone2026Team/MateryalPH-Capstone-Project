
# ProjectSeparatePurchase


## Properties

Name | Type
------------ | -------------
`load` | { [key: string]: any; }
`stage` | string
`lineId` | string
`variantId` | string
`listingId` | string
`displayName` | string
`variantLabel` | string
`vendorId` | string
`storeName` | string
`quantity` | string
`unitCode` | string
`unitPriceCentavos` | number
`lineTotalCentavos` | number
`satisfiesRequirement` | boolean
`orderId` | string
`orderReference` | string
`draftItemId` | string
`image` | [ListingImage](ListingImage.md)
`specifications` | [Array&lt;ProjectSpecificationDetail&gt;](ProjectSpecificationDetail.md)
`coverageQuantity` | string

## Example

```typescript
import type { ProjectSeparatePurchase } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "load": null,
  "stage": null,
  "lineId": null,
  "variantId": null,
  "listingId": null,
  "displayName": null,
  "variantLabel": null,
  "vendorId": null,
  "storeName": null,
  "quantity": null,
  "unitCode": null,
  "unitPriceCentavos": null,
  "lineTotalCentavos": null,
  "satisfiesRequirement": null,
  "orderId": null,
  "orderReference": null,
  "draftItemId": null,
  "image": null,
  "specifications": null,
  "coverageQuantity": null,
} satisfies ProjectSeparatePurchase

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectSeparatePurchase
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


