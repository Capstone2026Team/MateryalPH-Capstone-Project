
# CatalogMedia


## Properties

Name | Type
------------ | -------------
`id` | string
`fileId` | string
`altText` | string
`status` | string
`version` | number
`replacesMediaId` | string
`contentType` | string
`byteSize` | number
`scanState` | string
`uploadedAt` | string

## Example

```typescript
import type { CatalogMedia } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "fileId": null,
  "altText": null,
  "status": null,
  "version": null,
  "replacesMediaId": null,
  "contentType": null,
  "byteSize": null,
  "scanState": null,
  "uploadedAt": null,
} satisfies CatalogMedia

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogMedia
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


