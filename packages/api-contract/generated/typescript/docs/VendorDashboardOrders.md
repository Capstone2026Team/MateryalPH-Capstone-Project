
# VendorDashboardOrders

Store-wide order measures (orders.confirm). Peso fields are null unless the caller holds finance.view (Owner).

## Properties

Name | Type
------------ | -------------
`kpis` | [VendorDashboardOrdersKpis](VendorDashboardOrdersKpis.md)
`series` | [Array&lt;VendorDashboardSeriesPoint&gt;](VendorDashboardSeriesPoint.md)
`forecast` | [VendorDashboardOrdersForecast](VendorDashboardOrdersForecast.md)
`pipeline` | [Array&lt;VendorDashboardOrdersPipelineInner&gt;](VendorDashboardOrdersPipelineInner.md)
`incoming` | [Array&lt;VendorDashboardOrdersIncomingInner&gt;](VendorDashboardOrdersIncomingInner.md)
`funnel` | [Array&lt;VendorDashboardOrdersFunnelInner&gt;](VendorDashboardOrdersFunnelInner.md)
`mix` | [VendorDashboardOrdersMix](VendorDashboardOrdersMix.md)
`products` | [VendorDashboardOrdersProducts](VendorDashboardOrdersProducts.md)
`unusualDays` | [VendorDashboardOrdersUnusualDays](VendorDashboardOrdersUnusualDays.md)

## Example

```typescript
import type { VendorDashboardOrders } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "kpis": null,
  "series": null,
  "forecast": null,
  "pipeline": null,
  "incoming": null,
  "funnel": null,
  "mix": null,
  "products": null,
  "unusualDays": null,
} satisfies VendorDashboardOrders

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrders
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


