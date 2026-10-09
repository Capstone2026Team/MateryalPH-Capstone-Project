
# GeoDashboard

Aggregate facts only: PSGC codes and counts, never coordinates, Buyer identities or private evidence. Suppressed person-derived values are null with the reason; they stay counted in the parent total.

## Properties

Name | Type
------------ | -------------
`scope` | [GeoScope](GeoScope.md)
`dataset` | [GeoDataset](GeoDataset.md)
`period` | [GeoDashboardPeriod](GeoDashboardPeriod.md)
`filters` | { [key: string]: any; }
`filterApplicability` | [Array&lt;GeoFilterApplicability&gt;](GeoFilterApplicability.md)
`disclosure` | [GeoDashboardDisclosure](GeoDashboardDisclosure.md)
`kpis` | [GeoKpis](GeoKpis.md)
`trends` | [Array&lt;GeoTrendPoint&gt;](GeoTrendPoint.md)
`activityTrend` | [Array&lt;GeoActivityPoint&gt;](GeoActivityPoint.md)
`children` | [Array&lt;GeoChild&gt;](GeoChild.md)
`unresolved` | [GeoDashboardUnresolved](GeoDashboardUnresolved.md)
`definitions` | { [key: string]: string; }

## Example

```typescript
import type { GeoDashboard } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "scope": null,
  "dataset": null,
  "period": null,
  "filters": null,
  "filterApplicability": null,
  "disclosure": null,
  "kpis": null,
  "trends": null,
  "activityTrend": null,
  "children": null,
  "unresolved": null,
  "definitions": null,
} satisfies GeoDashboard

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoDashboard
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


