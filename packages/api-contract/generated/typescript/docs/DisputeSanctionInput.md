
# DisputeSanctionInput

A warning takes effect when the decision is final; restriction, suspension and ban are recorded and referred to User Management Staff.

## Properties

Name | Type
------------ | -------------
`subject` | string
`action` | string
`reason` | string
`scope` | string
`durationDays` | number
`restorationCondition` | string

## Example

```typescript
import type { DisputeSanctionInput } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "subject": null,
  "action": null,
  "reason": null,
  "scope": null,
  "durationDays": null,
  "restorationCondition": null,
} satisfies DisputeSanctionInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeSanctionInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


