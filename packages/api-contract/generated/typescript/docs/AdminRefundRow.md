
# AdminRefundRow


## Properties

Name | Type
------------ | -------------
`id` | string
`targetType` | string
`trigger` | string
`state` | string
`displayState` | string
`amountCentavos` | number
`attemptNumber` | number
`failureCode` | string
`evidenceOrigin` | string
`orderId` | string
`orderReference` | string
`statementReference` | string
`vendorName` | string
`requestedAt` | Date
`completedAt` | Date
`canRetry` | boolean

## Example

```typescript
import type { AdminRefundRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "targetType": null,
  "trigger": null,
  "state": null,
  "displayState": null,
  "amountCentavos": null,
  "attemptNumber": null,
  "failureCode": null,
  "evidenceOrigin": null,
  "orderId": null,
  "orderReference": null,
  "statementReference": null,
  "vendorName": null,
  "requestedAt": null,
  "completedAt": null,
  "canRetry": null,
} satisfies AdminRefundRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminRefundRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


