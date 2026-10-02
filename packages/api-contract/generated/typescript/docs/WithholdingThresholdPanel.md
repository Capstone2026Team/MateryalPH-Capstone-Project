
# WithholdingThresholdPanel

FIN-04A panel. Status never uses EXEMPT/SUBJECT_TO_WITHHOLDING; remaining allowance is floored at zero; every figure is DEMO.

## Properties

Name | Type
------------ | -------------
`demo` | boolean
`taxableYear` | number
`yearStartAt` | Date
`yearEndAt` | Date
`thresholdCentavos` | number
`cumulativeGrossCentavos` | number
`remainingAllowanceCentavos` | number
`localGrossCentavos` | number
`externalDeclaredCentavos` | number
`externalOverlapCentavos` | number
`externalOverlapState` | string
`percentOfThreshold` | number
`advisory` | boolean
`status` | string
`statusLabel` | string
`statusIcon` | string
`reasonCode` | string
`crossedAt` | Date
`crossedAtManila` | string
`priorYearTotalCentavos` | number
`finalForYearNotice` | string
`events` | [Array&lt;ThresholdStatusEvent&gt;](ThresholdStatusEvent.md)

## Example

```typescript
import type { WithholdingThresholdPanel } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "demo": null,
  "taxableYear": null,
  "yearStartAt": null,
  "yearEndAt": null,
  "thresholdCentavos": null,
  "cumulativeGrossCentavos": null,
  "remainingAllowanceCentavos": null,
  "localGrossCentavos": null,
  "externalDeclaredCentavos": null,
  "externalOverlapCentavos": null,
  "externalOverlapState": null,
  "percentOfThreshold": null,
  "advisory": null,
  "status": null,
  "statusLabel": null,
  "statusIcon": null,
  "reasonCode": null,
  "crossedAt": null,
  "crossedAtManila": null,
  "priorYearTotalCentavos": null,
  "finalForYearNotice": null,
  "events": null,
} satisfies WithholdingThresholdPanel

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingThresholdPanel
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


