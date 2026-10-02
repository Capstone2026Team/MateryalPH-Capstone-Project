
# WithholdingAccumulatorDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`vendor` | { [key: string]: any; }
`environment` | string
`taxpayerKeySuffix` | string
`taxableYear` | number
`thresholdCentavos` | number
`gAccumulatedCentavos` | number
`gExternalDeclaredCentavos` | number
`gExternalOverlapCentavos` | number
`gEffectiveCentavos` | number
`remainingAllowanceCentavos` | number
`externalOverlapState` | string
`status` | string
`statusLabel` | string
`reasonCode` | string
`breached` | boolean
`crossedAt` | Date
`priorYearTotalCentavos` | number
`lockVersion` | number
`demo` | boolean
`taxProfile` | { [key: string]: any; }
`events` | Array&lt;{ [key: string]: any; }&gt;
`assessments` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { WithholdingAccumulatorDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "vendor": null,
  "environment": null,
  "taxpayerKeySuffix": null,
  "taxableYear": null,
  "thresholdCentavos": null,
  "gAccumulatedCentavos": null,
  "gExternalDeclaredCentavos": null,
  "gExternalOverlapCentavos": null,
  "gEffectiveCentavos": null,
  "remainingAllowanceCentavos": null,
  "externalOverlapState": null,
  "status": null,
  "statusLabel": null,
  "reasonCode": null,
  "breached": null,
  "crossedAt": null,
  "priorYearTotalCentavos": null,
  "lockVersion": null,
  "demo": null,
  "taxProfile": null,
  "events": null,
  "assessments": null,
} satisfies WithholdingAccumulatorDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingAccumulatorDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


