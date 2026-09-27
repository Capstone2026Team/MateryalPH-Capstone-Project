
# ComplianceSubmission

Vendor-confirmed declaration from Review and Confirm. Extraction output is never submitted as truth.

## Properties

Name | Type
------------ | -------------
`listingLockVersion` | number
`path` | [CompliancePath](CompliancePath.md)
`evidenceIds` | Array&lt;string&gt;
`markingType` | [MarkingType](MarkingType.md)
`certificateNumber` | string
`manufacturerName` | string
`manufacturerAddress` | string
`importerName` | string
`importerAddress` | string
`countryOfManufacture` | string
`brand` | string
`batchNumber` | string
`confirmed` | boolean

## Example

```typescript
import type { ComplianceSubmission } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingLockVersion": null,
  "path": null,
  "evidenceIds": null,
  "markingType": null,
  "certificateNumber": null,
  "manufacturerName": null,
  "manufacturerAddress": null,
  "importerName": null,
  "importerAddress": null,
  "countryOfManufacture": null,
  "brand": null,
  "batchNumber": null,
  "confirmed": null,
} satisfies ComplianceSubmission

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComplianceSubmission
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


