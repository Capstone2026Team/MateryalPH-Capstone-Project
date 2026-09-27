
# CatalogMaterial


## Properties

Name | Type
------------ | -------------
`id` | string
`code` | string
`name` | string
`regulated` | boolean
`categoryId` | string
`categoryName` | string
`canonicalUnitId` | string
`compatibleUnitIds` | Array&lt;string&gt;
`suggestedTagIds` | Array&lt;string&gt;
`regulatedRule` | [RegulatedMaterialRule](RegulatedMaterialRule.md)

## Example

```typescript
import type { CatalogMaterial } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "code": null,
  "name": null,
  "regulated": null,
  "categoryId": null,
  "categoryName": null,
  "canonicalUnitId": null,
  "compatibleUnitIds": null,
  "suggestedTagIds": null,
  "regulatedRule": null,
} satisfies CatalogMaterial

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogMaterial
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


