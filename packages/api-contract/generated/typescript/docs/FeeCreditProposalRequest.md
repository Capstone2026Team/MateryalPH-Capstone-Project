
# FeeCreditProposalRequest


## Properties

Name | Type
------------ | -------------
`feeAssessmentId` | string
`returnedExclusiveCentavos` | number
`reason` | string

## Example

```typescript
import type { FeeCreditProposalRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "feeAssessmentId": null,
  "returnedExclusiveCentavos": null,
  "reason": null,
} satisfies FeeCreditProposalRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FeeCreditProposalRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


