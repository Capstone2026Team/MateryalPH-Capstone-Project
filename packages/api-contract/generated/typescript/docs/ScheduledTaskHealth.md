
# ScheduledTaskHealth


## Properties

Name | Type
------------ | -------------
`task` | string
`status` | string
`lastOutcome` | string
`lastStartedAt` | Date
`durationMs` | number
`expectedWithinMinutes` | number

## Example

```typescript
import type { ScheduledTaskHealth } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "task": null,
  "status": null,
  "lastOutcome": null,
  "lastStartedAt": null,
  "durationMs": null,
  "expectedWithinMinutes": null,
} satisfies ScheduledTaskHealth

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ScheduledTaskHealth
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


