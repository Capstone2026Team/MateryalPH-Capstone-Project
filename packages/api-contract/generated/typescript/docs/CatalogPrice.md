
# CatalogPrice

Immutable ordinary public price version, VAT-inclusive payable amount in centavos.

## Properties

Name | Type
------------ | -------------
`priceVersionId` | string
`version` | number
`amountCentavos` | number
`taxCategory` | [TaxCategory](TaxCategory.md)
`taxBasis` | string
`includedVatCentavos` | number
`effectiveAt` | string

## Example

```typescript
import type { CatalogPrice } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "priceVersionId": null,
  "version": null,
  "amountCentavos": null,
  "taxCategory": null,
  "taxBasis": null,
  "includedVatCentavos": null,
  "effectiveAt": null,
} satisfies CatalogPrice

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogPrice
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


