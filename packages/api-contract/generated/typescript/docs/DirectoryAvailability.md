
# DirectoryAvailability


## Properties

Name | Type
------------ | -------------
`status` | string
`asOf` | Date
`attribution` | [ProviderAttribution](ProviderAttribution.md)
`coverageNote` | string

## Example

```typescript
import type { DirectoryAvailability } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "asOf": null,
  "attribution": null,
  "coverageNote": null,
} satisfies DirectoryAvailability

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryAvailability
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


