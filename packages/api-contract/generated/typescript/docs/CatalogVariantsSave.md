
# CatalogVariantsSave


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`variants` | [Array&lt;CatalogVariantInput&gt;](CatalogVariantInput.md)

## Example

```typescript
import type { CatalogVariantsSave } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "variants": null,
} satisfies CatalogVariantsSave

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogVariantsSave
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


