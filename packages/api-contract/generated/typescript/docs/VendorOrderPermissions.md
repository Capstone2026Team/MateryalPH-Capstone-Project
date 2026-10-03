
# VendorOrderPermissions

Display hints only; every action is authorized again on the server.

## Properties

Name | Type
------------ | -------------
`canConfirm` | boolean
`canRevise` | boolean
`canSetNrpc` | boolean
`canConfirmDelivery` | boolean
`canDecline` | boolean
`canViewInventory` | boolean
`canRecordPhysicalPayment` | boolean
`canApproveOnlineBalance` | boolean
`canRecordMilestone` | boolean
`canAssignFulfillment` | boolean
`canCancel` | boolean
`canFinalizeCancellation` | boolean
`canReportVehicleIssue` | boolean
`canRetryRefund` | boolean
`canRespondProblem` | boolean

## Example

```typescript
import type { VendorOrderPermissions } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "canConfirm": null,
  "canRevise": null,
  "canSetNrpc": null,
  "canConfirmDelivery": null,
  "canDecline": null,
  "canViewInventory": null,
  "canRecordPhysicalPayment": null,
  "canApproveOnlineBalance": null,
  "canRecordMilestone": null,
  "canAssignFulfillment": null,
  "canCancel": null,
  "canFinalizeCancellation": null,
  "canReportVehicleIssue": null,
  "canRetryRefund": null,
  "canRespondProblem": null,
} satisfies VendorOrderPermissions

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOrderPermissions
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


