
# ProductComplianceQueueItem


## Properties

Name | Type
------------ | -------------
`id` | string
`version` | number
`path` | [CompliancePath](CompliancePath.md)
`status` | string
`markingType` | string
`submittedAt` | string
`listingId` | string
`displayName` | string
`vendorSku` | string
`publicStoreName` | string
`materialName` | string
`productName` | string
`referenceStandard` | string
`referenceResult` | string

## Example

```typescript
import type { ProductComplianceQueueItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "version": null,
  "path": null,
  "status": null,
  "markingType": null,
  "submittedAt": null,
  "listingId": null,
  "displayName": null,
  "vendorSku": null,
  "publicStoreName": null,
  "materialName": null,
  "productName": null,
  "referenceStandard": null,
  "referenceResult": null,
} satisfies ProductComplianceQueueItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductComplianceQueueItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


