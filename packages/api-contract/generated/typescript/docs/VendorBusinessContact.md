
# VendorBusinessContact


## Properties

Name | Type
------------ | -------------
`fullName` | string
`position` | string
`email` | string
`telephoneE164` | string
`authorizedRepresentative` | boolean
`isPrimary` | boolean
`verificationCommunication` | boolean
`accountAdministrationCommunication` | boolean
`generalAdministrationCommunication` | boolean

## Example

```typescript
import type { VendorBusinessContact } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fullName": null,
  "position": null,
  "email": null,
  "telephoneE164": null,
  "authorizedRepresentative": null,
  "isPrimary": null,
  "verificationCommunication": null,
  "accountAdministrationCommunication": null,
  "generalAdministrationCommunication": null,
} satisfies VendorBusinessContact

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorBusinessContact
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


