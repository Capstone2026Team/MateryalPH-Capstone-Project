
# VendorVerificationDraftLegalIdentity


## Properties

Name | Type
------------ | -------------
`sameAsOwner` | boolean
`surname` | string
`firstName` | string
`middleName` | string
`suffix` | string
`companyRegisteredName` | string
`idType` | string
`idNumber` | string

## Example

```typescript
import type { VendorVerificationDraftLegalIdentity } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "sameAsOwner": null,
  "surname": null,
  "firstName": null,
  "middleName": null,
  "suffix": null,
  "companyRegisteredName": null,
  "idType": null,
  "idNumber": null,
} satisfies VendorVerificationDraftLegalIdentity

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorVerificationDraftLegalIdentity
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


