
# EnforcementDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`subjectType` | string
`subjectId` | string
`subjectName` | string
`action` | string
`actionLabel` | string
`state` | string
`source` | string
`caseId` | string
`caseReference` | string
`reason` | string
`durationDays` | number
`continuationPlan` | string
`issuedRole` | string
`appliedRole` | string
`createdAt` | Date
`appliedAt` | Date
`expiresAt` | Date
`liftedAt` | Date
`liftReason` | string
`lockVersion` | number
`scope` | string
`restorationCondition` | string
`continuationNote` | string
`priorSubjectState` | { [key: string]: any; }
`subjectReview` | [SubjectReview](SubjectReview.md)
`events` | [Array&lt;EnforcementEvent&gt;](EnforcementEvent.md)
`allowedActions` | Array&lt;string&gt;

## Example

```typescript
import type { EnforcementDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "subjectType": null,
  "subjectId": null,
  "subjectName": null,
  "action": null,
  "actionLabel": null,
  "state": null,
  "source": null,
  "caseId": null,
  "caseReference": null,
  "reason": null,
  "durationDays": null,
  "continuationPlan": null,
  "issuedRole": null,
  "appliedRole": null,
  "createdAt": null,
  "appliedAt": null,
  "expiresAt": null,
  "liftedAt": null,
  "liftReason": null,
  "lockVersion": null,
  "scope": null,
  "restorationCondition": null,
  "continuationNote": null,
  "priorSubjectState": null,
  "subjectReview": null,
  "events": null,
  "allowedActions": null,
} satisfies EnforcementDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as EnforcementDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


