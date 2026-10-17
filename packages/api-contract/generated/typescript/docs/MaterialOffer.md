
# MaterialOffer

Buyer-only current public offer; opens the existing Product Details. Never exact stock.

## Properties

Name | Type
------------ | -------------
`vendorId` | string
`storeName` | string
`listingId` | string
`variantId` | string
`displayName` | string
`variantLabel` | string
`priceCentavos` | number
`normalizedPhp` | string
`taxCategory` | string
`taxLabel` | string
`availability` | string
`distanceMeters` | number
`priceAsOf` | Date

## Example

```typescript
import type { MaterialOffer } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "storeName": null,
  "listingId": null,
  "variantId": null,
  "displayName": null,
  "variantLabel": null,
  "priceCentavos": null,
  "normalizedPhp": null,
  "taxCategory": null,
  "taxLabel": null,
  "availability": null,
  "distanceMeters": null,
  "priceAsOf": null,
} satisfies MaterialOffer

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MaterialOffer
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


