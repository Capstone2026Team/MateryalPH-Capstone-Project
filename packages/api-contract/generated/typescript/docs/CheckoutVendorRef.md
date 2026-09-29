
# CheckoutVendorRef


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`logoUrl` | string
`address` | [PublicAddressSummary](PublicAddressSummary.md)
`openStatus` | [SupplierOpenStatus](SupplierOpenStatus.md)

## Example

```typescript
import type { CheckoutVendorRef } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "logoUrl": null,
  "address": null,
  "openStatus": null,
} satisfies CheckoutVendorRef

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutVendorRef
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


