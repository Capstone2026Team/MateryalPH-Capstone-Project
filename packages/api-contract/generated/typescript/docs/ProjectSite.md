
# ProjectSite


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`discoveryOrigin` | string
`point` | { [key: string]: any; }

## Example

```typescript
import type { ProjectSite } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "discoveryOrigin": null,
  "point": null,
} satisfies ProjectSite

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectSite
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


