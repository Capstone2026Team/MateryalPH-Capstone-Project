
# CatalogImportJob


## Properties

Name | Type
------------ | -------------
`id` | string
`status` | string
`templateVersion` | string
`totalRows` | number
`validRows` | number
`errorRows` | number
`appliedRows` | number
`appliedAt` | string
`createdAt` | string
`rowErrors` | [Array&lt;CatalogImportRowError&gt;](CatalogImportRowError.md)
`rowErrorsMeta` | { [key: string]: any; }

## Example

```typescript
import type { CatalogImportJob } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "status": null,
  "templateVersion": null,
  "totalRows": null,
  "validRows": null,
  "errorRows": null,
  "appliedRows": null,
  "appliedAt": null,
  "createdAt": null,
  "rowErrors": null,
  "rowErrorsMeta": null,
} satisfies CatalogImportJob

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CatalogImportJob
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


