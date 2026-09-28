
# VerifiedVendorSummary


## Properties

Name | Type
------------ | -------------
`logoUrl` | string
`supplierType` | string
`niches` | Array&lt;string&gt;
`fulfillmentMethod` | string
`vacationMode` | boolean
`publicPhone` | string
`address` | [PublicAddressSummary](PublicAddressSummary.md)
`openStatus` | [SupplierOpenStatus](SupplierOpenStatus.md)
`serviceability` | [SupplierServiceability](SupplierServiceability.md)

## Example

```typescript
import type { VerifiedVendorSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "logoUrl": null,
  "supplierType": null,
  "niches": null,
  "fulfillmentMethod": null,
  "vacationMode": null,
  "publicPhone": null,
  "address": null,
  "openStatus": null,
  "serviceability": null,
} satisfies VerifiedVendorSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VerifiedVendorSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


