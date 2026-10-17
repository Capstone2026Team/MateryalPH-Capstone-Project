
# VendorTeamPerformance


## Properties

Name | Type
------------ | -------------
`memberId` | string
`role` | string
`timezone` | string
`from` | string
`to` | string
`salesValueVisible` | boolean
`activity` | [VendorTeamPerformanceActivity](VendorTeamPerformanceActivity.md)
`sales` | [VendorTeamSalesPerformance](VendorTeamSalesPerformance.md)
`quotations` | [VendorTeamQuotationPerformance](VendorTeamQuotationPerformance.md)
`orders` | [VendorTeamConfirmationPerformance](VendorTeamConfirmationPerformance.md)
`disputes` | [VendorTeamDisputePerformance](VendorTeamDisputePerformance.md)
`inventory` | [VendorTeamInventoryPerformance](VendorTeamInventoryPerformance.md)
`fulfillment` | [VendorTeamFulfillmentPerformance](VendorTeamFulfillmentPerformance.md)
`trend` | [VendorTeamPerformanceTrend](VendorTeamPerformanceTrend.md)

## Example

```typescript
import type { VendorTeamPerformance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "memberId": null,
  "role": null,
  "timezone": null,
  "from": null,
  "to": null,
  "salesValueVisible": null,
  "activity": null,
  "sales": null,
  "quotations": null,
  "orders": null,
  "disputes": null,
  "inventory": null,
  "fulfillment": null,
  "trend": null,
} satisfies VendorTeamPerformance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamPerformance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


