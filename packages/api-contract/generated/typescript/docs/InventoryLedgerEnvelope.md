
# InventoryLedgerEnvelope


## Properties

Name | Type
------------ | -------------
`data` | [Array&lt;InventoryRow&gt;](InventoryRow.md)
`meta` | [InventoryLedgerMeta](InventoryLedgerMeta.md)
`errors` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { InventoryLedgerEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies InventoryLedgerEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryLedgerEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


