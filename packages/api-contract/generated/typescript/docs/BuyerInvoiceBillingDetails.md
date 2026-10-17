
# BuyerInvoiceBillingDetails


## Properties

Name | Type
------------ | -------------
`billingName` | string
`billingAddress` | string
`tinMasked` | string
`lockVersion` | number

## Example

```typescript
import type { BuyerInvoiceBillingDetails } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "billingName": null,
  "billingAddress": null,
  "tinMasked": null,
  "lockVersion": null,
} satisfies BuyerInvoiceBillingDetails

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerInvoiceBillingDetails
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


