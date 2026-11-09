
# InvoiceOrderSummary

Accepted order values and billing facts for context, excluding Buyer processing fees and full TIN. Not extracted invoice prices or newly computed tax. Snapshotted when a copy is sent; VAT is included, never added again.

## Properties

Name | Type
------------ | -------------
`lines` | [Array&lt;InvoiceOrderLine&gt;](InvoiceOrderLine.md)
`billingDetails` | [InvoiceBillingSnapshot](InvoiceBillingSnapshot.md)
`materialsSubtotalCentavos` | number
`discountCentavos` | number
`deliveryCentavos` | number
`includedVatCentavos` | number
`totalCentavos` | number

## Example

```typescript
import type { InvoiceOrderSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lines": null,
  "billingDetails": null,
  "materialsSubtotalCentavos": null,
  "discountCentavos": null,
  "deliveryCentavos": null,
  "includedVatCentavos": null,
  "totalCentavos": null,
} satisfies InvoiceOrderSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceOrderSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


