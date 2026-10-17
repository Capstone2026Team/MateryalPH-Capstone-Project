
# VendorDashboardDisputes

portal.disputes.

## Properties

Name | Type
------------ | -------------
`open` | number
`awaitingResponse` | number
`nextResponseDueAt` | Date
`filedInPeriod` | number
`series` | [Array&lt;VendorDashboardDisputesSeriesInner&gt;](VendorDashboardDisputesSeriesInner.md)
`issueTypes` | [Array&lt;DashboardCount&gt;](DashboardCount.md)
`statuses` | [Array&lt;DashboardCount&gt;](DashboardCount.md)
`fulfillmentIssues` | number
`validatedReturns` | number

## Example

```typescript
import type { VendorDashboardDisputes } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "open": null,
  "awaitingResponse": null,
  "nextResponseDueAt": null,
  "filedInPeriod": null,
  "series": null,
  "issueTypes": null,
  "statuses": null,
  "fulfillmentIssues": null,
  "validatedReturns": null,
} satisfies VendorDashboardDisputes

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardDisputes
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


