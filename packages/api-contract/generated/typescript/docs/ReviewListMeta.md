
# ReviewListMeta


## Properties

Name | Type
------------ | -------------
`page` | number
`perPage` | number
`total` | number
`type` | string
`summary` | { [key: string]: any; }
`scores` | [PublicScores](PublicScores.md)
`correlationId` | string

## Example

```typescript
import type { ReviewListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "page": null,
  "perPage": null,
  "total": null,
  "type": null,
  "summary": null,
  "scores": null,
  "correlationId": null,
} satisfies ReviewListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReviewListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


