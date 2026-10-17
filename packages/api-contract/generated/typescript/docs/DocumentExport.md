
# DocumentExport


## Properties

Name | Type
------------ | -------------
`id` | string
`resourceId` | string
`type` | string
`format` | string
`state` | string
`purpose` | string
`filters` | { [key: string]: any; }
`sourceHash` | string
`sourceVersions` | { [key: string]: any; }
`checksum` | string
`createdAt` | string
`expiresAt` | string
`failureCode` | string
`accessRecord` | [Array&lt;ExportAccessRecord&gt;](ExportAccessRecord.md)

## Example

```typescript
import type { DocumentExport } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "resourceId": null,
  "type": null,
  "format": null,
  "state": null,
  "purpose": null,
  "filters": null,
  "sourceHash": null,
  "sourceVersions": null,
  "checksum": null,
  "createdAt": null,
  "expiresAt": null,
  "failureCode": null,
  "accessRecord": null,
} satisfies DocumentExport

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DocumentExport
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


