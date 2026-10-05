
# ReviewLine


## Properties

Name | Type
------------ | -------------
`orderLineId` | string
`listingId` | string
`displayName` | string
`variantLabel` | string
`review` | [OwnReview](OwnReview.md)
`canReview` | boolean

## Example

```typescript
import type { ReviewLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderLineId": null,
  "listingId": null,
  "displayName": null,
  "variantLabel": null,
  "review": null,
  "canReview": null,
} satisfies ReviewLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReviewLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


