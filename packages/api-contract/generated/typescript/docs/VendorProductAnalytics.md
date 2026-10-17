
# VendorProductAnalytics


## Properties

Name | Type
------------ | -------------
`generatedAt` | Date
`period` | [ProductAnalyticsPeriod](ProductAnalyticsPeriod.md)
`access` | [VendorProductAnalyticsAccess](VendorProductAnalyticsAccess.md)
`definitions` | { [key: string]: string; }
`tracking` | [ProductAnalyticsTracking](ProductAnalyticsTracking.md)
`kpis` | [VendorProductAnalyticsKpis](VendorProductAnalyticsKpis.md)
`series` | [Array&lt;ProductAnalyticsSeriesPoint&gt;](ProductAnalyticsSeriesPoint.md)
`forecast` | [VendorProductAnalyticsForecast](VendorProductAnalyticsForecast.md)
`topSelling` | [Array&lt;ProductAnalyticsRow&gt;](ProductAnalyticsRow.md)
`topPerforming` | [Array&lt;ProductAnalyticsRow&gt;](ProductAnalyticsRow.md)
`mostViewed` | [Array&lt;ProductAnalyticsRow&gt;](ProductAnalyticsRow.md)
`categories` | [Array&lt;VendorProductAnalyticsCategoriesInner&gt;](VendorProductAnalyticsCategoriesInner.md)
`segments` | [ProductAnalyticsSegments](ProductAnalyticsSegments.md)
`basketRules` | [VendorProductAnalyticsBasketRules](VendorProductAnalyticsBasketRules.md)
`suggestions` | [Array&lt;ProductAnalyticsSuggestion&gt;](ProductAnalyticsSuggestion.md)
`products` | [VendorProductAnalyticsProducts](VendorProductAnalyticsProducts.md)

## Example

```typescript
import type { VendorProductAnalytics } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "generatedAt": null,
  "period": null,
  "access": null,
  "definitions": null,
  "tracking": null,
  "kpis": null,
  "series": null,
  "forecast": null,
  "topSelling": null,
  "topPerforming": null,
  "mostViewed": null,
  "categories": null,
  "segments": null,
  "basketRules": null,
  "suggestions": null,
  "products": null,
} satisfies VendorProductAnalytics

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorProductAnalytics
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


