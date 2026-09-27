
# CatalogVariantInput


## Properties

Name | Type
------------ | -------------
`id` | string
`sku` | string
`label` | string
`unitId` | string
`packQuantity` | string
`priceCentavos` | number
`taxCategory` | [TaxCategory](TaxCategory.md)
`taxBasis` | string
`weightKg` | string
`lengthCm` | string
`widthCm` | string
`heightCm` | string
`quantityOnHand` | string
`active` | boolean
`attributes` | { [key: string]: string; }
`volumeTiers` | [Array&lt;CatalogVolumeTierInput&gt;](CatalogVolumeTierInput.md)

## Example

```typescript
import type { CatalogVariantInput } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "sku": null,
  "label": null,
  "unitId": null,
  "packQuantity": null,
  "priceCentavos": null,
  "taxCategory": null,
  "taxBasis": null,
  "weightKg": null,
  "lengthCm": null,
  "widthCm": null,
  "heightCm": null,
  "quantityOnHand": null,
  "active": null,
  "attributes": null,
  "volumeTiers": null,
} satisfies CatalogVariantInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogVariantInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


