
# DisputeDecision

Immutable decision versions. An appeal decision supersedes without erasing the original.

## Properties

Name | Type
------------ | -------------
`id` | string
`version` | number
`kind` | string
`outcome` | string
`appealResult` | string
`awardedCentavos` | number
`reason` | string
`evidenceLimitation` | string
`enforceable` | boolean
`decidedAt` | Date
`appealDueAt` | Date
`supersedesDecisionId` | string
`deciderRole` | string
`deciderName` | string
`sanctions` | { [key: string]: any; }
`current` | boolean

## Example

```typescript
import type { DisputeDecision } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "version": null,
  "kind": null,
  "outcome": null,
  "appealResult": null,
  "awardedCentavos": null,
  "reason": null,
  "evidenceLimitation": null,
  "enforceable": null,
  "decidedAt": null,
  "appealDueAt": null,
  "supersedesDecisionId": null,
  "deciderRole": null,
  "deciderName": null,
  "sanctions": null,
  "current": null,
} satisfies DisputeDecision

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeDecision
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


