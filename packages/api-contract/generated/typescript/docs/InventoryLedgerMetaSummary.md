
# InventoryLedgerMetaSummary


## Properties

Name | Type
------------ | -------------
`variants` | number
`outOfStock` | number
`limitedStock` | number
`confirmationDue` | number
`stale` | number

## Example

```typescript
import type { InventoryLedgerMetaSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "variants": null,
  "outOfStock": null,
  "limitedStock": null,
  "confirmationDue": null,
  "stale": null,
} satisfies InventoryLedgerMetaSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryLedgerMetaSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


