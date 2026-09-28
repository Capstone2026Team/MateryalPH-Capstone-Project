
# InventoryRow


## Properties

Name | Type
------------ | -------------
`listingVariantId` | string
`listingId` | string
`listingName` | string
`listingStatus` | [ListingStatus](ListingStatus.md)
`variantLabel` | string
`sku` | string
`unitCode` | string
`lockVersion` | number
`inventory` | [InventoryBalance](InventoryBalance.md)
`publicLabel` | [StockLabel](StockLabel.md)
`stockConfirmation` | [StockConfirmationSchedule](StockConfirmationSchedule.md)
`listingConfirmation` | [StockConfirmationSchedule](StockConfirmationSchedule.md)
`price` | [InventoryPrice](InventoryPrice.md)
`comparability` | [InventoryComparability](InventoryComparability.md)
`autoAccept` | [AutoAcceptPolicy](AutoAcceptPolicy.md)

## Example

```typescript
import type { InventoryRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingVariantId": null,
  "listingId": null,
  "listingName": null,
  "listingStatus": null,
  "variantLabel": null,
  "sku": null,
  "unitCode": null,
  "lockVersion": null,
  "inventory": null,
  "publicLabel": null,
  "stockConfirmation": null,
  "listingConfirmation": null,
  "price": null,
  "comparability": null,
  "autoAccept": null,
} satisfies InventoryRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


