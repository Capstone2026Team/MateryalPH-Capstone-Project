
# AnalyticsCorrectionResult


## Properties

Name | Type
------------ | -------------
`state` | string
`snapshotDate` | Date
`runId` | string
`revision` | number
`observations` | number
`selected` | number
`vendors` | number

## Example

```typescript
import type { AnalyticsCorrectionResult } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "state": null,
  "snapshotDate": null,
  "runId": null,
  "revision": null,
  "observations": null,
  "selected": null,
  "vendors": null,
} satisfies AnalyticsCorrectionResult

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AnalyticsCorrectionResult
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


