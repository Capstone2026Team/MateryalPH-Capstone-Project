
# ConversationDetail


## Properties

Name | Type
------------ | -------------
`conversation` | [ConversationView](ConversationView.md)
`messages` | [ChatMessagePage](ChatMessagePage.md)
`quotations` | [ChatQuotationPage](ChatQuotationPage.md)

## Example

```typescript
import type { ConversationDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "conversation": null,
  "messages": null,
  "quotations": null,
} satisfies ConversationDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ConversationDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


