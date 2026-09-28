
# CatalogListingSummary


## Properties

Name | Type
------------ | -------------
`id` | string
`displayName` | string
`vendorSku` | string
`status` | [ListingStatus](ListingStatus.md)
`complianceStatus` | [ListingComplianceStatus](ListingComplianceStatus.md)
`regulated` | boolean
`categoryName` | string
`materialName` | string
`otherLabel` | string
`lockVersion` | number
`updatedAt` | string
`variantCount` | number
`minPriceCentavos` | number
`maxPriceCentavos` | number
`publicAvailability` | string
`primaryImageFileId` | string
`deletable` | boolean
`primaryImageUrl` | string
`unitCode` | string
`availableQuantity` | string

## Example

```typescript
import type { CatalogListingSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "displayName": null,
  "vendorSku": null,
  "status": null,
  "complianceStatus": null,
  "regulated": null,
  "categoryName": null,
  "materialName": null,
  "otherLabel": null,
  "lockVersion": null,
  "updatedAt": null,
  "variantCount": null,
  "minPriceCentavos": null,
  "maxPriceCentavos": null,
  "publicAvailability": null,
  "primaryImageFileId": null,
  "deletable": null,
  "primaryImageUrl": null,
  "unitCode": null,
  "availableQuantity": null,
} satisfies CatalogListingSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogListingSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


