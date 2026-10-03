
# GooglePlaceReview


## Properties

Name | Type
------------ | -------------
`author` | [GoogleContentAuthor](GoogleContentAuthor.md)
`rating` | number
`text` | string
`relativeTime` | string
`googleMapsUri` | string

## Example

```typescript
import type { GooglePlaceReview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "author": null,
  "rating": null,
  "text": null,
  "relativeTime": null,
  "googleMapsUri": null,
} satisfies GooglePlaceReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GooglePlaceReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


