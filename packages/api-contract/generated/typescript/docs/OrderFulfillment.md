
# OrderFulfillment

Server-derived milestone stepper. Step completion comes only from recorded milestones; there is no live GPS or vehicle position.

## Properties

Name | Type
------------ | -------------
`method` | string
`state` | string
`expectedDate` | string
`late` | boolean
`steps` | [Array&lt;FulfillmentStep&gt;](FulfillmentStep.md)
`proof` | [FulfillmentProof](FulfillmentProof.md)
`trackingNotice` | string
`trips` | [Array&lt;FulfillmentTrip&gt;](FulfillmentTrip.md)
`acceptedArrangement` | [FulfillmentArrangement](FulfillmentArrangement.md)
`receipt` | [FulfillmentReceipt](FulfillmentReceipt.md)
`issue` | [FulfillmentIssue](FulfillmentIssue.md)
`assignment` | [FulfillmentAssignment](FulfillmentAssignment.md)
`vehicleIssues` | [Array&lt;FulfillmentVehicleIssue&gt;](FulfillmentVehicleIssue.md)
`thread` | [FulfillmentThreadRef](FulfillmentThreadRef.md)
`nextAction` | string

## Example

```typescript
import type { OrderFulfillment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "method": null,
  "state": null,
  "expectedDate": null,
  "late": null,
  "steps": null,
  "proof": null,
  "trackingNotice": null,
  "trips": null,
  "acceptedArrangement": null,
  "receipt": null,
  "issue": null,
  "assignment": null,
  "vehicleIssues": null,
  "thread": null,
  "nextAction": null,
} satisfies OrderFulfillment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderFulfillment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


