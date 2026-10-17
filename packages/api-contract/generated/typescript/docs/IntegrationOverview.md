
# IntegrationOverview

Configuration presence and masked labels only; credentials, payloads, recipients and exception messages never appear.

## Properties

Name | Type
------------ | -------------
`generatedAt` | Date
`environment` | { [key: string]: any; }
`integrations` | [Array&lt;IntegrationStatus&gt;](IntegrationStatus.md)
`queues` | { [key: string]: any; }
`scheduledTasks` | [Array&lt;ScheduledTaskHealth&gt;](ScheduledTaskHealth.md)
`analytics` | { [key: string]: any; }
`canRetry` | boolean

## Example

```typescript
import type { IntegrationOverview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "generatedAt": null,
  "environment": null,
  "integrations": null,
  "queues": null,
  "scheduledTasks": null,
  "analytics": null,
  "canRetry": null,
} satisfies IntegrationOverview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as IntegrationOverview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


