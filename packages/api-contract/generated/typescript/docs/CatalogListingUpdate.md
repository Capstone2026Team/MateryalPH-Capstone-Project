
# CatalogListingUpdate


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`displayName` | string
`vendorSku` | string
`description` | string
`materialId` | string
`materialMatch` | string
`otherLabel` | string
`materialCategoryId` | string
`tagIds` | Array&lt;string&gt;
`brand` | string
`model` | string
`manufacturer` | string
`manufacturerAddress` | string
`countryOfManufacture` | string
`technicalAttributes` | { [key: string]: string; }

## Example

```typescript
import type { CatalogListingUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "displayName": null,
  "vendorSku": null,
  "description": null,
  "materialId": null,
  "materialMatch": null,
  "otherLabel": null,
  "materialCategoryId": null,
  "tagIds": null,
  "brand": null,
  "model": null,
  "manufacturer": null,
  "manufacturerAddress": null,
  "countryOfManufacture": null,
  "technicalAttributes": null,
} satisfies CatalogListingUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogListingUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


