
# CheckoutChildOrder


## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`vendor` | [OrderVendorRef](OrderVendorRef.md)
`orderState` | [OrderState](OrderState.md)
`paymentState` | [OrderPaymentState](OrderPaymentState.md)
`fulfillmentMethod` | string
`paymentMethod` | string
`confirmationSource` | string
`materialsCentavos` | number
`deliveryCentavos` | number
`commercialTotalCentavos` | number
`vendorResponseDueAt` | Date
`paymentExpiresAt` | Date

## Example

```typescript
import type { CheckoutChildOrder } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "vendor": null,
  "orderState": null,
  "paymentState": null,
  "fulfillmentMethod": null,
  "paymentMethod": null,
  "confirmationSource": null,
  "materialsCentavos": null,
  "deliveryCentavos": null,
  "commercialTotalCentavos": null,
  "vendorResponseDueAt": null,
  "paymentExpiresAt": null,
} satisfies CheckoutChildOrder

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutChildOrder
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


