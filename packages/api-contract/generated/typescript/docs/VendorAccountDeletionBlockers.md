
# VendorAccountDeletionBlockers


## Properties

Name | Type
------------ | -------------
`activeOrders` | number
`pendingPayments` | number
`unresolvedDisputes` | number
`pendingRefunds` | number
`uncollectedPayments` | number
`outstandingStatements` | number
`unbilledCommissions` | number
`financeReviews` | number

## Example

```typescript
import type { VendorAccountDeletionBlockers } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "activeOrders": null,
  "pendingPayments": null,
  "unresolvedDisputes": null,
  "pendingRefunds": null,
  "uncollectedPayments": null,
  "outstandingStatements": null,
  "unbilledCommissions": null,
  "financeReviews": null,
} satisfies VendorAccountDeletionBlockers

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorAccountDeletionBlockers
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


