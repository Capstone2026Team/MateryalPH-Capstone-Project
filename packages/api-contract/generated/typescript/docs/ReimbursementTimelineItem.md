
# ReimbursementTimelineItem


## Properties

Name | Type
------------ | -------------
`id` | string
`state` | string
`amountCentavos` | number
`method` | string
`reimbursedAt` | Date
`buyerAcknowledgedAt` | Date
`hasEvidence` | boolean
`evidencePath` | string
`confirmedByReview` | boolean
`message` | string

## Example

```typescript
import type { ReimbursementTimelineItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "state": null,
  "amountCentavos": null,
  "method": null,
  "reimbursedAt": null,
  "buyerAcknowledgedAt": null,
  "hasEvidence": null,
  "evidencePath": null,
  "confirmedByReview": null,
  "message": null,
} satisfies ReimbursementTimelineItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReimbursementTimelineItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


