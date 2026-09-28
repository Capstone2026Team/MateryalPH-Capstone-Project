
# InventoryRowUpdate


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`quantityOnHand` | string
`reorderLevel` | string
`reasonCode` | string
`note` | string
`price` | [InventoryPriceChange](InventoryPriceChange.md)

## Example

```typescript
import type { InventoryRowUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "quantityOnHand": null,
  "reorderLevel": null,
  "reasonCode": null,
  "note": null,
  "price": null,
} satisfies InventoryRowUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryRowUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


