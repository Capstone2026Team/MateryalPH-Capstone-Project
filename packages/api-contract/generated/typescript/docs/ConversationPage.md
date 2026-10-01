
# ConversationPage


## Properties

Name | Type
------------ | -------------
`items` | [Array&lt;ConversationView&gt;](ConversationView.md)
`page` | number
`hasMore` | boolean

## Example

```typescript
import type { ConversationPage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "items": null,
  "page": null,
  "hasMore": null,
} satisfies ConversationPage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ConversationPage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


