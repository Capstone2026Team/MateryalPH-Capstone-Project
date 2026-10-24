
# AdminDisputeAppealDecisionRequest

Reviewed by an Admin who did not make the appealed decision, unless that Admin is a Super Admin (409 CONFLICT_OF_INTEREST otherwise). Final and executed at once.

## Properties

Name | Type
------------ | -------------
`result` | string
`outcome` | string
`reason` | string
`amountCentavos` | number
`affectedLineIds` | Array&lt;string&gt;
`conflictCheckConfirmed` | boolean
`sanctions` | [Array&lt;DisputeSanctionInput&gt;](DisputeSanctionInput.md)
`metricEvent` | string
`lockVersion` | number

## Example

```typescript
import type { AdminDisputeAppealDecisionRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "result": null,
  "outcome": null,
  "reason": null,
  "amountCentavos": null,
  "affectedLineIds": null,
  "conflictCheckConfirmed": null,
  "sanctions": null,
  "metricEvent": null,
  "lockVersion": null,
} satisfies AdminDisputeAppealDecisionRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDisputeAppealDecisionRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


