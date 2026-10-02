
# PhysicalPaymentRecord


## Properties

Name | Type
------------ | -------------
`id` | string
`kind` | string
`method` | string
`amountCentavos` | number
`remainingCentavos` | number
`state` | string
`recordedAt` | Date
`recordedRole` | string
`hasEvidence` | boolean
`source` | string
`buyerAcknowledgedAt` | Date

## Example

```typescript
import type { PhysicalPaymentRecord } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "kind": null,
  "method": null,
  "amountCentavos": null,
  "remainingCentavos": null,
  "state": null,
  "recordedAt": null,
  "recordedRole": null,
  "hasEvidence": null,
  "source": null,
  "buyerAcknowledgedAt": null,
} satisfies PhysicalPaymentRecord

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PhysicalPaymentRecord
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


