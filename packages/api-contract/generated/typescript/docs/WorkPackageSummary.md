
# WorkPackageSummary


## Properties

Name | Type
------------ | -------------
`selectedArrangementId` | string
`vendorOrders` | Array&lt;{ [key: string]: any; }&gt;
`id` | string
`projectId` | string
`name` | string
`status` | string
`budgetCentavos` | number
`lockVersion` | number
`currentVersionId` | string
`selectedVendorId` | string
`orderId` | string
`procurementCandidateId` | string

## Example

```typescript
import type { WorkPackageSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "selectedArrangementId": null,
  "vendorOrders": null,
  "id": null,
  "projectId": null,
  "name": null,
  "status": null,
  "budgetCentavos": null,
  "lockVersion": null,
  "currentVersionId": null,
  "selectedVendorId": null,
  "orderId": null,
  "procurementCandidateId": null,
} satisfies WorkPackageSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


