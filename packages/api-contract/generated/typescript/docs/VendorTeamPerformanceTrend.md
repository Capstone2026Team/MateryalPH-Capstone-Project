
# VendorTeamPerformanceTrend


## Properties

Name | Type
------------ | -------------
`metric` | string
`granularity` | string
`from` | string
`to` | string
`points` | [Array&lt;VendorTeamPerformanceTrendPointsInner&gt;](VendorTeamPerformanceTrendPointsInner.md)

## Example

```typescript
import type { VendorTeamPerformanceTrend } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "metric": null,
  "granularity": null,
  "from": null,
  "to": null,
  "points": null,
} satisfies VendorTeamPerformanceTrend

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamPerformanceTrend
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


