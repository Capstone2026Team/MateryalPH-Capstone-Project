
# VendorTaxVersionHistory


## Properties

Name | Type
------------ | -------------
`id` | string
`version` | number
`evidenceOrigin` | string
`environment` | string
`ownerAttestedAt` | string
`createdAt` | string
`status` | string
`reviews` | [Array&lt;VendorTaxReviewHistory&gt;](VendorTaxReviewHistory.md)

## Example

```typescript
import type { VendorTaxVersionHistory } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "version": null,
  "evidenceOrigin": null,
  "environment": null,
  "ownerAttestedAt": null,
  "createdAt": null,
  "status": null,
  "reviews": null,
} satisfies VendorTaxVersionHistory

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTaxVersionHistory
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


