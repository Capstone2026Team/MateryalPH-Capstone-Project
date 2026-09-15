
# VendorStore


## Properties

Name | Type
------------ | -------------
`id` | string
`description` | string
`publicEmail` | string
`publicPhone` | string
`pickupEnabled` | boolean
`deliveryEnabled` | boolean
`codEnabled` | boolean
`inStorePaymentEnabled` | boolean
`paymentMethods` | { [key: string]: any; }
`refundConfiguration` | { [key: string]: any; }

## Example

```typescript
import type { VendorStore } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "description": null,
  "publicEmail": null,
  "publicPhone": null,
  "pickupEnabled": null,
  "deliveryEnabled": null,
  "codEnabled": null,
  "inStorePaymentEnabled": null,
  "paymentMethods": null,
  "refundConfiguration": null,
} satisfies VendorStore

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorStore
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


