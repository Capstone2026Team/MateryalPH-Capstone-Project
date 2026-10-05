
# OwnReview


## Properties

Name | Type
------------ | -------------
`id` | string
`type` | string
`ratings` | [ReviewRatings](ReviewRatings.md)
`comment` | string
`displayName` | string
`submittedAt` | Date
`editableUntil` | Date
`editableUntilLabel` | string
`canEdit` | boolean
`correctionRequested` | boolean
`correctionDueAt` | Date
`visibility` | string
`revision` | number
`lockVersion` | number
`media` | [Array&lt;ReviewMediaLink&gt;](ReviewMediaLink.md)

## Example

```typescript
import type { OwnReview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "type": null,
  "ratings": null,
  "comment": null,
  "displayName": null,
  "submittedAt": null,
  "editableUntil": null,
  "editableUntilLabel": null,
  "canEdit": null,
  "correctionRequested": null,
  "correctionDueAt": null,
  "visibility": null,
  "revision": null,
  "lockVersion": null,
  "media": null,
} satisfies OwnReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OwnReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


