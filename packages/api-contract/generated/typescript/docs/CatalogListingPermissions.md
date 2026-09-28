
# CatalogListingPermissions


## Properties

Name | Type
------------ | -------------
`canManage` | boolean
`canSubmitCompliance` | boolean
`canDelete` | boolean

## Example

```typescript
import type { CatalogListingPermissions } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "canManage": null,
  "canSubmitCompliance": null,
  "canDelete": null,
} satisfies CatalogListingPermissions

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogListingPermissions
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


