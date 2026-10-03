
# ListingPrice

The ordinary public price per sale unit, a VAT-inclusive payable amount in centavos.

## Properties

Name | Type
------------ | -------------
`unitPriceCentavos` | number
`currency` | string
`unitCode` | string
`unitName` | string
`packQuantity` | string
`taxCategory` | string
`vatLabel` | string
`priceVersionId` | string
`effectiveAt` | Date

## Example

```typescript
import type { ListingPrice } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "unitPriceCentavos": null,
  "currency": null,
  "unitCode": null,
  "unitName": null,
  "packQuantity": null,
  "taxCategory": null,
  "vatLabel": null,
  "priceVersionId": null,
  "effectiveAt": null,
} satisfies ListingPrice

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingPrice
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


