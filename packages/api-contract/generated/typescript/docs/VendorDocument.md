
# VendorDocument


## Properties

Name | Type
------------ | -------------
`id` | string
`requirementKey` | string
`version` | number
`scanState` | string

## Example

```typescript
import type { VendorDocument } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "requirementKey": null,
  "version": null,
  "scanState": null,
} satisfies VendorDocument

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDocument
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


