
# DirectoryReview


## Properties

Name | Type
------------ | -------------
`id` | string
`type` | string
`ratings` | [{ [key: string]: DirectoryReviewRatingsValue; }](DirectoryReviewRatingsValue.md)
`comment` | string
`authorName` | string
`orderReference` | string
`storeName` | string
`productName` | string
`moderationState` | string
`visibility` | string
`submittedAt` | Date

## Example

```typescript
import type { DirectoryReview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "type": null,
  "ratings": null,
  "comment": null,
  "authorName": null,
  "orderReference": null,
  "storeName": null,
  "productName": null,
  "moderationState": null,
  "visibility": null,
  "submittedAt": null,
} satisfies DirectoryReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


