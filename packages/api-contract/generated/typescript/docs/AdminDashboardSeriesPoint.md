
# AdminDashboardSeriesPoint

Suppressed days are gaps (null), never zero.

## Properties

Name | Type
------------ | -------------
`date` | Date
`grossGmvCentavos` | number
`netGmvCentavos` | number
`orderVolume` | number
`suppressed` | boolean
`grossAverageCentavos` | number
`volumeAverage` | number

## Example

```typescript
import type { AdminDashboardSeriesPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "grossGmvCentavos": null,
  "netGmvCentavos": null,
  "orderVolume": null,
  "suppressed": null,
  "grossAverageCentavos": null,
  "volumeAverage": null,
} satisfies AdminDashboardSeriesPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardSeriesPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


