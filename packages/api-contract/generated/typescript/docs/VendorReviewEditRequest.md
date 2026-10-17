
# VendorReviewEditRequest


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`inquirySeriousness` | number
`communicationQuality` | number
`paymentReliability` | number
`comment` | string

## Example

```typescript
import type { VendorReviewEditRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "inquirySeriousness": null,
  "communicationQuality": null,
  "paymentReliability": null,
  "comment": null,
} satisfies VendorReviewEditRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorReviewEditRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


