
# DisputeClarification


## Properties

Name | Type
------------ | -------------
`id` | string
`requestedParty` | string
`question` | string
`dueAt` | Date
`state` | string
`response` | string
`respondedAt` | Date
`canAnswer` | boolean

## Example

```typescript
import type { DisputeClarification } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "requestedParty": null,
  "question": null,
  "dueAt": null,
  "state": null,
  "response": null,
  "respondedAt": null,
  "canAnswer": null,
} satisfies DisputeClarification

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeClarification
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


