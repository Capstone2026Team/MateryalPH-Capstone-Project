
# CatalogListingListMeta


## Properties

Name | Type
------------ | -------------
`currentPage` | number
`lastPage` | number
`total` | number
`scope` | string
`statusCounts` | { [key: string]: number; }
`activeOutOfStock` | number

## Example

```typescript
import type { CatalogListingListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "currentPage": null,
  "lastPage": null,
  "total": null,
  "scope": null,
  "statusCounts": null,
  "activeOutOfStock": null,
} satisfies CatalogListingListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogListingListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


