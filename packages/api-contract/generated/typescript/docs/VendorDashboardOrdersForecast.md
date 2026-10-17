
# VendorDashboardOrdersForecast


## Properties

Name | Type
------------ | -------------
`horizonDays` | number
`orders` | [DashboardForecast](DashboardForecast.md)
`sales` | [DashboardForecast](DashboardForecast.md)

## Example

```typescript
import type { VendorDashboardOrdersForecast } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "horizonDays": null,
  "orders": null,
  "sales": null,
} satisfies VendorDashboardOrdersForecast

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersForecast
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


