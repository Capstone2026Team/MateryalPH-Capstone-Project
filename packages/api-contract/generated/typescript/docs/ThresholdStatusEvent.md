
# ThresholdStatusEvent


## Properties

Name | Type
------------ | -------------
`fromStatus` | string
`toStatus` | string
`reasonCode` | string
`gBeforeCentavos` | number
`gAfterCentavos` | number
`actorType` | string
`occurredAt` | Date

## Example

```typescript
import type { ThresholdStatusEvent } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fromStatus": null,
  "toStatus": null,
  "reasonCode": null,
  "gBeforeCentavos": null,
  "gAfterCentavos": null,
  "actorType": null,
  "occurredAt": null,
} satisfies ThresholdStatusEvent

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ThresholdStatusEvent
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


