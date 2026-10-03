
# WorkPackageLineInput


## Properties

Name | Type
------------ | -------------
`materialId` | string
`name` | string
`unitId` | string
`quantity` | string
`specifications` | { [key: string]: string; }
`preferredBrand` | string

## Example

```typescript
import type { WorkPackageLineInput } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "materialId": null,
  "name": null,
  "unitId": null,
  "quantity": null,
  "specifications": null,
  "preferredBrand": null,
} satisfies WorkPackageLineInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageLineInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


