
# AccountProfileUpdate

Updates the authenticated account owner\'s profile with optimistic concurrency. mobile_e164 is optional and Buyer-only; when supplied it must be a non-empty E.164 contact number. Omitting it preserves the current number. Phone changes do not change sign-in or require SMS verification.

## Properties

Name | Type
------------ | -------------
`fullName` | string
`lockVersion` | number
`buyerType` | string
`companyName` | string
`mobileE164` | string

## Example

```typescript
import type { AccountProfileUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fullName": null,
  "lockVersion": null,
  "buyerType": null,
  "companyName": null,
  "mobileE164": null,
} satisfies AccountProfileUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AccountProfileUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


