
# InvoiceRecordView

A protected copy of an externally issued Vendor document. An uploaded PDF is not proof of BIR or structured e-invoicing compliance; a reconciliation difference never changes the accepted Buyer total.

## Properties

Name | Type
------------ | -------------
`id` | string
`invoiceType` | string
`issuer` | string
`invoiceNumber` | string
`issuedOn` | string
`amountCentavos` | number
`vatCentavos` | number
`documentOrigin` | string
`originLabel` | string
`verificationState` | string
`eInvoicingCoverage` | string
`complianceNote` | string
`reconciliationState` | string
`reconciliationDifferenceCentavos` | number
`expectedTotalCentavos` | number
`reconciliationNote` | string
`amendsInvoiceRecordId` | string
`uploadedAt` | Date
`uploadedRole` | string
`sourceSystem` | string
`invoicingMethod` | string
`download` | [DisputeFileLink](DisputeFileLink.md)
`canExplain` | boolean
`buyerTotalUnchanged` | boolean
`orderReference` | string
`vendorName` | string
`downloads` | number
`lastDownloadAt` | Date

## Example

```typescript
import type { InvoiceRecordView } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "invoiceType": null,
  "issuer": null,
  "invoiceNumber": null,
  "issuedOn": null,
  "amountCentavos": null,
  "vatCentavos": null,
  "documentOrigin": null,
  "originLabel": null,
  "verificationState": null,
  "eInvoicingCoverage": null,
  "complianceNote": null,
  "reconciliationState": null,
  "reconciliationDifferenceCentavos": null,
  "expectedTotalCentavos": null,
  "reconciliationNote": null,
  "amendsInvoiceRecordId": null,
  "uploadedAt": null,
  "uploadedRole": null,
  "sourceSystem": null,
  "invoicingMethod": null,
  "download": null,
  "canExplain": null,
  "buyerTotalUnchanged": null,
  "orderReference": null,
  "vendorName": null,
  "downloads": null,
  "lastDownloadAt": null,
} satisfies InvoiceRecordView

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceRecordView
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


