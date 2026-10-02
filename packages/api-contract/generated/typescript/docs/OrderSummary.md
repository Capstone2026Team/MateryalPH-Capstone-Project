
# OrderSummary

Buyer rows add next_action; Vendor rows add buyer, primary_action and nrpc_indicator.

## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`vendor` | [OrderVendorRef](OrderVendorRef.md)
`submittedAt` | Date
`procurementType` | string
`confirmationSource` | string
`states` | [Array&lt;OrderStateRow&gt;](OrderStateRow.md)
`fulfillmentMethod` | string
`paymentMethod` | string
`lineCount` | number
`firstLine` | [OrderFirstLine](OrderFirstLine.md)
`materialsCentavos` | number
`deliveryCentavos` | number
`commercialTotalCentavos` | number
`deliveryPending` | boolean
`deadline` | [OrderDeadline](OrderDeadline.md)
`expectedFulfillmentDate` | Date
`nextAction` | string
`paymentRetryable` | boolean
`buyer` | [OrderBuyerRef](OrderBuyerRef.md)
`primaryAction` | [VendorOrderPrimaryAction](VendorOrderPrimaryAction.md)
`nrpcIndicator` | boolean

## Example

```typescript
import type { OrderSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "vendor": null,
  "submittedAt": null,
  "procurementType": null,
  "confirmationSource": null,
  "states": null,
  "fulfillmentMethod": null,
  "paymentMethod": null,
  "lineCount": null,
  "firstLine": null,
  "materialsCentavos": null,
  "deliveryCentavos": null,
  "commercialTotalCentavos": null,
  "deliveryPending": null,
  "deadline": null,
  "expectedFulfillmentDate": null,
  "nextAction": null,
  "paymentRetryable": null,
  "buyer": null,
  "primaryAction": null,
  "nrpcIndicator": null,
} satisfies OrderSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


