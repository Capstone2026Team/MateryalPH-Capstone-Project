
# CartLocationRef


## Properties

Name | Type
------------ | -------------
`locationId` | string
`label` | string
`kind` | string
`formattedAddress` | string
`status` | string

## Example

```typescript
import type { CartLocationRef } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "locationId": null,
  "label": null,
  "kind": null,
  "formattedAddress": null,
  "status": null,
} satisfies CartLocationRef

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartLocationRef
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


