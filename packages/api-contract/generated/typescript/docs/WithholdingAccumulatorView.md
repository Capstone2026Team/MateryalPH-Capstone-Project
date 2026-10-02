
# WithholdingAccumulatorView


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

## Example

```typescript
import type { WithholdingAccumulatorView } from '@materyalph/api-client-ts'

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
} satisfies WithholdingAccumulatorView

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingAccumulatorView
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


