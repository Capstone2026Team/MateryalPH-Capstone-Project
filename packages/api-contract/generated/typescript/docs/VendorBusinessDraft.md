
# VendorBusinessDraft


## Properties

Name | Type
------------ | -------------
`legalName` | string
`individualRegisteredName` | [VendorIndividualRegisteredName](VendorIndividualRegisteredName.md)
`companyRegisteredName` | string
`governmentIdType` | string
`governmentIdNumber` | string
`storeName` | string
`establishedOn` | string
`storeEmail` | string
`storePhone` | string
`businessType` | string
`classification` | string
`niches` | Array&lt;string&gt;
`otherNiche` | string
`address` | [VendorBusinessAddress](VendorBusinessAddress.md)
`contacts` | [Array&lt;VendorBusinessContact&gt;](VendorBusinessContact.md)

## Example

```typescript
import type { VendorBusinessDraft } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "legalName": null,
  "individualRegisteredName": null,
  "companyRegisteredName": null,
  "governmentIdType": null,
  "governmentIdNumber": null,
  "storeName": null,
  "establishedOn": null,
  "storeEmail": null,
  "storePhone": null,
  "businessType": null,
  "classification": null,
  "niches": null,
  "otherNiche": null,
  "address": null,
  "contacts": null,
} satisfies VendorBusinessDraft

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorBusinessDraft
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


