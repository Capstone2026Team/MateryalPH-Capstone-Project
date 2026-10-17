
# VendorDashboardInsightsAccess


## Properties

Name | Type
------------ | -------------
`orders` | boolean
`salesValue` | boolean
`performance` | boolean
`stock` | boolean
`disputes` | boolean
`assignedFulfillment` | boolean

## Example

```typescript
import type { VendorDashboardInsightsAccess } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orders": null,
  "salesValue": null,
  "performance": null,
  "stock": null,
  "disputes": null,
  "assignedFulfillment": null,
} satisfies VendorDashboardInsightsAccess

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardInsightsAccess
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


