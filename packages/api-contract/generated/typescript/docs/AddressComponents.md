
# AddressComponents


## Properties

Name | Type
------------ | -------------
`street` | string
`barangay` | string
`cityMunicipality` | string
`province` | string
`postalCode` | string

## Example

```typescript
import type { AddressComponents } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "street": null,
  "barangay": null,
  "cityMunicipality": null,
  "province": null,
  "postalCode": null,
} satisfies AddressComponents

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AddressComponents
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


