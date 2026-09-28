
# StockConfirmationSchedule

Stale-stock schedule. Exact UTC instants; clients render them in Asia/Manila beside the countdown.

## Properties

Name | Type
------------ | -------------
`state` | string
`confirmedAt` | Date
`firstReminderAt` | Date
`finalReminderAt` | Date
`hideAt` | Date
`daysSinceConfirmation` | number

## Example

```typescript
import type { StockConfirmationSchedule } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "state": null,
  "confirmedAt": null,
  "firstReminderAt": null,
  "finalReminderAt": null,
  "hideAt": null,
  "daysSinceConfirmation": null,
} satisfies StockConfirmationSchedule

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as StockConfirmationSchedule
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


