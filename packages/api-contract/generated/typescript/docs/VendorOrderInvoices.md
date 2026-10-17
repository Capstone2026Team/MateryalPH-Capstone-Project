
# VendorOrderInvoices


## Properties

Name | Type
------------ | -------------
`orderId` | string
`orderReference` | string
`status` | string
`issuanceNotice` | string
`records` | [Array&lt;InvoiceRecordView&gt;](InvoiceRecordView.md)
`requests` | [Array&lt;InvoiceRequestView&gt;](InvoiceRequestView.md)
`platformDocuments` | [Array&lt;PlatformDocumentRef&gt;](PlatformDocumentRef.md)
`billingDetails` | [VendorInvoiceBillingDetails](VendorInvoiceBillingDetails.md)
`canUpload` | boolean
`canOpenFiles` | boolean
`issuerName` | string
`invoiceTypes` | Array&lt;string&gt;
`sourceSystems` | Array&lt;string&gt;
`invoicingMethods` | Array&lt;string&gt;
`lines` | [Array&lt;InvoiceOrderLine&gt;](InvoiceOrderLine.md)

## Example

```typescript
import type { VendorOrderInvoices } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderId": null,
  "orderReference": null,
  "status": null,
  "issuanceNotice": null,
  "records": null,
  "requests": null,
  "platformDocuments": null,
  "billingDetails": null,
  "canUpload": null,
  "canOpenFiles": null,
  "issuerName": null,
  "invoiceTypes": null,
  "sourceSystems": null,
  "invoicingMethods": null,
  "lines": null,
} satisfies VendorOrderInvoices

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOrderInvoices
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


