
# BuyerOnboarding


## Properties

Name | Type
------------ | -------------
`status` | string
`completedAt` | Date
`buyerType` | string
`companyName` | string
`positionTitle` | string
`industryClassification` | [BuyerIndustryClassification](BuyerIndustryClassification.md)
`industryOtherLabel` | string
`preferredCategoryIds` | Array&lt;string&gt;
`discoveryRadiusKm` | [RadiusKm](RadiusKm.md)
`hasPrimaryLocation` | boolean
`lockVersion` | number
`categories` | [Array&lt;MaterialCategoryOption&gt;](MaterialCategoryOption.md)
`industries` | [Array&lt;BuyerIndustryClassification&gt;](BuyerIndustryClassification.md)

## Example

```typescript
import type { BuyerOnboarding } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "completedAt": null,
  "buyerType": null,
  "companyName": null,
  "positionTitle": null,
  "industryClassification": null,
  "industryOtherLabel": null,
  "preferredCategoryIds": null,
  "discoveryRadiusKm": null,
  "hasPrimaryLocation": null,
  "lockVersion": null,
  "categories": null,
  "industries": null,
} satisfies BuyerOnboarding

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerOnboarding
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


