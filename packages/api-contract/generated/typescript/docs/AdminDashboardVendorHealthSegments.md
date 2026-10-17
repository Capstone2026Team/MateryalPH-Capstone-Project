
# AdminDashboardVendorHealthSegments


## Properties

Name | Type
------------ | -------------
`state` | string
`reason` | string
`considered` | number
`features` | Array&lt;string&gt;
`k` | number
`silhouette` | number
`segments` | [Array&lt;AdminDashboardVendorHealthSegmentsSegmentsInner&gt;](AdminDashboardVendorHealthSegmentsSegmentsInner.md)

## Example

```typescript
import type { AdminDashboardVendorHealthSegments } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "state": null,
  "reason": null,
  "considered": null,
  "features": null,
  "k": null,
  "silhouette": null,
  "segments": null,
} satisfies AdminDashboardVendorHealthSegments

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardVendorHealthSegments
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


