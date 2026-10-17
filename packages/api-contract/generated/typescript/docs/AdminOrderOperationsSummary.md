
# AdminOrderOperationsSummary


## Properties

Name | Type
------------ | -------------
`refundsTotal` | number
`refundsFailed` | number
`refundsPending` | number
`reimbursementsTotal` | number
`reimbursementsPending` | number
`cancellationRequestsOpen` | number
`nfrEvents30Days` | number

## Example

```typescript
import type { AdminOrderOperationsSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "refundsTotal": null,
  "refundsFailed": null,
  "refundsPending": null,
  "reimbursementsTotal": null,
  "reimbursementsPending": null,
  "cancellationRequestsOpen": null,
  "nfrEvents30Days": null,
} satisfies AdminOrderOperationsSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminOrderOperationsSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


