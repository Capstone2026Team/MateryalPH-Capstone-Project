
# OrderTimelineEvent


## Properties

Name | Type
------------ | -------------
`family` | string
`fromState` | string
`toState` | string
`source` | string
`actorRole` | string
`reasonCode` | string
`snapshotVersion` | number
`at` | Date

## Example

```typescript
import type { OrderTimelineEvent } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "family": null,
  "fromState": null,
  "toState": null,
  "source": null,
  "actorRole": null,
  "reasonCode": null,
  "snapshotVersion": null,
  "at": null,
} satisfies OrderTimelineEvent

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderTimelineEvent
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


