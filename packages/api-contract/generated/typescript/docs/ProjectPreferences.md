
# ProjectPreferences


## Properties

Name | Type
------------ | -------------
`weights` | { [key: string]: any; }
`defaultWeights` | { [key: string]: any; }
`personalized` | boolean
`version` | number
`defaultsVersion` | number
`algorithmVersion` | string

## Example

```typescript
import type { ProjectPreferences } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "weights": null,
  "defaultWeights": null,
  "personalized": null,
  "version": null,
  "defaultsVersion": null,
  "algorithmVersion": null,
} satisfies ProjectPreferences

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectPreferences
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


