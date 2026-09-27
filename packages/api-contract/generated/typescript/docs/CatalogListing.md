
# CatalogListing


## Properties

Name | Type
------------ | -------------
`id` | string
`status` | [ListingStatus](ListingStatus.md)
`lockVersion` | number
`displayName` | string
`vendorSku` | string
`description` | string
`material` | [CatalogListingMaterial](CatalogListingMaterial.md)
`materialMatch` | string
`materialCategoryId` | string
`otherLabel` | string
`tagIds` | Array&lt;string&gt;
`technicalAttributes` | { [key: string]: string; }
`brand` | string
`model` | string
`manufacturer` | string
`manufacturerAddress` | string
`countryOfManufacture` | string
`regulated` | boolean
`complianceStatus` | [ListingComplianceStatus](ListingComplianceStatus.md)
`regulatedRule` | [RegulatedMaterialRule](RegulatedMaterialRule.md)
`publicationVersion` | number
`publishedAt` | string
`publicationRequestedAt` | string
`variants` | [Array&lt;CatalogVariant&gt;](CatalogVariant.md)
`media` | [Array&lt;CatalogMedia&gt;](CatalogMedia.md)
`complianceSubmissions` | [Array&lt;ComplianceSubmissionSummary&gt;](ComplianceSubmissionSummary.md)
`statusHistory` | [Array&lt;ListingStatusChange&gt;](ListingStatusChange.md)
`completion` | [CatalogCompletion](CatalogCompletion.md)
`blockers` | [Array&lt;CatalogBlocker&gt;](CatalogBlocker.md)
`permissions` | [CatalogListingPermissions](CatalogListingPermissions.md)
`uploadedMediaId` | string

## Example

```typescript
import type { CatalogListing } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "status": null,
  "lockVersion": null,
  "displayName": null,
  "vendorSku": null,
  "description": null,
  "material": null,
  "materialMatch": null,
  "materialCategoryId": null,
  "otherLabel": null,
  "tagIds": null,
  "technicalAttributes": null,
  "brand": null,
  "model": null,
  "manufacturer": null,
  "manufacturerAddress": null,
  "countryOfManufacture": null,
  "regulated": null,
  "complianceStatus": null,
  "regulatedRule": null,
  "publicationVersion": null,
  "publishedAt": null,
  "publicationRequestedAt": null,
  "variants": null,
  "media": null,
  "complianceSubmissions": null,
  "statusHistory": null,
  "completion": null,
  "blockers": null,
  "permissions": null,
  "uploadedMediaId": null,
} satisfies CatalogListing

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogListing
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


