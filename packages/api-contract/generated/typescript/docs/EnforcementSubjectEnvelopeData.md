
# EnforcementSubjectEnvelopeData


## Properties

Name | Type
------------ | -------------
`subjectType` | string
`subjectId` | string
`displayName` | string
`maskedEmail` | string
`accountStatus` | string
`storeActivationStatus` | string
`openOrders` | number
`ordersTotal` | number
`disputesTotal` | number
`disputesOpen` | number
`commerceRestrictedUntil` | Date
`sanctions` | [Array&lt;EnforcementSummary&gt;](EnforcementSummary.md)

## Example

```typescript
import type { EnforcementSubjectEnvelopeData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "subjectType": null,
  "subjectId": null,
  "displayName": null,
  "maskedEmail": null,
  "accountStatus": null,
  "storeActivationStatus": null,
  "openOrders": null,
  "ordersTotal": null,
  "disputesTotal": null,
  "disputesOpen": null,
  "commerceRestrictedUntil": null,
  "sanctions": null,
} satisfies EnforcementSubjectEnvelopeData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as EnforcementSubjectEnvelopeData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


