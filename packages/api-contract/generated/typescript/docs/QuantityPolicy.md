
# QuantityPolicy

Selling quantities in the selected unit. GAL is a whole can; US_GAL is measured volume. Absent on older records; use recorded selling unit and precision without converting quantities.

## Properties

Name | Type
------------ | -------------
`mode` | string
`dimension` | string
`precision` | number
`step` | string

## Example

```typescript
import type { QuantityPolicy } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "mode": null,
  "dimension": null,
  "precision": null,
  "step": null,
} satisfies QuantityPolicy

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as QuantityPolicy
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


