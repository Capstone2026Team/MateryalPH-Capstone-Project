
# CheckoutGroupPreview


## Properties

Name | Type
------------ | -------------
`vendor` | [CheckoutVendorRef](CheckoutVendorRef.md)
`fulfillmentMethod` | string
`fulfillmentOptions` | Array&lt;string&gt;
`status` | string
`issues` | [Array&lt;CartIssue&gt;](CartIssue.md)
`lines` | [Array&lt;CartLine&gt;](CartLine.md)
`delivery` | [DeliveryPreview](DeliveryPreview.md)
`pickup` | [PickupPreview](PickupPreview.md)
`paymentMethods` | [Array&lt;PaymentMethodEligibility&gt;](PaymentMethodEligibility.md)
`amounts` | [FinancialPreview](FinancialPreview.md)

## Example

```typescript
import type { CheckoutGroupPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendor": null,
  "fulfillmentMethod": null,
  "fulfillmentOptions": null,
  "status": null,
  "issues": null,
  "lines": null,
  "delivery": null,
  "pickup": null,
  "paymentMethods": null,
  "amounts": null,
} satisfies CheckoutGroupPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutGroupPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


