
# SupportAttachment


## Properties

Name | Type
------------ | -------------
`id` | string
`originalName` | string
`contentType` | string
`byteSize` | number

## Example

```typescript
import type { SupportAttachment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "originalName": null,
  "contentType": null,
  "byteSize": null,
} satisfies SupportAttachment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupportAttachment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


