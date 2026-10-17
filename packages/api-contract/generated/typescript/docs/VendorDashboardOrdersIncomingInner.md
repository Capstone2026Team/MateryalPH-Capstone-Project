
# VendorDashboardOrdersIncomingInner


## Properties

Name | Type
------------ | -------------
`orderId` | string
`reference` | string
`procurementType` | string
`fulfillmentMethod` | string
`lineCount` | number
`totalCentavos` | number
`submittedAt` | Date
`dueAt` | Date

## Example

```typescript
import type { VendorDashboardOrdersIncomingInner } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderId": null,
  "reference": null,
  "procurementType": null,
  "fulfillmentMethod": null,
  "lineCount": null,
  "totalCentavos": null,
  "submittedAt": null,
  "dueAt": null,
} satisfies VendorDashboardOrdersIncomingInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersIncomingInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


