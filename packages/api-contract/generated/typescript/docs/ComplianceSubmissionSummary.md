
# ComplianceSubmissionSummary


## Properties

Name | Type
------------ | -------------
`id` | string
`version` | number
`path` | [CompliancePath](CompliancePath.md)
`status` | string
`markingType` | string
`submittedAt` | string
`decidedAt` | string
`latestReview` | [ComplianceReviewSummary](ComplianceReviewSummary.md)

## Example

```typescript
import type { ComplianceSubmissionSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "version": null,
  "path": null,
  "status": null,
  "markingType": null,
  "submittedAt": null,
  "decidedAt": null,
  "latestReview": null,
} satisfies ComplianceSubmissionSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComplianceSubmissionSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


