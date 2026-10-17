
# TaxPackageInput


## Properties

Name | Type
------------ | -------------
`form` | string
`periodStart` | string
`withholdingEntity` | string
`vendorOrganizationId` | string

## Example

```typescript
import type { TaxPackageInput } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "form": null,
  "periodStart": null,
  "withholdingEntity": null,
  "vendorOrganizationId": null,
} satisfies TaxPackageInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as TaxPackageInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


