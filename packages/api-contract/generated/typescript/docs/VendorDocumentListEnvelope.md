
# VendorDocumentListEnvelope


## Properties

Name | Type
------------ | -------------
`data` | [Array&lt;VendorDocument&gt;](VendorDocument.md)
`meta` | { [key: string]: any; }
`errors` | [Array&lt;ApiError&gt;](ApiError.md)

## Example

```typescript
import type { VendorDocumentListEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies VendorDocumentListEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDocumentListEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


