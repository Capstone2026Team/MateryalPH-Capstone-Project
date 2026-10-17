
# PrivacyRequestCreateRequest


## Properties

Name | Type
------------ | -------------
`subjectEmail` | string
`requestType` | string
`intakeChannel` | string
`receivedOn` | Date
`scope` | string
`note` | string

## Example

```typescript
import type { PrivacyRequestCreateRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "subjectEmail": null,
  "requestType": null,
  "intakeChannel": null,
  "receivedOn": null,
  "scope": null,
  "note": null,
} satisfies PrivacyRequestCreateRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PrivacyRequestCreateRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


