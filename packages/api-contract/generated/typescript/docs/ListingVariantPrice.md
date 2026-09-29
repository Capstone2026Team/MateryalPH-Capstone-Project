
# ListingVariantPrice


## Properties

Name | Type
------------ | -------------
`priceVersionId` | string
`unitPriceCentavos` | number
`currency` | string
`taxCategory` | string
`vatLabel` | string
`includedVatCentavos` | number
`effectiveAt` | Date

## Example

```typescript
import type { ListingVariantPrice } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "priceVersionId": null,
  "unitPriceCentavos": null,
  "currency": null,
  "taxCategory": null,
  "vatLabel": null,
  "includedVatCentavos": null,
  "effectiveAt": null,
} satisfies ListingVariantPrice

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingVariantPrice
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


