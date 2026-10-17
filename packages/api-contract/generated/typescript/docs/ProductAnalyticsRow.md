
# ProductAnalyticsRow

One store product with its period measures. conversion_lower_bound is the Wilson 95% lower bound of converted ÷ viewers. value_centavos is null unless the caller holds finance.view (Owner).

## Properties

Name | Type
------------ | -------------
`listingId` | string
`name` | string
`sku` | string
`category` | string
`status` | string
`stockStatus` | string
`views` | number
`previousViews` | number
`viewsChangePercent` | number
`viewers` | number
`converted` | number
`conversion` | [DashboardRate](DashboardRate.md)
`conversionLowerBound` | number
`orders` | number
`previousOrders` | number
`buyers` | number
`valueCentavos` | number
`segment` | string
`rankViews` | number
`rankOrders` | number

## Example

```typescript
import type { ProductAnalyticsRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "name": null,
  "sku": null,
  "category": null,
  "status": null,
  "stockStatus": null,
  "views": null,
  "previousViews": null,
  "viewsChangePercent": null,
  "viewers": null,
  "converted": null,
  "conversion": null,
  "conversionLowerBound": null,
  "orders": null,
  "previousOrders": null,
  "buyers": null,
  "valueCentavos": null,
  "segment": null,
  "rankViews": null,
  "rankOrders": null,
} satisfies ProductAnalyticsRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductAnalyticsRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


