
# ChatMessage


## Properties

Name | Type
------------ | -------------
`id` | string
`clientMessageId` | string
`body` | string
`kind` | string
`sender` | [ChatIdentity](ChatIdentity.md)
`sentAt` | string
`mine` | boolean
`attachments` | [Array&lt;ChatAttachment&gt;](ChatAttachment.md)
`readByRecipient` | boolean
`product` | [ChatProduct](ChatProduct.md)

## Example

```typescript
import type { ChatMessage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "clientMessageId": null,
  "body": null,
  "kind": null,
  "sender": null,
  "sentAt": null,
  "mine": null,
  "attachments": null,
  "readByRecipient": null,
  "product": null,
} satisfies ChatMessage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatMessage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


