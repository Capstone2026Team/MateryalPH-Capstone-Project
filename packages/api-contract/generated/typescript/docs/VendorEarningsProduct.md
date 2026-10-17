
# VendorEarningsProduct


## Properties

Name | Type
------------ | -------------
`listingId` | string
`name` | string
`category` | string
`sku` | string
`orders` | number
`valueCentavos` | number
`vatCentavos` | number

## Example

```typescript
import type { VendorEarningsProduct } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "name": null,
  "category": null,
  "sku": null,
  "orders": null,
  "valueCentavos": null,
  "vatCentavos": null,
} satisfies VendorEarningsProduct

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsProduct
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


