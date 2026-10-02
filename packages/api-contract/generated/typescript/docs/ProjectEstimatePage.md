
# ProjectEstimatePage


## Properties

Name | Type
------------ | -------------
`estimate` | [ProjectCompiledEstimate](ProjectCompiledEstimate.md)
`items` | [Array&lt;ProjectCandidate&gt;](ProjectCandidate.md)
`page` | number
`hasMore` | boolean
`total` | number
`suggestedRadiusKm` | number

## Example

```typescript
import type { ProjectEstimatePage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "estimate": null,
  "items": null,
  "page": null,
  "hasMore": null,
  "total": null,
  "suggestedRadiusKm": null,
} satisfies ProjectEstimatePage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectEstimatePage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


