
# DirectorySupplierPhoto


## Properties

Name | Type
------------ | -------------
`photos` | [Array&lt;GooglePlacePhoto&gt;](GooglePlacePhoto.md)
`providerAttributions` | [Array&lt;GoogleContentAuthor&gt;](GoogleContentAuthor.md)

## Example

```typescript
import type { DirectorySupplierPhoto } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "photos": null,
  "providerAttributions": null,
} satisfies DirectorySupplierPhoto

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectorySupplierPhoto
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


