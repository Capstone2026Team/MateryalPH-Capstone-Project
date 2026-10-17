
# ComparableVariant


## Properties

Name | Type
------------ | -------------
`groupId` | string
`displayName` | string
`material` | [AnalyticsMaterialRef](AnalyticsMaterialRef.md)
`category` | [AnalyticsCategoryRef](AnalyticsCategoryRef.md)
`specification` | [ComparableSpecification](ComparableSpecification.md)
`unit` | [AnalyticsUnit](AnalyticsUnit.md)

## Example

```typescript
import type { ComparableVariant } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "groupId": null,
  "displayName": null,
  "material": null,
  "category": null,
  "specification": null,
  "unit": null,
} satisfies ComparableVariant

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComparableVariant
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


