
# VendorProductAnalyticsSummariesItemsInner


## Properties

Name | Type
------------ | -------------
`listingId` | string
`views` | number
`previousViews` | number
`viewsChangePercent` | number
`viewers` | number
`orders` | number
`conversion` | [DashboardRate](DashboardRate.md)
`dailyViews` | Array&lt;number&gt;

## Example

```typescript
import type { VendorProductAnalyticsSummariesItemsInner } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "views": null,
  "previousViews": null,
  "viewsChangePercent": null,
  "viewers": null,
  "orders": null,
  "conversion": null,
  "dailyViews": null,
} satisfies VendorProductAnalyticsSummariesItemsInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorProductAnalyticsSummariesItemsInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


