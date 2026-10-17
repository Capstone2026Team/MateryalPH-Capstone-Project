
# AnalyticsRun


## Properties

Name | Type
------------ | -------------
`id` | string
`snapshotDate` | Date
`revision` | number
`state` | string
`errorCode` | string
`observedAt` | Date
`publishedAt` | Date
`observations` | number
`selected` | number
`vendors` | number
`delayed` | boolean
`reviewerReason` | string

## Example

```typescript
import type { AnalyticsRun } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "snapshotDate": null,
  "revision": null,
  "state": null,
  "errorCode": null,
  "observedAt": null,
  "publishedAt": null,
  "observations": null,
  "selected": null,
  "vendors": null,
  "delayed": null,
  "reviewerReason": null,
} satisfies AnalyticsRun

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AnalyticsRun
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


