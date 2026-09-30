
# OrderLine


## Properties

Name | Type
------------ | -------------
`id` | string
`lineNumber` | number
`listingId` | string
`listingVariantId` | string
`displayName` | string
`variantLabel` | string
`brand` | string
`category` | string
`image` | [ListingImage](ListingImage.md)
`unitCode` | string
`unitName` | string
`unitPrecision` | number
`quantityStep` | string
`requestedQuantity` | string
`confirmedQuantity` | string
`unitPriceCentavos` | number
`ordinaryUnitPriceCentavos` | number
`volumeTierApplied` | boolean
`volumeTiers` | [Array&lt;OrderVolumeTier&gt;](OrderVolumeTier.md)
`grossCentavos` | number
`discountCentavos` | number
`lineTotalCentavos` | number
`includedVatCentavos` | number
`taxCategory` | [TaxCategory](TaxCategory.md)
`vatLabel` | string
`change` | string
`priceVersionId` | string
`inventory` | [OrderLineInventory](OrderLineInventory.md)

## Example

```typescript
import type { OrderLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "lineNumber": null,
  "listingId": null,
  "listingVariantId": null,
  "displayName": null,
  "variantLabel": null,
  "brand": null,
  "category": null,
  "image": null,
  "unitCode": null,
  "unitName": null,
  "unitPrecision": null,
  "quantityStep": null,
  "requestedQuantity": null,
  "confirmedQuantity": null,
  "unitPriceCentavos": null,
  "ordinaryUnitPriceCentavos": null,
  "volumeTierApplied": null,
  "volumeTiers": null,
  "grossCentavos": null,
  "discountCentavos": null,
  "lineTotalCentavos": null,
  "includedVatCentavos": null,
  "taxCategory": null,
  "vatLabel": null,
  "change": null,
  "priceVersionId": null,
  "inventory": null,
} satisfies OrderLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


