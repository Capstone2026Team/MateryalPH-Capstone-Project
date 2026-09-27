
# CatalogAttributeDefinition


## Properties

Name | Type
------------ | -------------
`id` | string
`materialCategoryId` | string
`code` | string
`label` | string
`valueType` | string
`required` | boolean
`allowedValues` | Array&lt;string&gt;
`unitCode` | string
`comparabilityKey` | boolean

## Example

```typescript
import type { CatalogAttributeDefinition } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "materialCategoryId": null,
  "code": null,
  "label": null,
  "valueType": null,
  "required": null,
  "allowedValues": null,
  "unitCode": null,
  "comparabilityKey": null,
} satisfies CatalogAttributeDefinition

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogAttributeDefinition
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


