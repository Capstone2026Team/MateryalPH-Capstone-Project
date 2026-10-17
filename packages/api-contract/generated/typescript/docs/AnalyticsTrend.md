
# AnalyticsTrend

Endpoints are exact dates; a missing or insufficient endpoint returns a null percentage with its reason — never zero.

## Properties

Name | Type
------------ | -------------
`changePercent` | string
`direction` | string
`reason` | string
`compositionChanged` | boolean
`startDate` | Date
`endDate` | Date
`label` | string
`compositionNote` | string

## Example

```typescript
import type { AnalyticsTrend } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "changePercent": null,
  "direction": null,
  "reason": null,
  "compositionChanged": null,
  "startDate": null,
  "endDate": null,
  "label": null,
  "compositionNote": null,
} satisfies AnalyticsTrend

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AnalyticsTrend
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


