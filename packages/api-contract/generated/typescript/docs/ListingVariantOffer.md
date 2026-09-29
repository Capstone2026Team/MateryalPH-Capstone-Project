
# ListingVariantOffer


## Properties

Name | Type
------------ | -------------
`variantId` | string
`sku` | string
`label` | string
`attributes` | { [key: string]: any; }
`unitCode` | string
`unitName` | string
`packQuantity` | string
`quantityStep` | string
`available` | boolean
`availabilityNote` | string
`stockLabel` | string
`stockConfirmedAt` | Date
`price` | [ListingVariantPrice](ListingVariantPrice.md)
`volumeTiers` | [Array&lt;VolumeTier&gt;](VolumeTier.md)
`bestPrice` | boolean
`comparable` | [ComparableStatus](ComparableStatus.md)

## Example

```typescript
import type { ListingVariantOffer } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "variantId": null,
  "sku": null,
  "label": null,
  "attributes": null,
  "unitCode": null,
  "unitName": null,
  "packQuantity": null,
  "quantityStep": null,
  "available": null,
  "availabilityNote": null,
  "stockLabel": null,
  "stockConfirmedAt": null,
  "price": null,
  "volumeTiers": null,
  "bestPrice": null,
  "comparable": null,
} satisfies ListingVariantOffer

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingVariantOffer
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


