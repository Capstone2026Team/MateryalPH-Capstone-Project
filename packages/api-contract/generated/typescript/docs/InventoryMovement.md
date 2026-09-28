
# InventoryMovement


## Properties

Name | Type
------------ | -------------
`id` | string
`movementType` | string
`quantityDelta` | string
`quantityOnHandBefore` | string
`quantityOnHandAfter` | string
`hardReservedAfter` | string
`reasonCode` | string
`note` | string
`sourceType` | string
`actor` | string
`recordedAt` | string

## Example

```typescript
import type { InventoryMovement } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "movementType": null,
  "quantityDelta": null,
  "quantityOnHandBefore": null,
  "quantityOnHandAfter": null,
  "hardReservedAfter": null,
  "reasonCode": null,
  "note": null,
  "sourceType": null,
  "actor": null,
  "recordedAt": null,
} satisfies InventoryMovement

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryMovement
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


