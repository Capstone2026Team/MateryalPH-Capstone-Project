
# InvoiceDraft

Private Vendor preparation. Only invoice-upload roles receive it. The uploaded file is ready for review; sending freezes a separate invoice record. Buyer and Admin record lists never include drafts.

## Properties

Name | Type
------------ | -------------
`invoiceType` | string
`issuerName` | string
`invoiceNumber` | string
`issuedOn` | Date
`amountCentavos` | number
`vatCentavos` | number
`vatExemptCentavos` | number
`zeroRatedCentavos` | number
`relatedLineIds` | Array&lt;string&gt;
`sourceSystem` | string
`invoicingMethod` | string
`amendsInvoiceRecordId` | string
`invoiceRequestId` | string
`lockVersion` | number
`id` | string
`sentRecordId` | string
`sentAt` | Date
`updatedAt` | Date
`fileName` | string
`contentType` | string
`fileSizeBytes` | number
`download` | [DisputeFileLink](DisputeFileLink.md)

## Example

```typescript
import type { InvoiceDraft } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "invoiceType": null,
  "issuerName": null,
  "invoiceNumber": null,
  "issuedOn": null,
  "amountCentavos": null,
  "vatCentavos": null,
  "vatExemptCentavos": null,
  "zeroRatedCentavos": null,
  "relatedLineIds": null,
  "sourceSystem": null,
  "invoicingMethod": null,
  "amendsInvoiceRecordId": null,
  "invoiceRequestId": null,
  "lockVersion": null,
  "id": null,
  "sentRecordId": null,
  "sentAt": null,
  "updatedAt": null,
  "fileName": null,
  "contentType": null,
  "fileSizeBytes": null,
  "download": null,
} satisfies InvoiceDraft

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceDraft
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


