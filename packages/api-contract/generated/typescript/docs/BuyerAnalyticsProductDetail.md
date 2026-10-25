
# BuyerAnalyticsProductDetail


## Properties

Name | Type
------------ | -------------
`audience` | string
`scope` | { [key: string]: any; }
`sourceKind` | string
`dataset` | [DatasetLabel](DatasetLabel.md)
`window` | [AnalyticsWindow](AnalyticsWindow.md)
`currentAsOf` | Date
`snapshot` | [AnalyticsSnapshotRef](AnalyticsSnapshotRef.md)
`updateSchedule` | string
`explanation` | string
`product` | [BuyerAnalyticsProductDetailProduct](BuyerAnalyticsProductDetailProduct.md)
`featured` | [BuyerAnalyticsFeaturedVariant](BuyerAnalyticsFeaturedVariant.md)
`variants` | [Array&lt;BuyerAnalyticsProductVariant&gt;](BuyerAnalyticsProductVariant.md)

## Example

```typescript
import type { BuyerAnalyticsProductDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "audience": null,
  "scope": null,
  "sourceKind": null,
  "dataset": null,
  "window": null,
  "currentAsOf": null,
  "snapshot": null,
  "updateSchedule": null,
  "explanation": null,
  "product": null,
  "featured": null,
  "variants": null,
} satisfies BuyerAnalyticsProductDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerAnalyticsProductDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


