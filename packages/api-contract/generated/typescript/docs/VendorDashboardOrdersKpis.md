
# VendorDashboardOrdersKpis


## Properties

Name | Type
------------ | -------------
`orderVolume` | [DashboardDelta](DashboardDelta.md)
`grossSalesCentavos` | [DashboardDelta](DashboardDelta.md)
`netSalesCentavos` | [DashboardDelta](DashboardDelta.md)
`averageOrderValueCentavos` | [VendorDashboardOrdersKpisAverageOrderValueCentavos](VendorDashboardOrdersKpisAverageOrderValueCentavos.md)
`fulfillmentRate` | [DashboardRate](DashboardRate.md)
`cancellationRate` | [DashboardRate](DashboardRate.md)
`disputeRate` | [DashboardRate](DashboardRate.md)
`responseTime` | [DashboardResponseTime](DashboardResponseTime.md)

## Example

```typescript
import type { VendorDashboardOrdersKpis } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderVolume": null,
  "grossSalesCentavos": null,
  "netSalesCentavos": null,
  "averageOrderValueCentavos": null,
  "fulfillmentRate": null,
  "cancellationRate": null,
  "disputeRate": null,
  "responseTime": null,
} satisfies VendorDashboardOrdersKpis

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersKpis
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


