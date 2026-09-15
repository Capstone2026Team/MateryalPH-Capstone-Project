
# VendorDocumentUpload


## Properties

Name | Type
------------ | -------------
`id` | string
`documentId` | string
`version` | number
`scanState` | string
`environment` | string

## Example

```typescript
import type { VendorDocumentUpload } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "documentId": null,
  "version": null,
  "scanState": null,
  "environment": null,
} satisfies VendorDocumentUpload

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDocumentUpload
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


