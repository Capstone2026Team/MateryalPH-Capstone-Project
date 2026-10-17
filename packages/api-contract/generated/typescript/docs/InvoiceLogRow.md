
# InvoiceLogRow

One row of the selected view: an open request, an order without an invoice copy yet, an uploaded record or a reconciliation item.

## Properties

Name | Type
------------ | -------------
`id` | string
`orderId` | string
`orderReference` | string
`orderState` | string
`paymentState` | string
`acceptedAt` | Date
`openRequest` | boolean
`note` | string
`kind` | string
`state` | string
`details` | string
`serviceTargetAt` | Date
`serviceTargetLabel` | string
`overdue` | boolean
`invoiceType` | string
`issuer` | string
`invoiceNumber` | string
`issuedOn` | string
`amountCentavos` | number
`reconciliationState` | string
`reconciliationDifferenceCentavos` | number
`originLabel` | string
`complianceNote` | string
`vendorName` | string
`downloads` | number
`lastDownloadAt` | Date
`uploadedAt` | Date
`download` | [DisputeFileLink](DisputeFileLink.md)

## Example

```typescript
import type { InvoiceLogRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderId": null,
  "orderReference": null,
  "orderState": null,
  "paymentState": null,
  "acceptedAt": null,
  "openRequest": null,
  "note": null,
  "kind": null,
  "state": null,
  "details": null,
  "serviceTargetAt": null,
  "serviceTargetLabel": null,
  "overdue": null,
  "invoiceType": null,
  "issuer": null,
  "invoiceNumber": null,
  "issuedOn": null,
  "amountCentavos": null,
  "reconciliationState": null,
  "reconciliationDifferenceCentavos": null,
  "originLabel": null,
  "complianceNote": null,
  "vendorName": null,
  "downloads": null,
  "lastDownloadAt": null,
  "uploadedAt": null,
  "download": null,
} satisfies InvoiceLogRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceLogRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


