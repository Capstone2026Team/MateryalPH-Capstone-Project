
# SaveVendorStore


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`description` | string
`publicEmail` | string
`publicPhone` | string
`bulkOrderCapable` | boolean
`fulfillment` | string
`codEnabled` | boolean
`inStorePaymentEnabled` | boolean
`onlinePaymentEnabled` | boolean
`refundConfiguration` | [SaveVendorStoreRefundConfiguration](SaveVendorStoreRefundConfiguration.md)
`deliveryVehicles` | [Array&lt;VendorVehicle&gt;](VendorVehicle.md)
`hours` | [Array&lt;VendorOperatingDay&gt;](VendorOperatingDay.md)

## Example

```typescript
import type { SaveVendorStore } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "description": null,
  "publicEmail": null,
  "publicPhone": null,
  "bulkOrderCapable": null,
  "fulfillment": null,
  "codEnabled": null,
  "inStorePaymentEnabled": null,
  "onlinePaymentEnabled": null,
  "refundConfiguration": null,
  "deliveryVehicles": null,
  "hours": null,
} satisfies SaveVendorStore

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SaveVendorStore
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


