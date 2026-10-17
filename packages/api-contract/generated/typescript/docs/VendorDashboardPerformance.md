
# VendorDashboardPerformance

scores.view_store (Owner and Store Manager). The Score service values; no second formula.

## Properties

Name | Type
------------ | -------------
`calculated` | boolean
`asOf` | Date
`label` | string
`scores` | [Array&lt;ScoreMetric&gt;](ScoreMetric.md)
`badgeMetrics` | [Array&lt;BadgeMetric&gt;](BadgeMetric.md)
`operations` | { [key: string]: any; }
`history` | [Array&lt;ScoreHistoryPoint&gt;](ScoreHistoryPoint.md)
`classification` | [DashboardClassification](DashboardClassification.md)
`badges` | [Array&lt;BadgeState&gt;](BadgeState.md)

## Example

```typescript
import type { VendorDashboardPerformance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "calculated": null,
  "asOf": null,
  "label": null,
  "scores": null,
  "badgeMetrics": null,
  "operations": null,
  "history": null,
  "classification": null,
  "badges": null,
} satisfies VendorDashboardPerformance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardPerformance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


