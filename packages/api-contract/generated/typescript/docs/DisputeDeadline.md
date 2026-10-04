
# DisputeDeadline

An exact stored instant for a countdown plus its Asia/Manila date and time label.

## Properties

Name | Type
------------ | -------------
`kind` | string
`at` | Date
`responsibleParty` | string
`label` | string

## Example

```typescript
import type { DisputeDeadline } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "kind": null,
  "at": null,
  "responsibleParty": null,
  "label": null,
} satisfies DisputeDeadline

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeDeadline
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


