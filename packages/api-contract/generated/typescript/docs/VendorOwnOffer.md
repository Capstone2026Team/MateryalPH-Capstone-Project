
# VendorOwnOffer

Your own current comparable price; never part of the competitor average.

## Properties

Name | Type
------------ | -------------
`listingId` | string
`variantId` | string
`displayName` | string
`variantLabel` | string
`priceCentavos` | number
`normalizedPhp` | string
`taxLabel` | string
`priceAsOf` | Date

## Example

```typescript
import type { VendorOwnOffer } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "variantId": null,
  "displayName": null,
  "variantLabel": null,
  "priceCentavos": null,
  "normalizedPhp": null,
  "taxLabel": null,
  "priceAsOf": null,
} satisfies VendorOwnOffer

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOwnOffer
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


