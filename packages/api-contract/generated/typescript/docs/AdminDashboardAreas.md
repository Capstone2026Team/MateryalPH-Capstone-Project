
# AdminDashboardAreas

K-Means area segments, DBSCAN unusual areas and recruitment signals over child areas without a suppressed cell.

## Properties

Name | Type
------------ | -------------
`childrenLabel` | string
`considered` | number
`excludedSuppressed` | number
`features` | Array&lt;string&gt;
`state` | string
`reason` | string
`k` | number
`silhouette` | number
`segments` | [Array&lt;AdminDashboardAreaSegment&gt;](AdminDashboardAreaSegment.md)
`unusual` | [Array&lt;AdminDashboardAreasUnusualInner&gt;](AdminDashboardAreasUnusualInner.md)
`recruitment` | [Array&lt;AdminDashboardAreasRecruitmentInner&gt;](AdminDashboardAreasRecruitmentInner.md)
`points` | [Array&lt;AdminDashboardAreasPointsInner&gt;](AdminDashboardAreasPointsInner.md)

## Example

```typescript
import type { AdminDashboardAreas } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "childrenLabel": null,
  "considered": null,
  "excludedSuppressed": null,
  "features": null,
  "state": null,
  "reason": null,
  "k": null,
  "silhouette": null,
  "segments": null,
  "unusual": null,
  "recruitment": null,
  "points": null,
} satisfies AdminDashboardAreas

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardAreas
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


