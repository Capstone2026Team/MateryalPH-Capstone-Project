
# ExploreSummary


## Properties

Name | Type
------------ | -------------
`scope` | [DiscoveryScope](DiscoveryScope.md)
`countScope` | string
`scopeLabel` | string
`currentAsOf` | Date
`eligibilityVersion` | string
`counts` | [ExploreCounts](ExploreCounts.md)
`labels` | [ExploreLabels](ExploreLabels.md)
`categories` | [Array&lt;ExploreCategoryCount&gt;](ExploreCategoryCount.md)
`materialsAnalytics` | [FeatureAvailability](FeatureAvailability.md)
`dataset` | [DatasetLabel](DatasetLabel.md)

## Example

```typescript
import type { ExploreSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "scope": null,
  "countScope": null,
  "scopeLabel": null,
  "currentAsOf": null,
  "eligibilityVersion": null,
  "counts": null,
  "labels": null,
  "categories": null,
  "materialsAnalytics": null,
  "dataset": null,
} satisfies ExploreSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ExploreSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


