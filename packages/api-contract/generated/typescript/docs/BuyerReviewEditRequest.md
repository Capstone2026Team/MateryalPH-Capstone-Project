
# BuyerReviewEditRequest


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`serviceQuality` | number
`speedRating` | number
`rating` | number
`comment` | string

## Example

```typescript
import type { BuyerReviewEditRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "serviceQuality": null,
  "speedRating": null,
  "rating": null,
  "comment": null,
} satisfies BuyerReviewEditRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerReviewEditRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


