
# OrderListMeta


## Properties

Name | Type
------------ | -------------
`group` | string
`counts` | { [key: string]: number; }
`page` | number
`perPage` | number
`total` | number
`hasMore` | boolean
`currentAsOf` | Date

## Example

```typescript
import type { OrderListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "group": null,
  "counts": null,
  "page": null,
  "perPage": null,
  "total": null,
  "hasMore": null,
  "currentAsOf": null,
} satisfies OrderListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


