
# CartItemCreate


## Properties

Name | Type
------------ | -------------
`listingVariantId` | string
`expectedPriceVersionId` | string
`quantity` | string
`fulfillmentMethod` | string
`locationId` | string
`latitude` | number
`longitude` | number
`originSource` | string
`radiusKm` | number

## Example

```typescript
import type { CartItemCreate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingVariantId": null,
  "expectedPriceVersionId": null,
  "quantity": null,
  "fulfillmentMethod": null,
  "locationId": null,
  "latitude": null,
  "longitude": null,
  "originSource": null,
  "radiusKm": null,
} satisfies CartItemCreate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartItemCreate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


