
# SubjectReview

Account-review facts only: no contact details, coordinates, documents or payment data.

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

## Example

```typescript
import type { SubjectReview } from '@materyalph/api-client-ts'

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
} satisfies SubjectReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SubjectReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


