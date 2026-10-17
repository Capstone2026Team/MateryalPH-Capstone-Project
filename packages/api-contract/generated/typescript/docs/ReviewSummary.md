
# ReviewSummary

Visible Product Reviews matching the requested product and submitted-date filters before pagination. Hidden, unrevealed, disputed, removed and excluded reviews never contribute.

## Properties

Name | Type
------------ | -------------
`count` | number
`average` | number
`distribution` | [Array&lt;ReviewRatingBucket&gt;](ReviewRatingBucket.md)

## Example

```typescript
import type { ReviewSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "count": null,
  "average": null,
  "distribution": null,
} satisfies ReviewSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReviewSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


