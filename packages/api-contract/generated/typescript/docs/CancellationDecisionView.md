
# CancellationDecisionView


## Properties

Name | Type
------------ | -------------
`cause` | string
`decidedBy` | string
`decisionCode` | string
`reasonCode` | string
`reason` | string
`nrpcRetainedCentavos` | number
`refundTotalCentavos` | number
`cashReimbursementCentavos` | number
`releasedUnpaidCentavos` | number
`orderStateBefore` | string
`decidedAt` | Date
`nrpcEvidenceOnFile` | boolean
`nrpcEvidencePath` | string

## Example

```typescript
import type { CancellationDecisionView } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "cause": null,
  "decidedBy": null,
  "decisionCode": null,
  "reasonCode": null,
  "reason": null,
  "nrpcRetainedCentavos": null,
  "refundTotalCentavos": null,
  "cashReimbursementCentavos": null,
  "releasedUnpaidCentavos": null,
  "orderStateBefore": null,
  "decidedAt": null,
  "nrpcEvidenceOnFile": null,
  "nrpcEvidencePath": null,
} satisfies CancellationDecisionView

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CancellationDecisionView
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


