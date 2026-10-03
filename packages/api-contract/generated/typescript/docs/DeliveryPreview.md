
# DeliveryPreview


## Properties

Name | Type
------------ | -------------
`status` | string
`issues` | [Array&lt;CartIssue&gt;](CartIssue.md)
`endpoint` | string
`route` | [DeliveryRoute](DeliveryRoute.md)
`straightLineMeters` | number
`coverageKm` | number
`estimate` | [DeliveryEstimate](DeliveryEstimate.md)
`manualReviewReasons` | Array&lt;string&gt;
`confirmedOffer` | { [key: string]: any; }
`calculationVersion` | string
`notice` | string

## Example

```typescript
import type { DeliveryPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "issues": null,
  "endpoint": null,
  "route": null,
  "straightLineMeters": null,
  "coverageKm": null,
  "estimate": null,
  "manualReviewReasons": null,
  "confirmedOffer": null,
  "calculationVersion": null,
  "notice": null,
} satisfies DeliveryPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


