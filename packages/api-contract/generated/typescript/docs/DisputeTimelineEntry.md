
# DisputeTimelineEntry

One append-only, chronologically numbered event with its actor, role, exact time and evidence.

## Properties

Name | Type
------------ | -------------
`id` | string
`sequence` | number
`type` | string
`at` | Date
`actor` | [DisputeTimelineActor](DisputeTimelineActor.md)
`body` | string
`details` | { [key: string]: any; }
`evidence` | [Array&lt;DisputeEvidence&gt;](DisputeEvidence.md)

## Example

```typescript
import type { DisputeTimelineEntry } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "sequence": null,
  "type": null,
  "at": null,
  "actor": null,
  "body": null,
  "details": null,
  "evidence": null,
} satisfies DisputeTimelineEntry

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeTimelineEntry
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


