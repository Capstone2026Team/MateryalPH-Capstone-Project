
# StorePerformance

Owner and Store Manager. The same formulas and thresholds as the System Workflow; no Buyer identity, order amounts or protected finance.

## Properties

Name | Type
------------ | -------------
`calculated` | boolean
`asOf` | Date
`calculatedAt` | Date
`label` | string
`scores` | [Array&lt;ScoreMetric&gt;](ScoreMetric.md)
`ratingComponents` | { [key: string]: any; }
`operations` | { [key: string]: any; }
`ohsCalculatedOn` | Date
`nextOhsRecalculationOn` | Date
`badgeMetrics` | [Array&lt;BadgeMetric&gt;](BadgeMetric.md)
`completedOrders` | { [key: string]: any; }
`history` | [Array&lt;ScoreHistoryPoint&gt;](ScoreHistoryPoint.md)
`badges` | [Array&lt;BadgeState&gt;](BadgeState.md)

## Example

```typescript
import type { StorePerformance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "calculated": null,
  "asOf": null,
  "calculatedAt": null,
  "label": null,
  "scores": null,
  "ratingComponents": null,
  "operations": null,
  "ohsCalculatedOn": null,
  "nextOhsRecalculationOn": null,
  "badgeMetrics": null,
  "completedOrders": null,
  "history": null,
  "badges": null,
} satisfies StorePerformance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as StorePerformance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


