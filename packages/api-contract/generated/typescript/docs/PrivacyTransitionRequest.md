
# PrivacyTransitionRequest


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`note` | string
`handlerUserId` | number
`targetDate` | Date
`verificationMethod` | string
`legalException` | string

## Example

```typescript
import type { PrivacyTransitionRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "note": null,
  "handlerUserId": null,
  "targetDate": null,
  "verificationMethod": null,
  "legalException": null,
} satisfies PrivacyTransitionRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PrivacyTransitionRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


