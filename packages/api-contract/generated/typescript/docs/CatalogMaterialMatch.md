
# CatalogMaterialMatch


## Properties

Name | Type
------------ | -------------
`id` | string
`code` | string
`name` | string
`categoryId` | string
`categoryName` | string
`regulated` | boolean
`matchType` | string
`matchedText` | string
`similarity` | number

## Example

```typescript
import type { CatalogMaterialMatch } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "code": null,
  "name": null,
  "categoryId": null,
  "categoryName": null,
  "regulated": null,
  "matchType": null,
  "matchedText": null,
  "similarity": null,
} satisfies CatalogMaterialMatch

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogMaterialMatch
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


