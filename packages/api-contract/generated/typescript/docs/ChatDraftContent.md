
# ChatDraftContent


## Properties

Name | Type
------------ | -------------
`message` | string
`lines` | [Array&lt;ChatDraftLine&gt;](ChatDraftLine.md)
`fulfillmentMethod` | string
`paymentMethod` | string
`fulfillmentDate` | string
`deadlineHours` | number
`vendorDiscountCentavos` | number
`discount` | [ChatQuotationDiscount](ChatQuotationDiscount.md)
`destination` | [ChatQuotationDestination](ChatQuotationDestination.md)
`delivery` | { [key: string]: any; }
`nrpc` | { [key: string]: any; }

## Example

```typescript
import type { ChatDraftContent } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "message": null,
  "lines": null,
  "fulfillmentMethod": null,
  "paymentMethod": null,
  "fulfillmentDate": null,
  "deadlineHours": null,
  "vendorDiscountCentavos": null,
  "discount": null,
  "destination": null,
  "delivery": null,
  "nrpc": null,
} satisfies ChatDraftContent

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatDraftContent
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


