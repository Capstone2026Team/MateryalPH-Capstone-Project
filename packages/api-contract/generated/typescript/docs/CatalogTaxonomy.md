
# CatalogTaxonomy


## Properties

Name | Type
------------ | -------------
`categories` | [Array&lt;CatalogReference&gt;](CatalogReference.md)
`units` | [Array&lt;CatalogUnit&gt;](CatalogUnit.md)
`tags` | [Array&lt;CatalogReference&gt;](CatalogReference.md)
`attributeDefinitions` | [Array&lt;CatalogAttributeDefinition&gt;](CatalogAttributeDefinition.md)
`taxCategories` | [Array&lt;TaxCategory&gt;](TaxCategory.md)
`allowedTaxCategories` | [Array&lt;TaxCategory&gt;](TaxCategory.md)
`limits` | [CatalogLimits](CatalogLimits.md)

## Example

```typescript
import type { CatalogTaxonomy } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "categories": null,
  "units": null,
  "tags": null,
  "attributeDefinitions": null,
  "taxCategories": null,
  "allowedTaxCategories": null,
  "limits": null,
} satisfies CatalogTaxonomy

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogTaxonomy
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


