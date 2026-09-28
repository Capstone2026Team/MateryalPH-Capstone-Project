
# CatalogInventory

Vendor-only exact stock. Never returned to Buyers.

## Properties

Name | Type
------------ | -------------
`quantityOnHand` | string
`hardReservedQuantity` | string
`availableToSell` | string
`softHeldQuantity` | string
`reorderLevel` | string
`confirmedAt` | string

## Example

```typescript
import type { CatalogInventory } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "quantityOnHand": null,
  "hardReservedQuantity": null,
  "availableToSell": null,
  "softHeldQuantity": null,
  "reorderLevel": null,
  "confirmedAt": null,
} satisfies CatalogInventory

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogInventory
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


