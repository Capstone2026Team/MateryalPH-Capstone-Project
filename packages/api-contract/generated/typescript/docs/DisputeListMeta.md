
# DisputeListMeta


## Properties

Name | Type
------------ | -------------
`page` | number
`perPage` | number
`total` | number
`hasMore` | boolean
`group` | string
`status` | string
`counts` | { [key: string]: number; }

## Example

```typescript
import type { DisputeListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "page": null,
  "perPage": null,
  "total": null,
  "hasMore": null,
  "group": null,
  "status": null,
  "counts": null,
} satisfies DisputeListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


