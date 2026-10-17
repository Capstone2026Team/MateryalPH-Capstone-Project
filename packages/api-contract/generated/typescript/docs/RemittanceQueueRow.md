
# RemittanceQueueRow


## Properties

Name | Type
------------ | -------------
`id` | string
`orderReference` | string
`vendorName` | string
`environment` | string
`taxpayerKeySuffix` | string
`scenario` | string
`components` | { [key: string]: any; }
`thresholdStatusBefore` | string
`thresholdStatusAfter` | string
`gEffectiveBeforeCentavos` | number
`gEffectiveAfterCentavos` | number
`calculationState` | string
`deductionEvidenceState` | string
`reconciliationState` | string
`reviewItemId` | string
`reason` | string
`createdAt` | Date

## Example

```typescript
import type { RemittanceQueueRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderReference": null,
  "vendorName": null,
  "environment": null,
  "taxpayerKeySuffix": null,
  "scenario": null,
  "components": null,
  "thresholdStatusBefore": null,
  "thresholdStatusAfter": null,
  "gEffectiveBeforeCentavos": null,
  "gEffectiveAfterCentavos": null,
  "calculationState": null,
  "deductionEvidenceState": null,
  "reconciliationState": null,
  "reviewItemId": null,
  "reason": null,
  "createdAt": null,
} satisfies RemittanceQueueRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RemittanceQueueRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


