
# ChatQuotationVersion


## Properties

Name | Type
------------ | -------------
`id` | string
`version` | number
`latest` | boolean
`state` | string
`publishedAt` | string
`expiresAt` | string
`contentHash` | string
`content` | [ChatQuotationContent](ChatQuotationContent.md)
`viewed` | boolean
`actions` | Array&lt;string&gt;

## Example

```typescript
import type { ChatQuotationVersion } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "version": null,
  "latest": null,
  "state": null,
  "publishedAt": null,
  "expiresAt": null,
  "contentHash": null,
  "content": null,
  "viewed": null,
  "actions": null,
} satisfies ChatQuotationVersion

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatQuotationVersion
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


