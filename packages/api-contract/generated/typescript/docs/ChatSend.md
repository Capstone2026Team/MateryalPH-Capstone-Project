
# ChatSend

Requires nonblank body or product_id (listing variant UUID), or both. The product must be an eligible product of this conversation store. Retries with the same client_message_id and content return the same message; changed content conflicts.

## Properties

Name | Type
------------ | -------------
`clientMessageId` | string
`body` | string
`productId` | string

## Example

```typescript
import type { ChatSend } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "clientMessageId": null,
  "body": null,
  "productId": null,
} satisfies ChatSend

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatSend
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


