
# PrivacyRequestEvent


## Properties

Name | Type
------------ | -------------
`event` | string
`fromState` | string
`toState` | string
`note` | string
`actor` | string
`actorRole` | string
`correlationId` | string
`occurredAt` | Date

## Example

```typescript
import type { PrivacyRequestEvent } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "event": null,
  "fromState": null,
  "toState": null,
  "note": null,
  "actor": null,
  "actorRole": null,
  "correlationId": null,
  "occurredAt": null,
} satisfies PrivacyRequestEvent

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PrivacyRequestEvent
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


