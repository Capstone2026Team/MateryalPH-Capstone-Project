
# VendorDashboardSeriesPoint


## Properties

Name | Type
------------ | -------------
`date` | Date
`orders` | number
`orderRequests` | number
`ordersAverage` | number
`grossSalesCentavos` | number
`netSalesCentavos` | number
`salesAverageCentavos` | number

## Example

```typescript
import type { VendorDashboardSeriesPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "orders": null,
  "orderRequests": null,
  "ordersAverage": null,
  "grossSalesCentavos": null,
  "netSalesCentavos": null,
  "salesAverageCentavos": null,
} satisfies VendorDashboardSeriesPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardSeriesPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


