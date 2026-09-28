
# PriceHistoryEntry


## Properties

Name | Type
------------ | -------------
`priceVersionId` | string
`version` | number
`priceKind` | string
`amountCentavos` | number
`taxCategory` | [TaxCategory](TaxCategory.md)
`minimumQuantity` | string
`includedVatCentavos` | number
`effectiveAt` | string
`retiredAt` | string
`supersedesPriceVersionId` | string
`current` | boolean
`createdBy` | string

## Example

```typescript
import type { PriceHistoryEntry } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "priceVersionId": null,
  "version": null,
  "priceKind": null,
  "amountCentavos": null,
  "taxCategory": null,
  "minimumQuantity": null,
  "includedVatCentavos": null,
  "effectiveAt": null,
  "retiredAt": null,
  "supersedesPriceVersionId": null,
  "current": null,
  "createdBy": null,
} satisfies PriceHistoryEntry

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PriceHistoryEntry
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


