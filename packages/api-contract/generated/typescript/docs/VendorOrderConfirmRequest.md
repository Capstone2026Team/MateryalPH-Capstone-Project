
# VendorOrderConfirmRequest


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`lines` | [Array&lt;OrderLineQuantity&gt;](OrderLineQuantity.md)
`vendorDiscountCentavos` | number
`nrpc` | [NrpcProposal](NrpcProposal.md)
`pickup` | [PickupConfirmation](PickupConfirmation.md)
`delivery` | [DeliveryConfirmation](DeliveryConfirmation.md)

## Example

```typescript
import type { VendorOrderConfirmRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "lines": null,
  "vendorDiscountCentavos": null,
  "nrpc": null,
  "pickup": null,
  "delivery": null,
} satisfies VendorOrderConfirmRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOrderConfirmRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


