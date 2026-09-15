
# VendorDocument


## Properties

Name | Type
------------ | -------------
`reviewReason` | string
`verifiedReference` | string
`verifiedIssuedOn` | string
`verifiedExpiresOn` | string
`verifiedExpiryNotApplicable` | boolean
`id` | string
`documentType` | string
`status` | string
`version` | number
`environment` | string
`evidenceOrigin` | string
`scanState` | string
`createdAt` | string

## Example

```typescript
import type { VendorDocument } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "reviewReason": null,
  "verifiedReference": null,
  "verifiedIssuedOn": null,
  "verifiedExpiresOn": null,
  "verifiedExpiryNotApplicable": null,
  "id": null,
  "documentType": null,
  "status": null,
  "version": null,
  "environment": null,
  "evidenceOrigin": null,
  "scanState": null,
  "createdAt": null,
} satisfies VendorDocument

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDocument
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


