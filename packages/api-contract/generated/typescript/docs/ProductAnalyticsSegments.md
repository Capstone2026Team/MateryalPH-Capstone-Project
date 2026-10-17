
# ProductAnalyticsSegments

K-Means groups over product views, conversion % and orders; names compare each centre with the store average.

## Properties

Name | Type
------------ | -------------
`state` | string
`reason` | string
`k` | number
`silhouette` | number
`features` | Array&lt;string&gt;
`segments` | [Array&lt;ProductAnalyticsSegmentsSegmentsInner&gt;](ProductAnalyticsSegmentsSegmentsInner.md)
`points` | [Array&lt;ProductAnalyticsSegmentsPointsInner&gt;](ProductAnalyticsSegmentsPointsInner.md)
`meanConversionPercent` | number

## Example

```typescript
import type { ProductAnalyticsSegments } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "state": null,
  "reason": null,
  "k": null,
  "silhouette": null,
  "features": null,
  "segments": null,
  "points": null,
  "meanConversionPercent": null,
} satisfies ProductAnalyticsSegments

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductAnalyticsSegments
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


