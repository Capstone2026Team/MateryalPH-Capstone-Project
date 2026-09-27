
# CatalogVolumeTier

CAT-PRICE-01 immutable volume tier price version. Applies to an order line whose quantity reaches minimum_quantity; the highest reached tier wins.

## Properties

Name | Type
------------ | -------------
`priceVersionId` | string
`version` | number
`minimumQuantity` | string
`amountCentavos` | number
`includedVatCentavos` | number

## Example

```typescript
import type { CatalogVolumeTier } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "priceVersionId": null,
  "version": null,
  "minimumQuantity": null,
  "amountCentavos": null,
  "includedVatCentavos": null,
} satisfies CatalogVolumeTier

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogVolumeTier
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


