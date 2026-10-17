
# DisputeSummary


## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`orderId` | string
`orderReference` | string
`status` | string
`caseKind` | string
`issueType` | string
`requestedRemedy` | string
`requestedAmountCentavos` | number
`filedByParty` | string
`responsibleParty` | string
`nextDeadline` | [DisputeDeadline](DisputeDeadline.md)
`refundState` | string
`remedyState` | string
`appealAvailable` | boolean
`vendorName` | string
`buyerName` | string
`assignedToAdmin` | boolean
`decisions` | number
`filedAt` | Date
`updatedAt` | Date

## Example

```typescript
import type { DisputeSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "orderId": null,
  "orderReference": null,
  "status": null,
  "caseKind": null,
  "issueType": null,
  "requestedRemedy": null,
  "requestedAmountCentavos": null,
  "filedByParty": null,
  "responsibleParty": null,
  "nextDeadline": null,
  "refundState": null,
  "remedyState": null,
  "appealAvailable": null,
  "vendorName": null,
  "buyerName": null,
  "assignedToAdmin": null,
  "decisions": null,
  "filedAt": null,
  "updatedAt": null,
} satisfies DisputeSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


