
# BuyerOnboardingUpdate


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`action` | string
`companyName` | string
`positionTitle` | string
`industryClassification` | [BuyerIndustryClassification](BuyerIndustryClassification.md)
`industryOtherLabel` | string
`preferredCategoryIds` | Array&lt;string&gt;

## Example

```typescript
import type { BuyerOnboardingUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "action": null,
  "companyName": null,
  "positionTitle": null,
  "industryClassification": null,
  "industryOtherLabel": null,
  "preferredCategoryIds": null,
} satisfies BuyerOnboardingUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerOnboardingUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


