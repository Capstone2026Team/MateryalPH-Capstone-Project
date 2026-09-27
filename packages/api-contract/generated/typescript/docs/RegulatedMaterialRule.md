
# RegulatedMaterialRule

Transcribed from the DTI-BPS list of regulated building and construction products with marking requirements.

## Properties

Name | Type
------------ | -------------
`id` | string
`version` | number
`requiredMarking` | string
`productName` | string
`referenceStandard` | string
`technicalRegulation` | string
`scope` | string
`markingRequirements` | Array&lt;string&gt;
`sourceReference` | string

## Example

```typescript
import type { RegulatedMaterialRule } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "version": null,
  "requiredMarking": null,
  "productName": null,
  "referenceStandard": null,
  "technicalRegulation": null,
  "scope": null,
  "markingRequirements": null,
  "sourceReference": null,
} satisfies RegulatedMaterialRule

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RegulatedMaterialRule
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


