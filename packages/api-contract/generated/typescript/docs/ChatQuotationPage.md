
# ChatQuotationPage


## Properties

Name | Type
------------ | -------------
`quotation` | [ChatQuotation](ChatQuotation.md)
`versions` | [Array&lt;ChatQuotationVersion&gt;](ChatQuotationVersion.md)
`hasMore` | boolean
`page` | number

## Example

```typescript
import type { ChatQuotationPage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "quotation": null,
  "versions": null,
  "hasMore": null,
  "page": null,
} satisfies ChatQuotationPage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatQuotationPage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


