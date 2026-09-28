
# InventoryBalance

Vendor-only exact quantities. Never returned to Buyers or analytics.

## Properties

Name | Type
------------ | -------------
`quantityOnHand` | string
`hardReservedQuantity` | string
`softHeldQuantity` | string
`availableToSell` | string
`reorderLevel` | string
`confirmedAt` | Date
`updatedAt` | string

## Example

```typescript
import type { InventoryBalance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "quantityOnHand": null,
  "hardReservedQuantity": null,
  "softHeldQuantity": null,
  "availableToSell": null,
  "reorderLevel": null,
  "confirmedAt": null,
  "updatedAt": null,
} satisfies InventoryBalance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryBalance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


