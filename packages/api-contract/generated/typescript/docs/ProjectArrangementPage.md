
# ProjectArrangementPage


## Properties

Name | Type
------------ | -------------
`sort` | string
`estimate` | [ProjectCompiledEstimate](ProjectCompiledEstimate.md)
`items` | [Array&lt;ProjectArrangement&gt;](ProjectArrangement.md)
`page` | number
`hasMore` | boolean
`total` | number
`unfilteredTotal` | number

## Example

```typescript
import type { ProjectArrangementPage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "sort": null,
  "estimate": null,
  "items": null,
  "page": null,
  "hasMore": null,
  "total": null,
  "unfilteredTotal": null,
} satisfies ProjectArrangementPage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectArrangementPage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


