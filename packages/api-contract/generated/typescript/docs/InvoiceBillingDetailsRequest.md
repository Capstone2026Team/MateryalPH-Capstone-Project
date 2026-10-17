
# InvoiceBillingDetailsRequest

Collected only for the invoice. The TIN is encrypted and shown masked to the Buyer.

## Properties

Name | Type
------------ | -------------
`billingName` | string
`billingAddress` | string
`tin` | string
`lockVersion` | number

## Example

```typescript
import type { InvoiceBillingDetailsRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "billingName": null,
  "billingAddress": null,
  "tin": null,
  "lockVersion": null,
} satisfies InvoiceBillingDetailsRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceBillingDetailsRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


