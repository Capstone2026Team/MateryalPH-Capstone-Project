
# SaveVendorTax


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`attest` | boolean
`profile` | [VendorTaxData](VendorTaxData.md)

## Example

```typescript
import type { SaveVendorTax } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "attest": null,
  "profile": null,
} satisfies SaveVendorTax

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SaveVendorTax
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


