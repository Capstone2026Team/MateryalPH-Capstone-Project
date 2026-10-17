
# TaxAdjustment


## Properties

Name | Type
------------ | -------------
`id` | string
`kind` | string
`state` | string
`environment` | string
`openedBy` | string
`orderReference` | string
`vendorName` | string
`originalRecordType` | string
`originalRecordId` | string
`periodStart` | Date
`periodEnd` | Date
`amountCentavos` | number
`beforeValues` | { [key: string]: any; }
`afterValues` | { [key: string]: any; }
`reason` | string
`preparer` | string
`reviewer` | string
`reviewedAt` | Date
`postedAt` | Date
`createdAt` | Date
`allowedActions` | Array&lt;string&gt;
`separationNote` | string

## Example

```typescript
import type { TaxAdjustment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "kind": null,
  "state": null,
  "environment": null,
  "openedBy": null,
  "orderReference": null,
  "vendorName": null,
  "originalRecordType": null,
  "originalRecordId": null,
  "periodStart": null,
  "periodEnd": null,
  "amountCentavos": null,
  "beforeValues": null,
  "afterValues": null,
  "reason": null,
  "preparer": null,
  "reviewer": null,
  "reviewedAt": null,
  "postedAt": null,
  "createdAt": null,
  "allowedActions": null,
  "separationNote": null,
} satisfies TaxAdjustment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as TaxAdjustment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


