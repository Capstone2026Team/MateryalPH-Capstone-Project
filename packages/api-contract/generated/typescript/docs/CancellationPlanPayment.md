
# CancellationPlanPayment


## Properties

Name | Type
------------ | -------------
`paymentId` | string
`purpose` | string
`channelCode` | string
`channelName` | string
`capturedCentavos` | number
`priorAllocatedCentavos` | number
`retainedCentavos` | number
`refundCentavos` | number
`principalCentavos` | number
`processingFeeCentavos` | number
`cappedByPriorRefunds` | boolean
`allocation` | { [key: string]: any; }

## Example

```typescript
import type { CancellationPlanPayment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "paymentId": null,
  "purpose": null,
  "channelCode": null,
  "channelName": null,
  "capturedCentavos": null,
  "priorAllocatedCentavos": null,
  "retainedCentavos": null,
  "refundCentavos": null,
  "principalCentavos": null,
  "processingFeeCentavos": null,
  "cappedByPriorRefunds": null,
  "allocation": null,
} satisfies CancellationPlanPayment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CancellationPlanPayment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


