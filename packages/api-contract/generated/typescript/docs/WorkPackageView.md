
# WorkPackageView


## Properties

Name | Type
------------ | -------------
`id` | string
`projectId` | string
`projectStatus` | string
`name` | string
`status` | string
`budgetCentavos` | number
`lockVersion` | number
`currentVersionId` | string
`selectedVendorId` | string
`orderId` | string
`version` | [WorkPackageVersion](WorkPackageVersion.md)
`versions` | [WorkPackageVersionPage](WorkPackageVersionPage.md)
`budget` | [ProjectBudget](ProjectBudget.md)
`missingLines` | Array&lt;{ [key: string]: any; }&gt;
`document` | { [key: string]: any; }

## Example

```typescript
import type { WorkPackageView } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "projectId": null,
  "projectStatus": null,
  "name": null,
  "status": null,
  "budgetCentavos": null,
  "lockVersion": null,
  "currentVersionId": null,
  "selectedVendorId": null,
  "orderId": null,
  "version": null,
  "versions": null,
  "budget": null,
  "missingLines": null,
  "document": null,
} satisfies WorkPackageView

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageView
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


