
# CatalogVariant


## Properties

Name | Type
------------ | -------------
`id` | string
`sku` | string
`label` | string
`unitId` | string
`unitCode` | string
`packQuantity` | string
`attributes` | { [key: string]: string; }
`active` | boolean
`weightKg` | string
`lengthCm` | string
`widthCm` | string
`heightCm` | string
`lockVersion` | number
`price` | [CatalogPrice](CatalogPrice.md)
`volumeTiers` | [Array&lt;CatalogVolumeTier&gt;](CatalogVolumeTier.md)
`inventory` | [CatalogInventory](CatalogInventory.md)
`publicAvailability` | string
`comparability` | string

## Example

```typescript
import type { CatalogVariant } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "sku": null,
  "label": null,
  "unitId": null,
  "unitCode": null,
  "packQuantity": null,
  "attributes": null,
  "active": null,
  "weightKg": null,
  "lengthCm": null,
  "widthCm": null,
  "heightCm": null,
  "lockVersion": null,
  "price": null,
  "volumeTiers": null,
  "inventory": null,
  "publicAvailability": null,
  "comparability": null,
} satisfies CatalogVariant

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogVariant
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


