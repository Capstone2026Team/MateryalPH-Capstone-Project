
# AdminReimbursementRow


## Properties

Name | Type
------------ | -------------
`id` | string
`orderReference` | string
`vendorName` | string
`state` | string
`amountCentavos` | number
`method` | string
`hasEvidence` | boolean
`reimbursedAt` | Date
`buyerAcknowledgedAt` | Date
`confirmedByReview` | boolean
`canDecide` | boolean

## Example

```typescript
import type { AdminReimbursementRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderReference": null,
  "vendorName": null,
  "state": null,
  "amountCentavos": null,
  "method": null,
  "hasEvidence": null,
  "reimbursedAt": null,
  "buyerAcknowledgedAt": null,
  "confirmedByReview": null,
  "canDecide": null,
} satisfies AdminReimbursementRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminReimbursementRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


