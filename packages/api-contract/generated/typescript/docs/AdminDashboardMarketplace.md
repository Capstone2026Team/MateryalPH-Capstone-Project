
# AdminDashboardMarketplace

analytics.view_aggregates. Built from the disclosure-controlled geographic read model.

## Properties

Name | Type
------------ | -------------
`scope` | [GeoScope](GeoScope.md)
`dataset` | [GeoDataset](GeoDataset.md)
`period` | [AdminDashboardMarketplacePeriod](AdminDashboardMarketplacePeriod.md)
`disclosure` | [AdminDashboardMarketplaceDisclosure](AdminDashboardMarketplaceDisclosure.md)
`kpis` | [GeoKpis](GeoKpis.md)
`series` | [Array&lt;AdminDashboardSeriesPoint&gt;](AdminDashboardSeriesPoint.md)
`forecast` | [AdminDashboardMarketplaceForecast](AdminDashboardMarketplaceForecast.md)
`activity` | [Array&lt;AdminDashboardActivityPoint&gt;](AdminDashboardActivityPoint.md)
`areas` | [AdminDashboardAreas](AdminDashboardAreas.md)
`categories` | [AdminDashboardCategories](AdminDashboardCategories.md)

## Example

```typescript
import type { AdminDashboardMarketplace } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "scope": null,
  "dataset": null,
  "period": null,
  "disclosure": null,
  "kpis": null,
  "series": null,
  "forecast": null,
  "activity": null,
  "areas": null,
  "categories": null,
} satisfies AdminDashboardMarketplace

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardMarketplace
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


