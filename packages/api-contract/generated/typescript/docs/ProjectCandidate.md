
# ProjectCandidate


## Properties

Name | Type
------------ | -------------
`id` | string
`estimateId` | string
`vendorId` | string
`storeName` | string
`rank` | number
`latitude` | number
`longitude` | number
`scoreLabel` | string
`vps` | string
`fms` | { [key: string]: any; }
`complete` | boolean
`fulfillmentPercent` | string
`missingLines` | Array&lt;{ [key: string]: any; }&gt;
`lines` | Array&lt;{ [key: string]: any; }&gt;
`materialsCentavos` | number
`includedVatCentavos` | number
`deliveryCentavos` | number
`processingFeeCentavos` | number
`processingFeeStatus` | string
`projectedTotalCentavos` | number
`budgetLabel` | string
`distanceMeters` | number
`distanceBasis` | string
`etaSeconds` | number
`fulfillmentMethod` | string
`paymentMethod` | string
`delivery` | { [key: string]: any; }
`destination` | { [key: string]: any; }
`expiresAt` | string
`stale` | boolean
`label` | string
`currentQuotationState` | string

## Example

```typescript
import type { ProjectCandidate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "estimateId": null,
  "vendorId": null,
  "storeName": null,
  "rank": null,
  "latitude": null,
  "longitude": null,
  "scoreLabel": null,
  "vps": null,
  "fms": null,
  "complete": null,
  "fulfillmentPercent": null,
  "missingLines": null,
  "lines": null,
  "materialsCentavos": null,
  "includedVatCentavos": null,
  "deliveryCentavos": null,
  "processingFeeCentavos": null,
  "processingFeeStatus": null,
  "projectedTotalCentavos": null,
  "budgetLabel": null,
  "distanceMeters": null,
  "distanceBasis": null,
  "etaSeconds": null,
  "fulfillmentMethod": null,
  "paymentMethod": null,
  "delivery": null,
  "destination": null,
  "expiresAt": null,
  "stale": null,
  "label": null,
  "currentQuotationState": null,
} satisfies ProjectCandidate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectCandidate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


