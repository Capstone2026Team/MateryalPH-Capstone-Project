
# CheckoutInvoiceDetails

Optional billing details saved atomically for each submitted child order. TIN is encrypted and displayed masked. This supplies details before issuance; invoice copy/correction requests remain available once the sale is confirmed. No default billing profile is saved.

## Properties

Name | Type
------------ | -------------
`billingName` | string
`billingAddress` | string
`tin` | string

## Example

```typescript
import type { CheckoutInvoiceDetails } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "billingName": null,
  "billingAddress": null,
  "tin": null,
} satisfies CheckoutInvoiceDetails

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutInvoiceDetails
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


