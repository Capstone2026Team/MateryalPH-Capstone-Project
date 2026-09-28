
# DirectorySupplierDetail

Informational Tier 1 details. There is intentionally no VPS, verification, listing, message, order, review, payment or storefront field.

## Properties

Name | Type
------------ | -------------
`resultId` | string
`tier` | string
`tierLabel` | string
`name` | string
`formattedAddress` | string
`marker` | [MapPoint](MapPoint.md)
`publicPhone` | string
`websiteUri` | string
`googleMapsUri` | string
`openingHours` | Array&lt;string&gt;
`googleRating` | [GoogleRating](GoogleRating.md)
`attribution` | [ProviderAttribution](ProviderAttribution.md)
`fetchedAt` | Date
`actions` | Array&lt;string&gt;

## Example

```typescript
import type { DirectorySupplierDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "resultId": null,
  "tier": null,
  "tierLabel": null,
  "name": null,
  "formattedAddress": null,
  "marker": null,
  "publicPhone": null,
  "websiteUri": null,
  "googleMapsUri": null,
  "openingHours": null,
  "googleRating": null,
  "attribution": null,
  "fetchedAt": null,
  "actions": null,
} satisfies DirectorySupplierDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectorySupplierDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


