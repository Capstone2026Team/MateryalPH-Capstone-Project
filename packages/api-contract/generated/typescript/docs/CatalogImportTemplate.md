
# CatalogImportTemplate


## Properties

Name | Type
------------ | -------------
`templateVersion` | string
`columns` | Array&lt;string&gt;
`requiredColumns` | Array&lt;string&gt;
`maxRows` | number

## Example

```typescript
import type { CatalogImportTemplate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "templateVersion": null,
  "columns": null,
  "requiredColumns": null,
  "maxRows": null,
} satisfies CatalogImportTemplate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogImportTemplate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


