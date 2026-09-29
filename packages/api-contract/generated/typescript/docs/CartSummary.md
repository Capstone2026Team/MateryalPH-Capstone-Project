
# CartSummary


## Properties

Name | Type
------------ | -------------
`lineCount` | number
`vendorCount` | number
`materialsSubtotalCentavos` | number
`notice` | string
`reservesStock` | boolean

## Example

```typescript
import type { CartSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lineCount": null,
  "vendorCount": null,
  "materialsSubtotalCentavos": null,
  "notice": null,
  "reservesStock": null,
} satisfies CartSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


