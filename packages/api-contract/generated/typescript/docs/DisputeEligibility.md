
# DisputeEligibility

Filing creates a Case ID and dispute state only, never a refund.

## Properties

Name | Type
------------ | -------------
`available` | boolean
`reason` | string
`activeCaseId` | string
`caseKind` | string
`postCompletionDeadline` | Date
`issueTypes` | Array&lt;string&gt;
`requestedRemedies` | Array&lt;string&gt;
`lines` | [Array&lt;DisputeAffectedLine&gt;](DisputeAffectedLine.md)
`originalPaymentMethod` | [DisputeEligibilityMethod](DisputeEligibilityMethod.md)
`refundDestinationNotice` | string
`filingCreatesRefund` | boolean

## Example

```typescript
import type { DisputeEligibility } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "available": null,
  "reason": null,
  "activeCaseId": null,
  "caseKind": null,
  "postCompletionDeadline": null,
  "issueTypes": null,
  "requestedRemedies": null,
  "lines": null,
  "originalPaymentMethod": null,
  "refundDestinationNotice": null,
  "filingCreatesRefund": null,
} satisfies DisputeEligibility

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeEligibility
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


