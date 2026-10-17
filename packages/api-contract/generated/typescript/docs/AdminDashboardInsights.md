
# AdminDashboardInsights


## Properties

Name | Type
------------ | -------------
`generatedAt` | Date
`access` | [AdminDashboardInsightsAccess](AdminDashboardInsightsAccess.md)
`definitions` | { [key: string]: string; }
`marketplace` | [AdminDashboardMarketplace](AdminDashboardMarketplace.md)
`marketplaceUnavailableReason` | string
`vendorHealth` | [AdminDashboardVendorHealth](AdminDashboardVendorHealth.md)

## Example

```typescript
import type { AdminDashboardInsights } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "generatedAt": null,
  "access": null,
  "definitions": null,
  "marketplace": null,
  "marketplaceUnavailableReason": null,
  "vendorHealth": null,
} satisfies AdminDashboardInsights

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardInsights
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


