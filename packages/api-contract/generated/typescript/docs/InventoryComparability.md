
# InventoryComparability

MAT-03 source version of the current comparable-group mapping.

## Properties

Name | Type
------------ | -------------
`status` | string
`groupVersionId` | string
`ruleVersion` | string

## Example

```typescript
import type { InventoryComparability } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "groupVersionId": null,
  "ruleVersion": null,
} satisfies InventoryComparability

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryComparability
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


