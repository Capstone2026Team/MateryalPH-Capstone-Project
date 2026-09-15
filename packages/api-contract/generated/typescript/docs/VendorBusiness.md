
# VendorBusiness


## Properties

Name | Type
------------ | -------------
`reviewReason` | string
`lockVersion` | number
`draft` | [VendorBusinessDraft](VendorBusinessDraft.md)
`status` | string
`storeEmailVerification` | [VendorStoreEmailVerification](VendorStoreEmailVerification.md)

## Example

```typescript
import type { VendorBusiness } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "reviewReason": null,
  "lockVersion": null,
  "draft": null,
  "status": null,
  "storeEmailVerification": null,
} satisfies VendorBusiness

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorBusiness
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


