
# CatalogLimits


## Properties

Name | Type
------------ | -------------
`maxVariants` | number
`maxMedia` | number
`maxListingImageKb` | number
`imageTypes` | Array&lt;string&gt;

## Example

```typescript
import type { CatalogLimits } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "maxVariants": null,
  "maxMedia": null,
  "maxListingImageKb": null,
  "imageTypes": null,
} satisfies CatalogLimits

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogLimits
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


