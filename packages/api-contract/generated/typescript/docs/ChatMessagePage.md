
# ChatMessagePage


## Properties

Name | Type
------------ | -------------
`items` | [Array&lt;ChatMessage&gt;](ChatMessage.md)
`hasMore` | boolean
`nextBefore` | string

## Example

```typescript
import type { ChatMessagePage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "items": null,
  "hasMore": null,
  "nextBefore": null,
} satisfies ChatMessagePage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatMessagePage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


