
# VendorVerificationDraftClassification


## Properties

Name | Type
------------ | -------------
`supplierType` | string
`niches` | Array&lt;string&gt;
`customLabel` | string
`customLabels` | Set&lt;string&gt;

## Example

```typescript
import type { VendorVerificationDraftClassification } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "supplierType": null,
  "niches": null,
  "customLabel": null,
  "customLabels": null,
} satisfies VendorVerificationDraftClassification

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorVerificationDraftClassification
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


