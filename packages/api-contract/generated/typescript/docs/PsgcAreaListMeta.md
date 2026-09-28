
# PsgcAreaListMeta


## Properties

Name | Type
------------ | -------------
`correlationId` | string
`psgcVersion` | string
`page` | number
`hasMore` | boolean
`status` | string

## Example

```typescript
import type { PsgcAreaListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "correlationId": null,
  "psgcVersion": null,
  "page": null,
  "hasMore": null,
  "status": null,
} satisfies PsgcAreaListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PsgcAreaListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


