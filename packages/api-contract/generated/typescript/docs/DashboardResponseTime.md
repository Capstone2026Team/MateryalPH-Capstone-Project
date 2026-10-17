
# DashboardResponseTime


## Properties

Name | Type
------------ | -------------
`meanSeconds` | number
`medianSeconds` | number
`p90Seconds` | number
`answered` | number
`unanswered` | number

## Example

```typescript
import type { DashboardResponseTime } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "meanSeconds": null,
  "medianSeconds": null,
  "p90Seconds": null,
  "answered": null,
  "unanswered": null,
} satisfies DashboardResponseTime

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DashboardResponseTime
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


