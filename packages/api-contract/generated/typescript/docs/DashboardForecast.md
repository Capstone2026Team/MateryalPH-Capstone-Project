
# DashboardForecast

Least-squares trend plus a weekday pattern with a 95% prediction band. A planning estimate only; INSUFFICIENT_DATA below seven active days. Money forecasts are integer centavos.

## Properties

Name | Type
------------ | -------------
`state` | string
`observedDays` | number
`direction` | string
`changePercent` | number
`rSquared` | number
`weekdayStrength` | number
`expectedTotal` | number
`points` | [Array&lt;DashboardForecastPoint&gt;](DashboardForecastPoint.md)
`anomalies` | [Array&lt;DashboardAnomaly&gt;](DashboardAnomaly.md)

## Example

```typescript
import type { DashboardForecast } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "state": null,
  "observedDays": null,
  "direction": null,
  "changePercent": null,
  "rSquared": null,
  "weekdayStrength": null,
  "expectedTotal": null,
  "points": null,
  "anomalies": null,
} satisfies DashboardForecast

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DashboardForecast
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


