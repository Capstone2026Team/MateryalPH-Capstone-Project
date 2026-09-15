
# VendorIndividualRegisteredName


## Properties

Name | Type
------------ | -------------
`surname` | string
`firstName` | string
`middleName` | string
`suffix` | string
`sameAsOwner` | boolean

## Example

```typescript
import type { VendorIndividualRegisteredName } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "surname": null,
  "firstName": null,
  "middleName": null,
  "suffix": null,
  "sameAsOwner": null,
} satisfies VendorIndividualRegisteredName

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorIndividualRegisteredName
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


