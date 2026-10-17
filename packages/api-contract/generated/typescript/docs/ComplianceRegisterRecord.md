
# ComplianceRegisterRecord

Public DTI-BPS register details for the looked-up number.

## Properties

Name | Type
------------ | -------------
`registerKind` | string
`companyName` | string
`productDescription` | string
`brand` | string
`modelType` | string
`referenceStandard` | string
`address` | string
`origin` | string
`licenseNumber` | string
`iccCertificateNumber` | string
`serialRange` | string
`expiresOn` | string

## Example

```typescript
import type { ComplianceRegisterRecord } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "registerKind": null,
  "companyName": null,
  "productDescription": null,
  "brand": null,
  "modelType": null,
  "referenceStandard": null,
  "address": null,
  "origin": null,
  "licenseNumber": null,
  "iccCertificateNumber": null,
  "serialRange": null,
  "expiresOn": null,
} satisfies ComplianceRegisterRecord

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComplianceRegisterRecord
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


