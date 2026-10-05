
# PublicReview

Privacy-safe public review: first name and last initial or Verified Buyer; no reviewer id or contact.

## Properties

Name | Type
------------ | -------------
`id` | string
`type` | string
`ratings` | [ReviewRatings](ReviewRatings.md)
`comment` | string
`displayName` | string
`verifiedPurchase` | boolean
`submittedAt` | Date
`edited` | boolean
`variantLabel` | string
`media` | [Array&lt;ReviewMediaLink&gt;](ReviewMediaLink.md)

## Example

```typescript
import type { PublicReview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "type": null,
  "ratings": null,
  "comment": null,
  "displayName": null,
  "verifiedPurchase": null,
  "submittedAt": null,
  "edited": null,
  "variantLabel": null,
  "media": null,
} satisfies PublicReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PublicReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


