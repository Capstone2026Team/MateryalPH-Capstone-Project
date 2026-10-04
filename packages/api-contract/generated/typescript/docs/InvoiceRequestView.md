
# InvoiceRequestView


## Properties

Name | Type
------------ | -------------
`id` | string
`kind` | string
`state` | string
`details` | string
`invoiceRecordId` | string
`fulfilledInvoiceRecordId` | string
`requestedAt` | Date
`serviceTargetAt` | Date
`serviceTargetLabel` | string
`overdue` | boolean
`uploadedAt` | Date
`downloadedAt` | Date
`closedAt` | Date
`canReturn` | boolean
`canClose` | boolean
`orderReference` | string
`vendorName` | string

## Example

```typescript
import type { InvoiceRequestView } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "kind": null,
  "state": null,
  "details": null,
  "invoiceRecordId": null,
  "fulfilledInvoiceRecordId": null,
  "requestedAt": null,
  "serviceTargetAt": null,
  "serviceTargetLabel": null,
  "overdue": null,
  "uploadedAt": null,
  "downloadedAt": null,
  "closedAt": null,
  "canReturn": null,
  "canClose": null,
  "orderReference": null,
  "vendorName": null,
} satisfies InvoiceRequestView

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceRequestView
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


