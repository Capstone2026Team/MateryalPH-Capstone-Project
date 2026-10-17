
# DisputeEvidence


## Properties

Name | Type
------------ | -------------
`fileId` | string
`label` | string
`description` | string
`contentType` | string
`name` | string
`byteSize` | number
`url` | string
`expiresAt` | Date

## Example

```typescript
import type { DisputeEvidence } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fileId": null,
  "label": null,
  "description": null,
  "contentType": null,
  "name": null,
  "byteSize": null,
  "url": null,
  "expiresAt": null,
} satisfies DisputeEvidence

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeEvidence
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


