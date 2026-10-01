
# ChatAttachment


## Properties

Name | Type
------------ | -------------
`id` | string
`displayName` | string
`mediaType` | string
`sizeBytes` | number
`scanState` | string

## Example

```typescript
import type { ChatAttachment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "displayName": null,
  "mediaType": null,
  "sizeBytes": null,
  "scanState": null,
} satisfies ChatAttachment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatAttachment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


