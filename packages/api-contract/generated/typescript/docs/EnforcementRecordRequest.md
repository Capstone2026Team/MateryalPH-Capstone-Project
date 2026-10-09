
# EnforcementRecordRequest

A Warning is effective at once; other sanctions are applied at once. Permanent Ban needs enforcement.ban and recent re-authentication.

## Properties

Name | Type
------------ | -------------
`subjectType` | string
`subjectId` | string
`action` | string
`reason` | string
`scope` | string
`durationDays` | number
`restorationCondition` | string
`continuationPlan` | string
`continuationNote` | string

## Example

```typescript
import type { EnforcementRecordRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "subjectType": null,
  "subjectId": null,
  "action": null,
  "reason": null,
  "scope": null,
  "durationDays": null,
  "restorationCondition": null,
  "continuationPlan": null,
  "continuationNote": null,
} satisfies EnforcementRecordRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as EnforcementRecordRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


