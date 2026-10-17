
# AdminScoreDetail


## Properties

Name | Type
------------ | -------------
`vendorId` | string
`storeName` | string
`calculated` | boolean
`asOf` | Date
`label` | string
`scores` | [Array&lt;ScoreMetric&gt;](ScoreMetric.md)
`operations` | { [key: string]: any; }
`badgeMetrics` | [Array&lt;BadgeMetric&gt;](BadgeMetric.md)
`badges` | [Array&lt;BadgeState&gt;](BadgeState.md)
`badgeHistory` | Array&lt;{ [key: string]: any; }&gt;
`suppressions` | Array&lt;{ [key: string]: any; }&gt;
`exclusions` | Array&lt;{ [key: string]: any; }&gt;
`sourceEvents` | { [key: string]: any; }
`history` | [Array&lt;ScoreHistoryPoint&gt;](ScoreHistoryPoint.md)
`canInvestigate` | boolean

## Example

```typescript
import type { AdminScoreDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "storeName": null,
  "calculated": null,
  "asOf": null,
  "label": null,
  "scores": null,
  "operations": null,
  "badgeMetrics": null,
  "badges": null,
  "badgeHistory": null,
  "suppressions": null,
  "exclusions": null,
  "sourceEvents": null,
  "history": null,
  "canInvestigate": null,
} satisfies AdminScoreDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminScoreDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


