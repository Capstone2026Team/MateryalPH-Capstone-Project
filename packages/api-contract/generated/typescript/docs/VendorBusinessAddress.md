
# VendorBusinessAddress


## Properties

Name | Type
------------ | -------------
`street` | string
`barangay` | string
`city` | string
`province` | string
`postalCode` | string
`latitude` | number
`longitude` | number

## Example

```typescript
import type { VendorBusinessAddress } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "street": null,
  "barangay": null,
  "city": null,
  "province": null,
  "postalCode": null,
  "latitude": null,
  "longitude": null,
} satisfies VendorBusinessAddress

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorBusinessAddress
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


