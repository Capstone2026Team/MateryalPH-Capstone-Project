
# CatalogListingEnvelope


## Properties

Name | Type
------------ | -------------
`data` | [CatalogListing](CatalogListing.md)
`meta` | { [key: string]: any; }
`errors` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { CatalogListingEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies CatalogListingEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogListingEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


