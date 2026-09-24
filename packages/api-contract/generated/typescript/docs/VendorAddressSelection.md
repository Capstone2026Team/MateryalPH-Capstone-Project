
# VendorAddressSelection


## Properties

Name | Type
------------ | -------------
`pinToken` | string
`provinceCode` | string
`cityCode` | string
`psgcCode` | string
`street` | string
`unit` | string
`postalCode` | string

## Example

```typescript
import type { VendorAddressSelection } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "pinToken": null,
  "provinceCode": null,
  "cityCode": null,
  "psgcCode": null,
  "street": null,
  "unit": null,
  "postalCode": null,
} satisfies VendorAddressSelection

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorAddressSelection
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


