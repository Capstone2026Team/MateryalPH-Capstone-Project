
# ProductComplianceCaseEnvelopeData


## Properties

Name | Type
------------ | -------------
`submission` | { [key: string]: any; }
`listing` | { [key: string]: any; }
`rule` | [RegulatedMaterialRule](RegulatedMaterialRule.md)
`evidence` | Array&lt;{ [key: string]: any; }&gt;
`extractions` | Array&lt;{ [key: string]: any; }&gt;
`referenceMatch` | { [key: string]: any; }
`previousSubmissions` | Array&lt;{ [key: string]: any; }&gt;
`reviews` | Array&lt;{ [key: string]: any; }&gt;
`officialReferences` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { ProductComplianceCaseEnvelopeData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "submission": null,
  "listing": null,
  "rule": null,
  "evidence": null,
  "extractions": null,
  "referenceMatch": null,
  "previousSubmissions": null,
  "reviews": null,
  "officialReferences": null,
} satisfies ProductComplianceCaseEnvelopeData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductComplianceCaseEnvelopeData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


