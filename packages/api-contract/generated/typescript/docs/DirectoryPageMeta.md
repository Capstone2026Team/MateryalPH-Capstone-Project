
# DirectoryPageMeta


## Properties

Name | Type
------------ | -------------
`page` | number
`perPage` | number
`total` | number
`lastPage` | number
`statusCounts` | { [key: string]: number; }
`canModerate` | boolean
`direction` | string
`type` | string

## Example

```typescript
import type { DirectoryPageMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "page": null,
  "perPage": null,
  "total": null,
  "lastPage": null,
  "statusCounts": null,
  "canModerate": null,
  "direction": null,
  "type": null,
} satisfies DirectoryPageMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryPageMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


