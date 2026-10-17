
# BudgetOverrideRecord


## Properties

Name | Type
------------ | -------------
`id` | string
`project` | string
`workPackage` | string
`orderReference` | string
`priorBudgetCentavos` | number
`orderAmountCentavos` | number
`overageCentavos` | number
`reason` | string
`actor` | string
`recordedAt` | Date

## Example

```typescript
import type { BudgetOverrideRecord } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "project": null,
  "workPackage": null,
  "orderReference": null,
  "priorBudgetCentavos": null,
  "orderAmountCentavos": null,
  "overageCentavos": null,
  "reason": null,
  "actor": null,
  "recordedAt": null,
} satisfies BudgetOverrideRecord

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BudgetOverrideRecord
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


