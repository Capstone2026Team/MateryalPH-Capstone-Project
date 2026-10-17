
# VendorDashboardInsights


## Properties

Name | Type
------------ | -------------
`generatedAt` | Date
`period` | [VendorDashboardInsightsPeriod](VendorDashboardInsightsPeriod.md)
`access` | [VendorDashboardInsightsAccess](VendorDashboardInsightsAccess.md)
`definitions` | { [key: string]: string; }
`orders` | [VendorDashboardOrders](VendorDashboardOrders.md)
`performance` | [VendorDashboardPerformance](VendorDashboardPerformance.md)
`stock` | [VendorDashboardStock](VendorDashboardStock.md)
`disputes` | [VendorDashboardDisputes](VendorDashboardDisputes.md)
`actions` | [Array&lt;DashboardAction&gt;](DashboardAction.md)
`traffic` | [VendorDashboardInsightsTraffic](VendorDashboardInsightsTraffic.md)

## Example

```typescript
import type { VendorDashboardInsights } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "generatedAt": null,
  "period": null,
  "access": null,
  "definitions": null,
  "orders": null,
  "performance": null,
  "stock": null,
  "disputes": null,
  "actions": null,
  "traffic": null,
} satisfies VendorDashboardInsights

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardInsights
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


