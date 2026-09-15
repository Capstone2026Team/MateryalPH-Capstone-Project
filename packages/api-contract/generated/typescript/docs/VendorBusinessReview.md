
# VendorBusinessReview


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`decision` | string
`reason` | string
`regulatoryEvidenceRequired` | boolean
`regulatoryReviewBasis` | string

## Example

```typescript
import type { VendorBusinessReview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "decision": null,
  "reason": null,
  "regulatoryEvidenceRequired": null,
  "regulatoryReviewBasis": null,
} satisfies VendorBusinessReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorBusinessReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


