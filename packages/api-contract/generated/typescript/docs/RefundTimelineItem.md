
# RefundTimelineItem

One timeline per original online payment. INITIATED is never success; PROCESSED requires a verified provider event or reconciliation.

## Properties

Name | Type
------------ | -------------
`id` | string
`trigger` | string
`state` | string
`displayState` | string
`amountCentavos` | number
`principalCentavos` | number
`processingFeeCentavos` | number
`paymentPurpose` | string
`originalMethod` | string
`attemptNumber` | number
`requestedAt` | Date
`completedAt` | Date
`failureCode` | string
`evidenceOrigin` | string
`canRetry` | boolean
`arrivalNote` | string
`message` | string

## Example

```typescript
import type { RefundTimelineItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "trigger": null,
  "state": null,
  "displayState": null,
  "amountCentavos": null,
  "principalCentavos": null,
  "processingFeeCentavos": null,
  "paymentPurpose": null,
  "originalMethod": null,
  "attemptNumber": null,
  "requestedAt": null,
  "completedAt": null,
  "failureCode": null,
  "evidenceOrigin": null,
  "canRetry": null,
  "arrivalNote": null,
  "message": null,
} satisfies RefundTimelineItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RefundTimelineItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


