
# DirectoryVendorListEnvelope


## Properties

Name | Type
------------ | -------------
`data` | [Array&lt;DirectoryVendorRow&gt;](DirectoryVendorRow.md)
`meta` | [DirectoryPageMeta](DirectoryPageMeta.md)
`errors` | [Array&lt;ApiError&gt;](ApiError.md)

## Example

```typescript
import type { DirectoryVendorListEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies DirectoryVendorListEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryVendorListEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


