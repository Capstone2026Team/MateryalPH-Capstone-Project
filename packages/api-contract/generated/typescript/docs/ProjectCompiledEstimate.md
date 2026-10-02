
# ProjectCompiledEstimate


## Properties

Name | Type
------------ | -------------
`id` | string
`versionId` | string
`createdAt` | string
`expiresAt` | string
`state` | string
`context` | { [key: string]: any; }

## Example

```typescript
import type { ProjectCompiledEstimate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "versionId": null,
  "createdAt": null,
  "expiresAt": null,
  "state": null,
  "context": null,
} satisfies ProjectCompiledEstimate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectCompiledEstimate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


