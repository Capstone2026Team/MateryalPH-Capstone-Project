
# VendorProductAnalyticsDetail


## Properties

Name | Type
------------ | -------------
`generatedAt` | Date
`period` | [ProductAnalyticsPeriod](ProductAnalyticsPeriod.md)
`access` | [VendorProductAnalyticsAccess](VendorProductAnalyticsAccess.md)
`definitions` | { [key: string]: string; }
`tracking` | [ProductAnalyticsTracking](ProductAnalyticsTracking.md)
`product` | [ProductAnalyticsRow](ProductAnalyticsRow.md)
`kpis` | [VendorProductAnalyticsDetailKpis](VendorProductAnalyticsDetailKpis.md)
`series` | [Array&lt;ProductAnalyticsSeriesPoint&gt;](ProductAnalyticsSeriesPoint.md)
`forecast` | [VendorProductAnalyticsForecast](VendorProductAnalyticsForecast.md)
`unusualDays` | [VendorProductAnalyticsDetailUnusualDays](VendorProductAnalyticsDetailUnusualDays.md)
`basketRules` | [VendorProductAnalyticsBasketRules](VendorProductAnalyticsBasketRules.md)
`suggestions` | [Array&lt;ProductAnalyticsSuggestion&gt;](ProductAnalyticsSuggestion.md)

## Example

```typescript
import type { VendorProductAnalyticsDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "generatedAt": null,
  "period": null,
  "access": null,
  "definitions": null,
  "tracking": null,
  "product": null,
  "kpis": null,
  "series": null,
  "forecast": null,
  "unusualDays": null,
  "basketRules": null,
  "suggestions": null,
} satisfies VendorProductAnalyticsDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorProductAnalyticsDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


